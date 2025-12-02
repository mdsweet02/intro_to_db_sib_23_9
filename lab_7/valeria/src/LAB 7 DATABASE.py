import sys
import pyodbc
import pandas as pd
from PyQt5 import QtWidgets, QtGui, QtCore
from PyQt5.QtWidgets import (
    QAction, QTableWidgetItem, QMessageBox, QDialog, QFormLayout,
    QLineEdit, QDialogButtonBox, QLabel, QVBoxLayout, QPushButton, QWidget, QHBoxLayout
)

# ---------- Подключение к базе ----------
def get_connection():
    return pyodbc.connect(
        r"DRIVER={ODBC Driver 17 for SQL Server};"
        r"SERVER=.\SQLEXPRESS;"
        r"DATABASE=UchetObrascheniy;"
        r"Trusted_Connection=yes;"
    )

# ---------- Форма для ввода/редактирования ----------
class RecordDialog(QDialog):
    def __init__(self, table_name, columns, values=None):
        super().__init__()
        self.setWindowTitle(f"{'Редактирование' if values else 'Добавление'} записи в {table_name}")
        self.setStyleSheet("background-color: #FFF8DC; font-size: 14px;")
        self.layout = QFormLayout(self)
        self.inputs = {}
        for i, col in enumerate(columns):
            line = QLineEdit()
            if values:
                line.setText(str(values[i]))
            self.layout.addRow(f"{col}:", line)
            self.inputs[col] = line
        self.buttons = QDialogButtonBox(QDialogButtonBox.Ok | QDialogButtonBox.Cancel)
        self.buttons.accepted.connect(self.accept)
        self.buttons.rejected.connect(self.reject)
        self.layout.addWidget(self.buttons)
    
    def get_data(self):
        return {col: self.inputs[col].text() for col in self.inputs}

