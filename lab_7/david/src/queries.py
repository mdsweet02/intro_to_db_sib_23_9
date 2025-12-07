# queries.py
from db import get_connection

def get_tables():
    """
    Возвращает список пользовательских таблиц в базе (schema dbo).
    """
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("""
        SELECT TABLE_NAME
        FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_SCHEMA = 'dbo'
        ORDER BY TABLE_NAME
    """)
    rows = [r[0] for r in cur.fetchall()]
    conn.close()
    return rows

def get_columns(table_name):
    """
    Возвращает список колонок таблицы в порядке: (COLUMN_NAME, DATA_TYPE, IS_NULLABLE)
    """
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("""
        SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = ?
        ORDER BY ORDINAL_POSITION
    """, (table_name,))
    cols = cur.fetchall()
    conn.close()
    return cols  # list of tuples

def fetch_all(table_name, limit=None):
    """
    Возвращает все строки (list of tuples) и список названий столбцов
    """
    conn = get_connection()
    cur = conn.cursor()
    sql = f"SELECT * FROM {table_name}"
    if limit:
        sql += f" TOP ({limit})"  # not used normally
    cur.execute(sql)
    cols = [c[0] for c in cur.description]
    rows = cur.fetchall()
    conn.close()
    return cols, rows

def fetch_custom(sql, params=()):
    conn = get_connection()
    cur = conn.cursor()
    cur.execute(sql, params)
    cols = [c[0] for c in cur.description] if cur.description else []
    rows = cur.fetchall()
    conn.close()
    return cols, rows

def insert_row(table_name, data: dict):
    """
    data: dict {column: value}
    Возвращает None. Uses parameterized query.
    """
    conn = get_connection()
    cur = conn.cursor()
    cols = list(data.keys())
    placeholders = ", ".join(["?"] * len(cols))
    cols_sql = ", ".join([f"[{c}]" for c in cols])
    sql = f"INSERT INTO {table_name} ({cols_sql}) VALUES ({placeholders})"
    values = [data[c] for c in cols]
    cur.execute(sql, values)
    conn.commit()
    conn.close()

def update_row(table_name, key_column, key_value, data: dict):
    """
    Update row by primary key column.
    data: dict columns to update
    """
    conn = get_connection()
    cur = conn.cursor()
    set_parts = ", ".join([f"[{c}] = ?" for c in data.keys()])
    sql = f"UPDATE {table_name} SET {set_parts} WHERE [{key_column}] = ?"
    params = list(data.values()) + [key_value]
    cur.execute(sql, params)
    conn.commit()
    conn.close()

def delete_row(table_name, key_column, key_value):
    conn = get_connection()
    cur = conn.cursor()
    sql = f"DELETE FROM {table_name} WHERE [{key_column}] = ?"
    cur.execute(sql, (key_value,))
    conn.commit()
    conn.close()

# Дополнительные удобные выборки для твоего скрипта
def get_sorev_with_dates():
    sql = """
    SELECT s.SorevnID, s.name, g.DataStart, g.DataEnd, t.Tip_name
    FROM Sorevnovaniya s
    LEFT JOIN Grafik g ON g.SorevnID = s.SorevnID
    LEFT JOIN TipSorev t ON t.TipID = s.TipID
    ORDER BY s.SorevnID
    """
    return fetch_custom(sql)

def get_winners_current_year():
    # выборка как в ListOfWinners: NagradaID IN (1,2,3) и год текущий
    sql = """
    SELECT sp.FIO_Nazvanie AS Sportsmen, v.Nazvanie AS Sport, so.name AS Sorev
    FROM Results r
    JOIN Sportsmeny sp ON r.SportsmenID = sp.SportsmenID
    JOIN VidiSporta v ON r.SportID = v.SportID
    JOIN Sorevnovaniya so ON r.SorevnID = so.SorevnID
    WHERE YEAR(r.DataItoga) = YEAR(GETDATE()) AND r.NagradaID IN (1,2,3)
    """
    return fetch_custom(sql)
