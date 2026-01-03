from sqlalchemy.orm import  declarative_base

Base = declarative_base()

from app.models import Products, ProductDetails, Users, Relocate, Customer, DeliveryDetail, DeliveryOrder, Order, OrdersDetails, Reservation, Suppliers, Pick, OrderPickingDetail, LocationWeights
