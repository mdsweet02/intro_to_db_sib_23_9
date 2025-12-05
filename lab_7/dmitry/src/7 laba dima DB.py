import sys
import pyodbc
import pandas as pd
from PyQt5.QtWidgets import (
    QApplication, QMainWindow, QAction, QMessageBox,
    QWidget, QVBoxLayout, QHBoxLayout, QTableWidget, QTableWidgetItem,
    QPushButton, QLineEdit, QTextEdit, QLabel, QInputDialog
)

# --------------------- Подключение к БД ---------------------
def get_connection():
    try:
        conn = pyodbc.connect(
            "DRIVER={SQL Server};"
            "SERVER=.\SQLEXPRESS;"       # <-- укажи свой сервер
            "DATABASE=ChemLab;"       # <-- укажи свою базу
            "Trusted_Connection=yes;"
        )
        return conn
    except Exception as e:
        print("Connection error:", e)
        return None

def execute_query(query, params=None):
    conn = get_connection()
    if not conn:
        return []
    cursor = conn.cursor()
    try:
        if params:
            cursor.execute(query, params)
        else:
            cursor.execute(query)
        try:
            rows = cursor.fetchall()
            keys = [column[0] for column in cursor.description]
            results = [{keys[i]: row[i] for i in range(len(keys))} for row in rows]
            return results
        except:
            conn.commit()
            return []
    except Exception as e:
        print("Query error:", e)
        return []
    finally:
        cursor.close()
        conn.close()

# --------------------- Форма для таблиц ---------------------
class TableForm(QWidget):
    def __init__(self, table_name, columns, editable=False):
        super().__init__()
        self.setWindowTitle(f"Таблица {table_name}")
        self.resize(800, 500)
        self.table_name = table_name
        self.columns = columns
        self.editable = editable

        self.layout = QVBoxLayout()
        self.setLayout(self.layout)

        # Таблица
        self.table = QTableWidget()
        self.layout.addWidget(self.table)

        # Кнопки CRUD
        btn_layout = QHBoxLayout()
        self.load_btn = QPushButton("Загрузить данные")
        self.load_btn.clicked.connect(self.load_data)
        btn_layout.addWidget(self.load_btn)

        self.insert_btn = QPushButton("Добавить запись")
        self.insert_btn.clicked.connect(self.insert_record)
        btn_layout.addWidget(self.insert_btn)

        self.update_btn = QPushButton("Редактировать запись")
        self.update_btn.clicked.connect(self.update_record)
        btn_layout.addWidget(self.update_btn)

        self.delete_btn = QPushButton("Удалить запись")
        self.delete_btn.clicked.connect(self.delete_record)
        btn_layout.addWidget(self.delete_btn)

        self.layout.addLayout(btn_layout)

        self.load_data()

    def load_data(self):
        query = f"SELECT * FROM {self.table_name}"
        rows = execute_query(query)
        self.table.setRowCount(len(rows))
        self.table.setColumnCount(len(self.columns))
        self.table.setHorizontalHeaderLabels(self.columns)
        for i, row in enumerate(rows):
            for j, col in enumerate(self.columns):
                self.table.setItem(i, j, QTableWidgetItem(str(row[self.columns[j]])))

    def insert_record(self):
        values = []
        for col in self.columns[1:]:  # пропускаем ID
            val, ok = QInputDialog.getText(self, "Добавить запись", f"{col}:")
            if not ok:
                return
            values.append(val)
        placeholders = ','.join(['?']*len(values))
        query = f"INSERT INTO {self.table_name} ({','.join(self.columns[1:])}) VALUES ({placeholders})"
        execute_query(query, tuple(values))
        QMessageBox.information(self, "Успех", "Запись добавлена!")
        self.load_data()

    def update_record(self):
        row = self.table.currentRow()
        if row < 0:
            QMessageBox.warning(self, "Ошибка", "Выберите строку для редактирования")
            return
        record_id = self.table.item(row, 0).text()
        values = []
        for j, col in enumerate(self.columns[1:], start=1):
            current_val = self.table.item(row, j).text()
            val, ok = QInputDialog.getText(self, "Редактировать запись", f"{col}:", text=current_val)
            if not ok:
                return
            values.append(val)
        set_clause = ','.join([f"{col}=?" for col in self.columns[1:]])
        query = f"UPDATE {self.table_name} SET {set_clause} WHERE {self.columns[0]}=?"
        execute_query(query, tuple(values + [record_id]))
        QMessageBox.information(self, "Успех", "Запись обновлена!")
        self.load_data()

    def delete_record(self):
        row = self.table.currentRow()
        if row < 0:
            QMessageBox.warning(self, "Ошибка", "Выберите строку для удаления")
            return
        record_id = self.table.item(row, 0).text()
        query = f"DELETE FROM {self.table_name} WHERE {self.columns[0]}=?"
        execute_query(query, (record_id,))
        QMessageBox.information(self, "Успех", "Запись удалена!")
        self.load_data()

