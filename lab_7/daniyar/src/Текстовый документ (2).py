import tkinter as tk
from tkinter import ttk, messagebox
import pyodbc


# ================== НАСТРОЙКИ БАЗЫ ДАННЫХ ==================

def get_connection():
    """
    Строка подключения под твой сервер.
    Здесь используется Windows-аутентификация (Trusted_Connection).
    """
    conn_str = (
        "DRIVER={ODBC Driver 17 for SQL Server};"
        "SERVER=localhost\\SQLEXPRESS;"              # <-- твой сервер
        "DATABASE=Дипломное_проектирование;"         # <-- твоя БД
        "TrustServerCertificate=yes;"
        "Trusted_Connection=yes;"
    )
    return pyodbc.connect(conn_str)


# =============== КЛАСС РАБОТЫ С БАЗОЙ ======================

class Database:
    def __init__(self):
        self.conn = get_connection()

    def fetch_all(self, table_name):
        cur = self.conn.cursor()
        cur.execute(f"SELECT * FROM {table_name}")
        rows = cur.fetchall()
        columns = [d[0] for d in cur.description]
        return rows, columns

    def insert(self, table_name, data_dict, skip_first=True):
        """
        data_dict: {col: value}
        skip_first=True — не вставлять первый столбец (обычно ID-identity).
        """
        items = list(data_dict.items())
        if skip_first and items:
            items = items[1:]  # пропустим ID

        if not items:
            return

        columns = ",".join(k for k, _ in items)
        placeholders = ",".join("?" for _ in items)
        values = [v for _, v in items]

        cur = self.conn.cursor()
        cur.execute(
            f"INSERT INTO {table_name} ({columns}) VALUES ({placeholders})",
            values
        )
        self.conn.commit()

    def update(self, table_name, data_dict, pk_column):
        """
        pk_column — имя PK (мы берём первый столбец).
        """
        pk_value = data_dict[pk_column]
        items = [(k, v) for k, v in data_dict.items() if k != pk_column]

        if not items:
            return

        set_clause = ", ".join(f"{k}=?" for k, _ in items)
        values = [v for _, v in items]
        values.append(pk_value)

        cur = self.conn.cursor()
        cur.execute(
            f"UPDATE {table_name} SET {set_clause} WHERE {pk_column}=?",
            values
        )
        self.conn.commit()

    def delete(self, table_name, pk_column, pk_value):
        cur = self.conn.cursor()
        cur.execute(
            f"DELETE FROM {table_name} WHERE {pk_column}=?",
            (pk_value,)
        )
        self.conn.commit()


# ================== UI ДЛЯ ОДНОЙ ТАБЛИЦЫ ===================

