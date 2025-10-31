# import psycopg2
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

# # Ustawienia połączenia z bazą danych
# connection = psycopg2.connect(
#     dbname="WMS One More Beer",      # Nazwa twojej bazy danych
#     user="postgres",          # Nazwa użytkownika bazy danych
#     password="cwks1916",    # Hasło do bazy danych
#     host='localhost',         # Adres serwera bazy danych
#     port=5432               # Port bazy danych (domyślnie 5432)
# )

# # Tworzenie kursora
# db = connection.cursor()
