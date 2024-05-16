import psycopg2
from psycopg2 import Error

# Параметри підключення до бази даних PostgreSQL
DB_HOST = '127.0.0.1'
DB_PORT = '5432'
DB_NAME = 'online_store'
DB_USER = 'postgres'
DB_PASS = 'yurasd'



def connect():
    try:
        return psycopg2.connect(
            host=DB_HOST,
            port=DB_PORT,
            dbname=DB_NAME,
            user=DB_USER,
            password=DB_PASS
        )
    except Error as e:
        print(e)


def execute_query(connection, query):
    cursor = connection.cursor()
    try:
        cursor.execute(query)
        connection.commit()
        print("Query executed successfully")
    except (Exception, psycopg2.DatabaseError) as error:
        print(f"Error: {error}")
        connection.rollback()
    finally:
        cursor.close()

def execute_read_query(connection, query):
    cursor = connection.cursor()
    result = None
    try:
        cursor.execute(query)
        result = cursor.fetchall()
        return result
    except (Exception, psycopg2.DatabaseError) as error:
        print(f"Error: {error}")
    finally:
        cursor.close()