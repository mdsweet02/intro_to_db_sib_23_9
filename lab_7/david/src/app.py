# app_tk.py
import tkinter as tk
from tkinter import ttk, messagebox, simpledialog
import queries
from datetime import datetime

# Утилиты для GUI

def to_display(val):
    """Конвертация значения для отображения"""
    if val is None:
        return ""
    if isinstance(val, datetime):
        return val.strftime("%Y-%m-%d %H:%M:%S")
    return str(val)

# Основной класс приложения

class SRSPApp(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("SRSP2 - Tkinter CRUD")
        self.geometry("1000x600")

        top = tk.Frame(self)
        top.pack(fill=tk.X, padx=8, pady=6)

        tk.Label(top, text="Таблица:").pack(side=tk.LEFT)
        self.table_cb = ttk.Combobox(top, values=queries.get_tables(), state="readonly")
        self.table_cb.pack(side=tk.LEFT, padx=6)
        self.table_cb.bind("<<ComboboxSelected>>", lambda e: self.load_table())

        btn_frame = tk.Frame(top)
        btn_frame.pack(side=tk.RIGHT)

        tk.Button(btn_frame, text="Добавить", command=self.on_add).pack(side=tk.LEFT, padx=4)
        tk.Button(btn_frame, text="Изменить", command=self.on_edit).pack(side=tk.LEFT, padx=4)
        tk.Button(btn_frame, text="Удалить", command=self.on_delete).pack(side=tk.LEFT, padx=4)
        tk.Button(btn_frame, text="Обновить", command=self.load_table).pack(side=tk.LEFT, padx=4)

        self.tree = ttk.Treeview(self, show="headings")
        self.tree.pack(fill=tk.BOTH, expand=True, padx=8, pady=6)
        self.tree.bind("<Double-1>", lambda e: self.on_edit())

        bottom = tk.Frame(self)
        bottom.pack(fill=tk.X, padx=8, pady=6)
        tk.Button(bottom, text="Соревнования с датами", command=self.show_sorev_with_dates).pack(side=tk.LEFT)
        tk.Button(bottom, text="Победители (тек.год)", command=self.show_winners).pack(side=tk.LEFT, padx=6)

        self.status = tk.Label(bottom, text="Готов", anchor="w")
        self.status.pack(fill=tk.X, side=tk.RIGHT)

        tables = queries.get_tables()
        if tables:
            self.table_cb.set(tables[0])
            self.load_table()

    def set_status(self, text):
        self.status.config(text=text)

    def load_table(self):
        table = self.table_cb.get()
        if not table:
            return
        self.set_status(f"Загружаю {table} ...")
        # получаем колонки и все строки
        cols, rows = queries.fetch_all(table)
        # очистка tree
        for c in self.tree.get_children():
            self.tree.delete(c)
        self.tree["columns"] = cols
        # настроить заголовки
        for c in cols:
            self.tree.heading(c, text=c)
            self.tree.column(c, width=120, anchor="w")
        # вставка данных
        for r in rows:
            disp = [to_display(x) for x in r]
            self.tree.insert("", "end", values=disp)
        self.set_status(f"Таблица {table}: {len(rows)} строк")

    def on_add(self):
        table = self.table_cb.get()
        if not table:
            messagebox.showwarning("Ошибка", "Выберите таблицу")
            return
        self.open_editor(table, mode="add")

    def on_edit(self):
        table = self.table_cb.get()
        if not table:
            messagebox.showwarning("Ошибка", "Выберите таблицу")
            return
        sel = self.tree.selection()
        if not sel:
            messagebox.showwarning("Ошибка", "Выберите строку для редактирования")
            return
        values = self.tree.item(sel[0], "values")
        cols = self.tree["columns"]
        row = dict(zip(cols, values))
        # primary key: берем первую колонку как ключ (часто это OK)
        pk = cols[0]
        pk_value = row[pk]
        self.open_editor(table, mode="edit", pk_column=pk, pk_value=pk_value)

    def on_delete(self):
        table = self.table_cb.get()
        if not table:
            messagebox.showwarning("Ошибка", "Выберите таблицу")
            return
        sel = self.tree.selection()
        if not sel:
            messagebox.showwarning("Ошибка", "Выберите строку для удаления")
            return
        cols = self.tree["columns"]
        row_vals = self.tree.item(sel[0], "values")
        pk = cols[0]
        pk_value = row_vals[0]
        if not messagebox.askyesno("Подтвердите", f"Удалить запись {pk}={pk_value} из {table}?"):
            return
        try:
            queries.delete_row(table, pk, pk_value)
            self.load_table()
            self.set_status("Удалено")
        except Exception as e:
            messagebox.showerror("Ошибка удаления", str(e))
            self.set_status("Ошибка удаления")

    def open_editor(self, table, mode="add", pk_column=None, pk_value=None):
        """
        mode: 'add' или 'edit'
        если edit — загружаем данные и подставляем
        """
        cols_meta = queries.get_columns(table)  # list of tuples (name, dtype, is_nullable)
        col_names = [c[0] for c in cols_meta]

        # if edit: fetch row values from DB by pk (safer than from tree)
        initial = {}
        if mode == "edit":
            if pk_column is None or pk_value is None:
                messagebox.showerror("Ошибка", "Не указан ключ для редактирования")
                return
            sql = f"SELECT * FROM {table} WHERE [{pk_column}] = ?"
            _, rows = queries.fetch_custom(sql, (pk_value,))
            if not rows:
                messagebox.showerror("Ошибка", "Запись не найдена в БД")
                return
            row = rows[0]
            for i, name in enumerate(col_names):
                initial[name] = row[i]

        # build form
        win = tk.Toplevel(self)
        win.title(f"{'Добавить' if mode=='add' else 'Редактировать'}: {table}")
        frm = tk.Frame(win, padx=10, pady=10)
        frm.pack(fill=tk.BOTH, expand=True)

        entries = {}
        for i,(cname, dtype, isnul) in enumerate(cols_meta):
            lbl = tk.Label(frm, text=f"{cname} ({dtype})")
            lbl.grid(row=i, column=0, sticky="w", pady=4)
            ent = tk.Entry(frm, width=50)
            ent.grid(row=i, column=1, sticky="we", pady=4)
            val = initial.get(cname, "")
            if val is None:
                val = ""
            ent.insert(0, str(val))
            # если первичный ключ и в режиме редактирования — делаем поле readonly
            if mode == "edit" and i == 0:
                ent.config(state="readonly")
            entries[cname] = ent

        def on_save():
            # собираем данные из полей, пустую строку превращаем в None для nullable
            data = {}
            for cname, ent in entries.items():
                raw = ent.get().strip()
                if raw == "":
                    data[cname] = None
                else:
                    # простая привязка типов: int -> try int, date-like not converted (SQL Server driver поймёт строку)
                    try:
                        if raw.isdigit():
                            data[cname] = int(raw)
                        else:
                            data[cname] = raw
                    except:
                        data[cname] = raw
            try:
                if mode == "add":
                    # remove keys with None if NOT NULL? we leave to server constraints
                    queries.insert_row(table, data)
                    messagebox.showinfo("OK", "Запись добавлена")
                else:
                    # edit
                    key_val = entries[pk_column].get() if pk_column in entries else pk_value
                    queries.update_row(table, pk_column, pk_value, data)
                    messagebox.showinfo("OK", "Запись обновлена")
                win.destroy()
                self.load_table()
            except Exception as e:
                messagebox.showerror("Ошибка сохранения", str(e))

        btn = tk.Button(frm, text="Сохранить", command=on_save)
        btn.grid(row=len(cols_meta), column=0, pady=10)
        tk.Button(frm, text="Отмена", command=win.destroy).grid(row=len(cols_meta), column=1, pady=10)

    # quick reports
    def show_sorev_with_dates(self):
        cols, rows = queries.get_sorev_with_dates()
        # очистка
        for c in self.tree.get_children():
            self.tree.delete(c)
        self.tree["columns"] = cols
        for c in cols:
            self.tree.heading(c, text=c)
            self.tree.column(c, width=140)
        for r in rows:
            self.tree.insert("", "end", values=[to_display(x) for x in r])
        self.set_status(f"Соревнования: {len(rows)}")

    def show_winners(self):
        cols, rows = queries.get_winners_current_year()
        for c in self.tree.get_children():
            self.tree.delete(c)
        self.tree["columns"] = cols
        for c in cols:
            self.tree.heading(c, text=c)
            self.tree.column(c, width=200)
        for r in rows:
            self.tree.insert("", "end", values=[to_display(x) for x in r])
        self.set_status(f"Победители (тек.год): {len(rows)}")

# Запуск

if __name__ == "__main__":
    app = SRSPApp()
    app.mainloop()