# --------------------- Главное окно ---------------------
class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Химическая лаборатория")
        self.resize(1000, 600)

        # Меню
        menubar = self.menuBar()

        # Таблицы
        menu_tables = menubar.addMenu("Таблицы")
        action_melts = QAction("Плавки", self)
        action_melts.triggered.connect(lambda: self.open_table("Melts", ["MeltID","MarkID","DeptID","FurnaceID","MeltDate","Tons"]))
        menu_tables.addAction(action_melts)

        action_marks = QAction("Марки стали", self)
        action_marks.triggered.connect(lambda: self.open_table("SteelMarks", ["MarkID","MarkName"]))
        menu_tables.addAction(action_marks)

        action_components = QAction("Компоненты", self)
        action_components.triggered.connect(lambda: self.open_table("MeltComponents", ["MeltID","ElementID","Amount"]))
        menu_tables.addAction(action_components)

        # SQL запросы
        menu_query = menubar.addMenu("SQL")
        action_sql = QAction("Выполнить SQL", self)
        action_sql.triggered.connect(self.open_sql_dialog)
        menu_query.addAction(action_sql)

        # Отчеты
        menu_report = menubar.addMenu("Отчеты")
        action_report = QAction("Отчет по плавкам", self)
        action_report.triggered.connect(self.generate_report)
        menu_report.addAction(action_report)

        # Справка
        menu_help = menubar.addMenu("Справка")
        action_help = QAction("Справка", self)
        action_help.triggered.connect(self.show_help)
        menu_help.addAction(action_help)

    def open_table(self, table_name, columns):
        self.form = TableForm(table_name, columns)
        self.form.show()

    def open_sql_dialog(self):
        dialog = SQLDialog()
        dialog.exec_()

    def generate_report(self):
        query = "SELECT MarkID, SUM(Tons) AS TotalTons FROM Melts GROUP BY MarkID"
        rows = execute_query(query)
        if not rows:
            QMessageBox.warning(self, "Отчет", "Нет данных для отчета")
            return
        df = pd.DataFrame(rows)
        df.to_excel("MeltReport.xlsx", index=False)
        QMessageBox.information(self, "Отчет", "Отчет создан: MeltReport.xlsx")

    def show_help(self):
        QMessageBox.information(self, "Справка",
            "- Меню Таблицы: CRUD для таблиц\n"
            "- SQL: ввод и выполнение запросов\n"
            "- Отчеты: создание Excel отчета\n"
            "- Справка: просмотр справочной информации"
        )

# --------------------- SQL Диалог ---------------------
from PyQt5.QtWidgets import QDialog

class SQLDialog(QDialog):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Выполнить SQL")
        self.resize(800, 400)
        layout = QVBoxLayout()
        self.setLayout(layout)

        self.query_edit = QTextEdit()
        layout.addWidget(self.query_edit)

        self.run_btn = QPushButton("RUN")
        self.run_btn.clicked.connect(self.run_query)
        layout.addWidget(self.run_btn)

        self.result_table = QTableWidget()
        layout.addWidget(self.result_table)

    def run_query(self):
        query = self.query_edit.toPlainText()
        rows = execute_query(query)
        if not rows:
            QMessageBox.information(self, "Результат", "NO RESULTS")
            return
        keys = list(rows[0].keys())
        self.result_table.setColumnCount(len(keys))
        self.result_table.setRowCount(len(rows))
        self.result_table.setHorizontalHeaderLabels(keys)
        for i, row in enumerate(rows):
            for j, key in enumerate(keys):
                self.result_table.setItem(i, j, QTableWidgetItem(str(row[key])))

# --------------------- Запуск ---------------------
if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec_())
