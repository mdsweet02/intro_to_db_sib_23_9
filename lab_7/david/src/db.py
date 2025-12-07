# db.py
import pyodbc

SERVER_NAME = "ENOT1568"   # <- сервер
DATABASE_NAME = "SRSP2"    # <- имя базы

def get_connection():
    """
    Возвращает pyodbc.Connection. Использует Trusted_Connection (Windows Auth).
    """
    conn_str = (
        "DRIVER={SQL Server};"
        f"SERVER={SERVER_NAME};"
        f"DATABASE={DATABASE_NAME};"
        "Trusted_Connection=yes;"
    )
    return pyodbc.connect(conn_str)