# ---------- Главное окно ----------
class MainWindow(QtWidgets.QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Учет обращений – клиентское приложение")
        self.resize(1100, 700)
        self.setStyleSheet("background-color: #F0FFFF; font-size: 14px;")

        # ---------- Меню ----------
        menubar = self.menuBar()
        tables_menu = menubar.addMenu("Таблицы")
        reports_menu = menubar.addMenu("Отчёты")
        help_menu = menubar.addMenu("Справка")

        # Таблицы
        self.current_table = None
        self.table_name = ''
        self.table_widget = QtWidgets.QTableWidget()

        self.tables = ["Документы", "Подразделения", "Сотрудники", "Статус_документа", 
                       "Анкета_заявителя", "Регистрация", "Движение", "Резолюция"]
        for t in self.tables:
            action = QAction(t, self)
            action.triggered.connect(lambda checked, name=t: self.load_table(name))
            tables_menu.addAction(action)

        # Отчёты
        action_report = QAction("Экспорт текущей таблицы в Excel", self)
        action_report.triggered.connect(self.export_to_excel)
        reports_menu.addAction(action_report)

        # Справка
        action_help = QAction("О приложении", self)
        action_help.triggered.connect(self.show_help)
        help_menu.addAction(action_help)

        # ---------- Кнопки действий ----------
        self.add_button = QPushButton("Добавить запись")
        self.edit_button = QPushButton("Редактировать запись")
        self.delete_button = QPushButton("Удалить запись")
        self.refresh_button = QPushButton("Обновить таблицу")
        self.query_button = QPushButton("Выполнить SQL-запрос")

        # Цвет кнопок
        self.add_button.setStyleSheet("background-color: #90EE90; font-weight:bold;")
        self.edit_button.setStyleSheet("background-color: #FFD700; font-weight:bold;")
        self.delete_button.setStyleSheet("background-color: #FF6347; font-weight:bold;")
        self.refresh_button.setStyleSheet("background-color: #87CEFA; font-weight:bold;")
        self.query_button.setStyleSheet("background-color: #DA70D6; font-weight:bold;")

        self.add_button.clicked.connect(self.add_record)
        self.edit_button.clicked.connect(self.edit_record)
        self.delete_button.clicked.connect(self.delete_record)
        self.refresh_button.clicked.connect(self.refresh_table)
        self.query_button.clicked.connect(self.run_query)

        button_layout = QHBoxLayout()
        button_layout.addWidget(self.add_button)
        button_layout.addWidget(self.edit_button)
        button_layout.addWidget(self.delete_button)
        button_layout.addWidget(self.refresh_button)
        button_layout.addWidget(self.query_button)

        # ---------- Поле для SQL-запроса ----------
        self.query_edit = QtWidgets.QTextEdit()
        self.query_edit.setFixedHeight(80)
        self.query_edit.setStyleSheet("background-color: #E6E6FA; font-size: 14px;")

        # ---------- Таблица для результатов запросов ----------
        self.query_table = QtWidgets.QTableWidget()
        self.query_table.setStyleSheet("background-color: #FFFFFF;")

        # ---------- Layout ----------
        container = QWidget()
        main_layout = QVBoxLayout(container)
        main_layout.addLayout(button_layout)
        main_layout.addWidget(self.table_widget)
        main_layout.addWidget(QLabel("Введите SQL-запрос:"))
        main_layout.addWidget(self.query_edit)
        main_layout.addWidget(QLabel("Результаты запроса:"))
        main_layout.addWidget(self.query_table)
        self.setCentralWidget(container)

    # ---------- Методы ----------
    def load_table(self, table_name):
        self.table_name = table_name
        conn = get_connection()
        query = f"SELECT * FROM {table_name}"
        df = pd.read_sql(query, conn)
        conn.close()
        self.populate_table(df)

    def populate_table(self, df):
        self.df = df
        self.table_widget.setRowCount(df.shape[0])
        self.table_widget.setColumnCount(df.shape[1])
        self.table_widget.setHorizontalHeaderLabels(df.columns)
        self.table_widget.setStyleSheet(
            "QHeaderView::section {background-color: #FFA07A; font-weight:bold;} "
            "QTableWidget {gridline-color: #000000;}"
        )
        for i in range(df.shape[0]):
            for j in range(df.shape[1]):
                item = QTableWidgetItem(str(df.iat[i, j]))
                item.setBackground(QtGui.QColor("#F5F5DC") if i % 2 == 0 else QtGui.QColor("#E6E6FA"))
                self.table_widget.setItem(i, j, item)
        self.table_widget.resizeColumnsToContents()

    def add_record(self):
        if not self.table_name: return
        dialog = RecordDialog(self.table_name, self.df.columns)
        if dialog.exec_() == QDialog.Accepted:
            data = dialog.get_data()
            cols = ','.join(data.keys())
            vals = ','.join(f"'{v}'" for v in data.values())
            try:
                conn = get_connection()
                cursor = conn.cursor()
                cursor.execute(f"INSERT INTO {self.table_name} ({cols}) VALUES ({vals})")
                conn.commit()
                conn.close()
                self.refresh_table()
            except Exception as e:
                QMessageBox.critical(self, "Ошибка", f"Не удалось добавить запись:\n{e}")

    def edit_record(self):
        if not self.table_name or self.table_widget.currentRow() < 0: return
        row_idx = self.table_widget.currentRow()
        values = [self.table_widget.item(row_idx, col).text() for col in range(self.table_widget.columnCount())]
        dialog = RecordDialog(self.table_name, self.df.columns, values)
        if dialog.exec_() == QDialog.Accepted:
            data = dialog.get_data()
            set_clause = ', '.join([f"{k}='{v}'" for k,v in data.items()])
            key_col = self.df.columns[0]
            key_val = values[0]
            try:
                conn = get_connection()
                cursor = conn.cursor()
                cursor.execute(f"UPDATE {self.table_name} SET {set_clause} WHERE {key_col}='{key_val}'")
                conn.commit()
                conn.close()
                self.refresh_table()
            except Exception as e:
                QMessageBox.critical(self, "Ошибка", f"Не удалось обновить запись:\n{e}")

    def delete_record(self):
        if not self.table_name or self.table_widget.currentRow() < 0: return
        row_idx = self.table_widget.currentRow()
        key_col = self.df.columns[0]
        key_val = self.table_widget.item(row_idx, 0).text()
        reply = QMessageBox.question(self, "Подтверждение", f"Удалить запись с {key_col}={key_val}?", QMessageBox.Yes | QMessageBox.No)
        if reply == QMessageBox.Yes:
            try:
                conn = get_connection()
                cursor = conn.cursor()
                cursor.execute(f"DELETE FROM {self.table_name} WHERE {key_col}='{key_val}'")
                conn.commit()
                conn.close()
                self.refresh_table()
            except Exception as e:
                QMessageBox.critical(self, "Ошибка", f"Не удалось удалить запись:\n{e}")

    def refresh_table(self):
        if self.table_name:
            self.load_table(self.table_name)

    def export_to_excel(self):
        if not hasattr(self, 'df') or self.df.empty:
            QMessageBox.warning(self, "Ошибка", "Нет данных для экспорта!")
            return
        path, _ = QtWidgets.QFileDialog.getSaveFileName(self, "Сохранить отчёт", "", "Excel Files (*.xlsx)")
        if path:
            self.df.to_excel(path, index=False)
            QMessageBox.information(self, "Готово", f"Таблица сохранена в {path}")

    def show_help(self):
        QMessageBox.information(self, "Справка", "Это клиентское приложение для работы с базой данных.\n\n"
                                "Вы можете:\n- просматривать таблицы\n- добавлять, редактировать, удалять записи\n"
                                "- экспортировать таблицы в Excel\n- выполнять SQL-запросы\n- использовать меню для навигации")

    def run_query(self):
        query = self.query_edit.toPlainText()
        if not query.strip():
            QMessageBox.warning(self, "Ошибка", "Введите SQL-запрос!")
            return
        try:
            conn = get_connection()
            df = pd.read_sql(query, conn)
            conn.close()
            # Отображение результата в таблице запросов
            self.query_table.setRowCount(df.shape[0])
            self.query_table.setColumnCount(df.shape[1])
            self.query_table.setHorizontalHeaderLabels(df.columns)
            for i in range(df.shape[0]):
                for j in range(df.shape[1]):
                    item = QTableWidgetItem(str(df.iat[i, j]))
                    item.setBackground(QtGui.QColor("#F0FFF0") if i % 2 == 0 else QtGui.QColor("#FFF0F5"))
                    self.query_table.setItem(i, j, item)
            self.query_table.resizeColumnsToContents()
        except Exception as e:
            QMessageBox.critical(self, "Ошибка запроса", str(e))

# ---------- Запуск приложения ----------
if __name__ == "__main__":
    app = QtWidgets.QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec_())
