# from app.database.database import get_db
from app.config import config
from app.routes.product_operation_routes import router as products_router
from app.routes.location_operation_routes import router as location_router
from app.routes.relocation_routes import router as relocation_router
from app.routes.execute_order_routes import router as execute_order_router
from app.auth.auth import router as auth_router
from app.routes.delivery_routes import router as delivery_router
from app.routes.add_product_route import router as add_product_router
from app.routes.create_order_routes import router as create_order_router
import os
from dotenv import load_dotenv
from fastapi import FastAPI, APIRouter
from app.database.database import engine
from app.database.base import Base


load_dotenv()

class Config:
    SQLALCHEMY_DATABASE_URI = os.getenv(
        'DATABASE_URL') or os.getenv('SQLALCHEMY_DATABASE_URI')
    SECRET_KEY = os.getenv('SECRET_KEY')

class TestingConfig(Config):
    TESTING = True
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SQLALCHEMY_DATABASE_URI = 'sqlite:///:memory:'


class DevelopmentConfig(Config):
    DEBUG = True
    # SQLALCHEMY_DATABASE_URI = os.getenv('DEV_DATABASE_URL')


config = {
    'development': DevelopmentConfig,
    'testing': TestingConfig
}



# Tworzymy instancję FastAPI
app = FastAPI(
    title="WMS One More Beer",
    description="Warehouse Management System API",
    version="1.0.0"
)
api_v1 = APIRouter(prefix="/api/v1")

# Rejestrujemy routery (czyli odpowiedniki Flaskowych blueprintów)
api_v1.include_router(products_router)
api_v1.include_router(location_router)
api_v1.include_router(relocation_router)
api_v1.include_router(delivery_router)
api_v1.include_router(execute_order_router)
api_v1.include_router(auth_router)
api_v1.include_router(add_product_router)
api_v1.include_router(create_order_router)

app.include_router(api_v1)

# Opcjonalnie: endpoint testowy
@app.get("/")
def root():
    return {"message": "WMS API działa 🚀"}
