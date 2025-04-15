from db import get_db_connection

def insert_transaction(title, amount, time, type, date):
    conn = get_db_connection()
    cursor = conn.cursor()
    query = """
        INSERT INTO transaksi (title, amount, time, type, date)
        VALUES (%s, %s, %s, %s, %s)
    """
    cursor.execute(query, (title, amount, time, type, date))
    conn.commit()
    cursor.close()
    conn.close()

def get_transactions():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM transaksi")
    result = cursor.fetchall()
    cursor.close()
    conn.close()
    return result