class TableFrame(ttk.Frame):
    def __init__(self, master, db: Database, table_name: str, title: str = None):
        super().__init__(master, padding=10)
        self.db = db
        self.table_name = table_name
        self.title = title or table_name

        self.columns = []
        self.entries = {}
        self.pk_column = None

        self.create_widgets()
        self.load_data()

    def create_widgets(self):
        # Заголовок
        lbl_title = ttk.Label(
            self,
            text=self.title,
            font=("Segoe UI", 14, "bold")
        )
        lbl_title.grid(row=0, column=0, columnspan=4, pady=(0, 10), sticky="w")

        # Таблица (Treeview)
        self.tree = ttk.Treeview(self, show="headings", height=12)
        self.tree.grid(row=1, column=0, columnspan=4,
                       sticky="nsew", pady=(0, 10))

        vsb = ttk.Scrollbar(self, orient="vertical", command=self.tree.yview)
        vsb.grid(row=1, column=4, sticky="ns", pady=(0, 10))
        self.tree.configure(yscrollcommand=vsb.set)

        self.tree.bind("<<TreeviewSelect>>", self.on_row_select)

        # Панель ввода (сначала пустая, потом создадим после load_data)
        self.inputs_frame = ttk.LabelFrame(self, text="Запись")
        self.inputs_frame.grid(row=2, column=0, columnspan=4,
                               sticky="ew", pady=(0, 10), ipadx=5, ipady=5)

        # Кнопки
        btn_frame = ttk.Frame(self)
        btn_frame.grid(row=3, column=0, columnspan=4, sticky="ew")

        self.btn_add = ttk.Button(
            btn_frame, text="Добавить", command=self.add_record)
        self.btn_update = ttk.Button(
            btn_frame, text="Обновить", command=self.update_record)
        self.btn_delete = ttk.Button(
            btn_frame, text="Удалить", command=self.delete_record)
        self.btn_clear = ttk.Button(
            btn_frame, text="Очистить поля", command=self.clear_entries)
        self.btn_refresh = ttk.Button(
            btn_frame, text="Обновить список", command=self.load_data)

        self.btn_add.grid(row=0, column=0, padx=5, pady=5)
        self.btn_update.grid(row=0, column=1, padx=5, pady=5)
        self.btn_delete.grid(row=0, column=2, padx=5, pady=5)
        self.btn_clear.grid(row=0, column=3, padx=5, pady=5)
        self.btn_refresh.grid(row=0, column=4, padx=5, pady=5)

        # Разметка
        self.grid_rowconfigure(1, weight=1)
        self.grid_columnconfigure(0, weight=1)

    def build_inputs(self):
        # Очищаем старые поля
        for widget in self.inputs_frame.winfo_children():
            widget.destroy()
        self.entries.clear()

        # предполагаем, что первый столбец — PK (ID)
        if self.columns:
            self.pk_column = self.columns[0]

        for i, col in enumerate(self.columns):
            lbl = ttk.Label(self.inputs_frame, text=col + ":")
            lbl.grid(row=i // 2, column=(i % 2) * 2,
                     sticky="e", padx=5, pady=3)

            entry = ttk.Entry(self.inputs_frame, width=35)
            entry.grid(row=i // 2, column=(i % 2) * 2 + 1,
                       sticky="w", padx=5, pady=3)

            # PK делаем только для чтения
            if col == self.pk_column:
                entry.configure(state="readonly")

            self.entries[col] = entry

    # ---------- Работа с данными ----------

    def load_data(self):
        try:
            rows, columns = self.db.fetch_all(self.table_name)
        except Exception as e:
            messagebox.showerror("Ошибка БД", str(e))
            return

        self.columns = columns
        self.tree.delete(*self.tree.get_children())
        self.tree["columns"] = self.columns

        for col in self.columns:
            self.tree.heading(col, text=col)
            self.tree.column(col, width=120, anchor="w")

        for row in rows:
            self.tree.insert("", "end", values=list(row))

        self.build_inputs()

    def on_row_select(self, event):
        selected = self.tree.selection()
        if not selected:
            return

        values = self.tree.item(selected[0], "values")
        for col, val in zip(self.columns, values):
            entry = self.entries[col]

            # временно разрешаем запись для PK
            if col == self.pk_column:
                entry.configure(state="normal")

            entry.delete(0, tk.END)
            entry.insert(0, val)

            # снова блокируем PK
            if col == self.pk_column:
                entry.configure(state="readonly")

    def collect_data(self):
        data = {}
        for col, entry in self.entries.items():
            value = entry.get()
            if isinstance(value, str):
                value = value.strip()
            data[col] = value
        return data

    def add_record(self):
        data = self.collect_data()
        try:
            self.db.insert(self.table_name, data_dict=data, skip_first=True)
        except Exception as e:
            messagebox.showerror("Ошибка добавления", str(e))
            return

        self.load_data()
        self.clear_entries()

    def update_record(self):
        data = self.collect_data()
        if not self.pk_column or not data.get(self.pk_column):
            messagebox.showwarning(
                "Нет ID", "Сначала выберите запись в таблице.")
            return
        try:
            self.db.update(self.table_name, data_dict=data,
                           pk_column=self.pk_column)
        except Exception as e:
            messagebox.showerror("Ошибка обновления", str(e))
            return

        self.load_data()

    def delete_record(self):
        if not self.pk_column:
            return

        data = self.collect_data()
        pk_val = data.get(self.pk_column)
        if not pk_val:
            messagebox.showwarning(
                "Нет ID", "Сначала выберите запись, которую нужно удалить.")
            return

        if not messagebox.askyesno("Подтверждение",
                                   f"Удалить запись с {self.pk_column}={pk_val}?"):
            return

        try:
            self.db.delete(self.table_name, self.pk_column, pk_val)
        except Exception as e:
            messagebox.showerror("Ошибка удаления", str(e))
            return

        self.load_data()
        self.clear_entries()

    def clear_entries(self):
        for col, entry in self.entries.items():
            # для PK временно снимаем readonly
            if col == self.pk_column:
                entry.configure(state="normal")

            entry.delete(0, tk.END)

            if col == self.pk_column:
                entry.configure(state="readonly")


