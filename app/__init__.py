from flask import Flask
from app.database.database import db
from app.config import config
from app.routes.product_operation_routes import product_bp
from app.routes.location_operation_routes import location_bp
from app.routes.relocation_routes import relocation_bp
from app.routes.execute_order_routes import execute_order_bp
from app.auth.auth import auth_bp
from app.routes.delivery_routes import delivery_bp
import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    SQLALCHEMY_DATABASE_URI = os.getenv('DATABASE_URL')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SECRET_KEY = os.getenv('SECRET_KEY')

class TestingConfig(Config):
    TESTING = True
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SQLALCHEMY_DATABASE_URI = 'sqlite:///:memory:'


class DevelopmentConfig(Config):
    DEBUG = True
    SQLALCHEMY_DATABASE_URI = os.getenv('DEV_DATABASE_URL')
    

config = {
    'development': DevelopmentConfig,
    'testing': TestingConfig
}

def create_app(config_name='development'):
    app = Flask(__name__)
    print(">>> Tworzenie aplikacji Flask OK")
    app.config.from_object(config[config_name])

    db.init_app(app)

    app.register_blueprint(product_bp, url_prefix="/products")
    app.register_blueprint(location_bp, url_prefix="/location")
    app.register_blueprint(relocation_bp, url_prefix="/relocation")
    app.register_blueprint(auth_bp, url_prefix="/authentication")
    app.register_blueprint(execute_order_bp, url_prefix = '/execute_order')
    app.register_blueprint(delivery_bp, url_prefix= '/delivery')

    if config_name == 'testing':
        with app.app_context():
            db.create_all()

    return app

