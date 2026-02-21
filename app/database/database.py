import os

from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")
DATABASE_URL_TEST = os.getenv('DATABASE_URL_TEST')

# Tworzymy silnik SQLAlchemy
engine = create_engine(DATABASE_URL)
test_engine = create_engine(DATABASE_URL_TEST)

# Tworzymy klasę bazową do modeli


# Tworzymy fabrykę sesji
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
TestSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=test_engine)

# Funkcja pomocnicza do uzyskania sesji (używana w FastAPI)
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()






# from flask_sqlalchemy import SQLAlchemy

# db = SQLAlchemy()