# ================== ГЛАВНОЕ ОКНО ===========================

class MainApp(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("Дипломное проектирование – CRUD система")

        # чуть-чуть красоты
        self.geometry("1100x650")
        self.minsize(900, 550)

        style = ttk.Style()
        style.theme_use("clam")
        style.configure("TNotebook.Tab", font=("Segoe UI", 11))
        style.configure("TButton", font=("Segoe UI", 10))
        style.configure("Treeview.Heading", font=("Segoe UI", 10, "bold"))

        self.db = Database()
        self.create_ui()

    def create_ui(self):
        notebook = ttk.Notebook(self)
        notebook.pack(fill="both", expand=True, padx=10, pady=10)

        # Здесь пропиши ИМЕНА ТАБЛИЦ ТАК, КАК ОНИ В БД
        tables = [
            ("dbo.Студенты", "Студенты"),
            ("dbo.Преподаватели", "Преподаватели"),
            ("dbo.Проекты", "Проекты"),
            ("dbo.Кафедры", "Кафедры"),
            ("dbo.Рецензенты_члены_ГАК", "Рецензенты / члены ГАК"),
            ("dbo.Специальности", "Специальности"),
        ]

        for table_name, title in tables:
            frame = TableFrame(notebook, self.db, table_name, title)
            notebook.add(frame, text=title)


if __name__ == "__main__":
    try:
        app = MainApp()
        app.mainloop()
    except pyodbc.Error as e:
        messagebox.showerror("Ошибка подключения к БД", str(e))


# ================== НАСТРОЙКИ БАЗЫ ДАННЫХ ==================

def get_connection():
    """
    Строка подключения под твой сервер.
    Здесь используется Windows-аутентификация (Trusted_Connection).
    """
    conn_str = (
        "DRIVER={ODBC Driver 17 for SQL Server};"
        "SERVER=localhost\\SQLEXPRESS;"              # <-- твой сервер
        "DATABASE=Дипломное_проектирование;"         # <-- твоя БД
        "TrustServerCertificate=yes;"
        "Trusted_Connection=yes;"
    )
    return pyodbc.connect(conn_str)


# =============== КЛАСС РАБОТЫ С БАЗОЙ ======================

class Database:
    def __init__(self):
        self.conn = get_connection()

    def fetch_all(self, table_name):
        cur = self.conn.cursor()
        cur.execute(f"SELECT * FROM {table_name}")
        rows = cur.fetchall()
        columns = [d[0] for d in cur.description]
        return rows, columns

    def insert(self, table_name, data_dict, skip_first=True):
        """
        data_dict: {col: value}
        skip_first=True — не вставлять первый столбец (обычно ID-identity).
        """
        items = list(data_dict.items())
        if skip_first and items:
            items = items[1:]  # пропустим ID

        if not items:
            return

        columns = ",".join(k for k, _ in items)
        placeholders = ",".join("?" for _ in items)
        values = [v for _, v in items]

        cur = self.conn.cursor()
        cur.execute(
            f"INSERT INTO {table_name} ({columns}) VALUES ({placeholders})",
            values
        )
        self.conn.commit()

    def update(self, table_name, data_dict, pk_column):
        """
        pk_column — имя PK (мы берём первый столбец).
        """
        pk_value = data_dict[pk_column]
        items = [(k, v) for k, v in data_dict.items() if k != pk_column]

        if not items:
            return

        set_clause = ", ".join(f"{k}=?" for k, _ in items)
        values = [v for _, v in items]
        values.append(pk_value)

        cur = self.conn.cursor()
        cur.execute(
            f"UPDATE {table_name} SET {set_clause} WHERE {pk_column}=?",
            values
        )
        self.conn.commit()

    def delete(self, table_name, pk_column, pk_value):
        cur = self.conn.cursor()
        cur.execute(
            f"DELETE FROM {table_name} WHERE {pk_column}=?",
            (pk_value,)
        )
        self.conn.commit()


# ================== UI ДЛЯ ОДНОЙ ТАБЛИЦЫ ===================

class TableFrame(ttk.Frame):
    def __init__(self, master, db: Database, table_name: str, title: str = None):
        super().__init__(master, padding=10)
        self.db = db
        self.table_name = table_name
        self.title = title or table_name

        self.columns = []
        self.entries = {}
        self.pk_column = None

        self.create_widgets()
        self.load_data()

    def create_widgets(self):
        # Заголовок
        lbl_title = ttk.Label(
            self,
            text=self.title,
            font=("Segoe UI", 14, "bold")
        )
        lbl_title.grid(row=0, column=0, columnspan=4, pady=(0, 10), sticky="w")

        # Таблица (Treeview)
        self.tree = ttk.Treeview(self, show="headings", height=12)
        self.tree.grid(row=1, column=0, columnspan=4,
                       sticky="nsew", pady=(0, 10))

        vsb = ttk.Scrollbar(self, orient="vertical", command=self.tree.yview)
        vsb.grid(row=1, column=4, sticky="ns", pady=(0, 10))
        self.tree.configure(yscrollcommand=vsb.set)

        self.tree.bind("<<TreeviewSelect>>", self.on_row_select)

        # Панель ввода (сначала пустая, потом создадим после load_data)
        self.inputs_frame = ttk.LabelFrame(self, text="Запись")
        self.inputs_frame.grid(row=2, column=0, columnspan=4,
                               sticky="ew", pady=(0, 10), ipadx=5, ipady=5)

        # Кнопки
        btn_frame = ttk.Frame(self)
        btn_frame.grid(row=3, column=0, columnspan=4, sticky="ew")

        self.btn_add = ttk.Button(
            btn_frame, text="Добавить", command=self.add_record)
        self.btn_update = ttk.Button(
            btn_frame, text="Обновить", command=self.update_record)
        self.btn_delete = ttk.Button(
            btn_frame, text="Удалить", command=self.delete_record)
        self.btn_clear = ttk.Button(
            btn_frame, text="Очистить поля", command=self.clear_entries)
        self.btn_refresh = ttk.Button(
            btn_frame, text="Обновить список", command=self.load_data)

        self.btn_add.grid(row=0, column=0, padx=5, pady=5)
        self.btn_update.grid(row=0, column=1, padx=5, pady=5)
        self.btn_delete.grid(row=0, column=2, padx=5, pady=5)
        self.btn_clear.grid(row=0, column=3, padx=5, pady=5)
        self.btn_refresh.grid(row=0, column=4, padx=5, pady=5)

        # Разметка
        self.grid_rowconfigure(1, weight=1)
        self.grid_columnconfigure(0, weight=1)

    def build_inputs(self):
        # Очищаем старые поля
        for widget in self.inputs_frame.winfo_children():
            widget.destroy()
        self.entries.clear()

        # предполагаем, что первый столбец — PK (ID)
        if self.columns:
            self.pk_column = self.columns[0]

        for i, col in enumerate(self.columns):
            lbl = ttk.Label(self.inputs_frame, text=col + ":")
            lbl.grid(row=i // 2, column=(i % 2) * 2,
                     sticky="e", padx=5, pady=3)

            entry = ttk.Entry(self.inputs_frame, width=35)
            entry.grid(row=i // 2, column=(i % 2) * 2 + 1,
                       sticky="w", padx=5, pady=3)

            # PK делаем только для чтения
            if col == self.pk_column:
                entry.configure(state="readonly")

            self.entries[col] = entry

    # ---------- Работа с данными ----------

    def load_data(self):
        try:
            rows, columns = self.db.fetch_all(self.table_name)
        except Exception as e:
            messagebox.showerror("Ошибка БД", str(e))
            return

        self.columns = columns
        self.tree.delete(*self.tree.get_children())
        self.tree["columns"] = self.columns

        for col in self.columns:
            self.tree.heading(col, text=col)
            self.tree.column(col, width=120, anchor="w")

        for row in rows:
            self.tree.insert("", "end", values=list(row))

        self.build_inputs()

    def on_row_select(self, event):
        selected = self.tree.selection()
        if not selected:
            return

        values = self.tree.item(selected[0], "values")
        for col, val in zip(self.columns, values):
            entry = self.entries[col]

            # временно разрешаем запись для PK
            if col == self.pk_column:
                entry.configure(state="normal")

            entry.delete(0, tk.END)
            entry.insert(0, val)

            # снова блокируем PK
            if col == self.pk_column:
                entry.configure(state="readonly")

    def collect_data(self):
        data = {}
        for col, entry in self.entries.items():
            value = entry.get()
            if isinstance(value, str):
                value = value.strip()
            data[col] = value
        return data

    def add_record(self):
        data = self.collect_data()
        try:
            self.db.insert(self.table_name, data_dict=data, skip_first=True)
        except Exception as e:
            messagebox.showerror("Ошибка добавления", str(e))
            return

        self.load_data()
        self.clear_entries()

    def update_record(self):
        data = self.collect_data()
        if not self.pk_column or not data.get(self.pk_column):
            messagebox.showwarning(
                "Нет ID", "Сначала выберите запись в таблице.")
            return
        try:
            self.db.update(self.table_name, data_dict=data,
                           pk_column=self.pk_column)
        except Exception as e:
            messagebox.showerror("Ошибка обновления", str(e))
            return

        self.load_data()

    def delete_record(self):
        if not self.pk_column:
            return

        data = self.collect_data()
        pk_val = data.get(self.pk_column)
        if not pk_val:
            messagebox.showwarning(
                "Нет ID", "Сначала выберите запись, которую нужно удалить.")
            return

        if not messagebox.askyesno("Подтверждение",
                                   f"Удалить запись с {self.pk_column}={pk_val}?"):
            return

        try:
            self.db.delete(self.table_name, self.pk_column, pk_val)
        except Exception as e:
            messagebox.showerror("Ошибка удаления", str(e))
            return

        self.load_data()
        self.clear_entries()

    def clear_entries(self):
        for col, entry in self.entries.items():
            # для PK временно снимаем readonly
            if col == self.pk_column:
                entry.configure(state="normal")

            entry.delete(0, tk.END)

            if col == self.pk_column:
                entry.configure(state="readonly")


# ================== ГЛАВНОЕ ОКНО ===========================

class MainApp(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("Дипломное проектирование – CRUD система")

        # чуть-чуть красоты
        self.geometry("1100x650")
        self.minsize(900, 550)

        style = ttk.Style()
        style.theme_use("clam")
        style.configure("TNotebook.Tab", font=("Segoe UI", 11))
        style.configure("TButton", font=("Segoe UI", 10))
        style.configure("Treeview.Heading", font=("Segoe UI", 10, "bold"))

        self.db = Database()
        self.create_ui()

    def create_ui(self):
        notebook = ttk.Notebook(self)
        notebook.pack(fill="both", expand=True, padx=10, pady=10)

        # Здесь пропиши ИМЕНА ТАБЛИЦ ТАК, КАК ОНИ В БД
        tables = [
            ("dbo.Студенты", "Студенты"),
            ("dbo.Преподаватели", "Преподаватели"),
            ("dbo.Проекты", "Проекты"),
            ("dbo.Кафедры", "Кафедры"),
            ("dbo.Рецензенты_члены_ГАК", "Рецензенты / члены ГАК"),
            ("dbo.Специальности", "Специальности"),
        ]

        for table_name, title in tables:
            frame = TableFrame(notebook, self.db, table_name, title)
            notebook.add(frame, text=title)


if __name__ == "__main__":
    try:
        app = MainApp()
        app.mainloop()
    except pyodbc.Error as e:
        messagebox.showerror("Ошибка подключения к БД", str(e))
