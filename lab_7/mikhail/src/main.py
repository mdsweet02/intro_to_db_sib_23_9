import pyodbc
from tkinter import *
from tkinter import ttk, messagebox, simpledialog
import re

# Создаем главное окно
window = Tk()
window.title("База данных Фонотека")
window.geometry("1000x600")
window.configure(bg="#f0f0f0")

# Подключаемся к базе данных
connection = pyodbc.connect(
    "DRIVER=SQL Server Native Client 11.0;"
    "DATABASE=Phonoteka;"
    "Trusted_Connection=Yes;"
    "SERVER=."
)

cursor = connection.cursor()

# Получаем список таблиц из базы данных
cursor.execute("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE'")
table_list = cursor.fetchall()


notebook = ttk.Notebook(window)
notebook.pack(expand=True, fill=BOTH, padx=10, pady=10)

treeviews = {}
columns_info = {}

# Создаем вкладку для каждой таблицы
for table_item in table_list:
    table_name = table_item[0]
    
    tab_frame = ttk.Frame(notebook)
    notebook.add(tab_frame, text=table_name)
    
    # Добавляем вертикальный скроллбар
    scrollbar_y = Scrollbar(tab_frame)
    scrollbar_y.pack(side=RIGHT, fill=Y)
    
    # Добавляем горизонтальный скроллбар
    scrollbar_x = Scrollbar(tab_frame, orient=HORIZONTAL)
    scrollbar_x.pack(side=BOTTOM, fill=X)
    
    tree = ttk.Treeview(tab_frame, yscrollcommand=scrollbar_y.set, xscrollcommand=scrollbar_x.set)
    tree.pack(expand=True, fill=BOTH, padx=5, pady=5)
    
    # Настраиваем скроллбары
    scrollbar_y.config(command=tree.yview)
    scrollbar_x.config(command=tree.xview)
    
    treeviews[table_name] = tree
    
    cursor.execute(f"SELECT TOP 0 * FROM [{table_name}]")
    
    columns = []
    for column_info in cursor.description:
        columns.append(column_info[0])
    
    columns_info[table_name] = columns

# Функция для загрузки данных таблицы
def load_table_data(table_name):
    tree = treeviews[table_name]
    
    # Очищаем Treeview
    for item in tree.get_children():
        tree.delete(item)
    
    # Получаем данные из таблицы
    cursor.execute(f"SELECT * FROM [{table_name}]")
    data_rows = cursor.fetchall()
    columns = columns_info[table_name]
    
    # Настраиваем столбцы Treeview
    tree["columns"] = columns
    tree["show"] = "headings"
    
    
    for column_name in columns:
        tree.heading(column_name, text=column_name)
        tree.column(column_name, width=120, anchor=W)
    
    # Добавляем данные в Treeview
    for row in data_rows:
        clean_values = []
        for value in row:
            if isinstance(value, str):
                
                clean_value = re.sub(r"[()'\"']", "", value).strip()
                clean_values.append(clean_value)
            else:
                clean_values.append(value)
        
        tree.insert("", "end", values=clean_values)

# Функция для добавления записи
def add_new_record(table_name):
    columns = columns_info[table_name]
    values = []
    
    for column_name in columns:
        user_input = simpledialog.askstring("Добавить запись", f"Введите значение для {column_name}:")
        
        if user_input is None:
            return
        
        values.append(user_input)
    
    placeholders = ",".join(["?"] * len(values))
    
    column_names_bracketed = []
    for column in columns:
        column_names_bracketed.append(f"[{column}]")
    
    column_names = ",".join(column_names_bracketed)
    
    sql_query = f"INSERT INTO [{table_name}] ({column_names}) VALUES ({placeholders})"
    
    print(f"SQL запрос: {sql_query}")
    print(f"Значения: {values}")
    
    cursor.execute(sql_query, values)
    connection.commit()
    
    load_table_data(table_name)

# Функция для редактирования записи
def edit_existing_record(table_name):
    tree = treeviews[table_name]
    selected_items = tree.selection()
    
    if not selected_items:
        messagebox.showwarning("Редактировать", "Пожалуйста, выберите запись для редактирования")
        return
    
    selected_item = selected_items[0]
    item_data = tree.item(selected_item)
    current_values = item_data["values"]
    
    columns = columns_info[table_name]
    new_values = []
    

    for i in range(len(columns)):
        new_value = simpledialog.askstring("Редактировать запись", 
                                          f"Новое значение для {columns[i]}:", 
                                          initialvalue=current_values[i])
        
        if new_value is None:
            return
        
        new_values.append(new_value)
    

    set_parts = []
    for column_name in columns:
        set_parts.append(f"[{column_name}]=?")
    
    set_clause = ",".join(set_parts)
    

    primary_key_column = columns[0]
    
    sql_query = f"UPDATE [{table_name}] SET {set_clause} WHERE [{primary_key_column}]=?"

    print(f"SQL запрос UPDATE: {sql_query}")
    print(f"Новые значения: {new_values}")
    print(f"Старое значение первичного ключа: {current_values[0]}")
    
    cursor.execute(sql_query, new_values + [current_values[0]])
    connection.commit()
    
    load_table_data(table_name)

# Функция для удаления записи
def delete_selected_record(table_name):
    tree = treeviews[table_name]
    selected_items = tree.selection()
    
    if not selected_items:
        messagebox.showwarning("Удалить", "Пожалуйста, выберите запись для удаления")
        return
    
    # Получаем выбранную запись
    selected_item = selected_items[0]
    item_data = tree.item(selected_item)
    record_values = item_data["values"]
    
    columns = columns_info[table_name]
    primary_key_column = columns[0]
    
    # Подтверждаем удаление
    confirmation = messagebox.askyesno("Удалить запись", 
                                      f"Вы уверены, что хотите удалить запись с {primary_key_column}={record_values[0]}?")
    
    if confirmation:
        sql_query = f"DELETE FROM [{table_name}] WHERE [{primary_key_column}]=?"
        
        print(f"SQL запрос DELETE: {sql_query}")
        print(f"Значение для удаления: {record_values[0]}")
        
        cursor.execute(sql_query, [record_values[0]])
        connection.commit()
        
        load_table_data(table_name)

# Функция для получения текущей активной таблицы
def get_current_table():
    current_tab = notebook.select()
    table_name = notebook.tab(current_tab, "text")
    return table_name

# Панель с кнопками
button_panel = Frame(window, bg="#f0f0f0")
button_panel.pack(fill=X, padx=10, pady=5)

# Кнопка обновления
refresh_button = Button(button_panel, text="Обновить", 
                       command=lambda: load_table_data(get_current_table()))
refresh_button.pack(side=LEFT, padx=5)

# Кнопка добавления
add_button = Button(button_panel, text="Добавить", 
                    command=lambda: add_new_record(get_current_table()))
add_button.pack(side=LEFT, padx=5)

# Кнопка редактирования
edit_button = Button(button_panel, text="Редактировать", 
                     command=lambda: edit_existing_record(get_current_table()))
edit_button.pack(side=LEFT, padx=5)

# Кнопка удаления
delete_button = Button(button_panel, text="Удалить", 
                       command=lambda: delete_selected_record(get_current_table()))
delete_button.pack(side=LEFT, padx=5)


for table_name in treeviews.keys():
    load_table_data(table_name)


window.mainloop()
connection.close()