import mysql.connector

def get_connection():
    connection = mysql.connector.connect(
        host="localhost",
        user="root",
        password="Pkk1234#",   # type your actual MySQL password here
        database="Research_Paper_Repository"             # replace with your actual DB name
    )
    return connection
