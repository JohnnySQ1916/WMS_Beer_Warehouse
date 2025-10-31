from pathlib import Path
import os

base_dir = Path(__file__).resolve().parent

class Config:
    SQLALCHEMY_DATABASE_URI = 'postgresql://postgres:cwks1916@localhost:5432/WMS_One_More_Beer'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SECRET_KEY = 'tajny_klucz_123'

class TestingConfig(Config):
    TESTING = True
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SQLALCHEMY_DATABASE_URI = os.getenv(
        'SQLALCHEMY_DATABASE_URI',
        f'sqlite:///:memory:'
    )

class DevelopmentConfig(Config):
    DEBUG = True
    SQLALCHEMY_DATABASE_URI = 'postgresql://postgres:cwks1916@localhost:5432/WMS_One_More_Beer'
    

config = {
    'development': DevelopmentConfig,
    'testing': TestingConfig
}