from app.database.base import Base
from datetime import datetime, date, timedelta
from app.common_schema import EanSchema, LocationSchema, AmountSchema, DateSchema, ChooseProductSchema
from werkzeug.security import generate_password_hash, check_password_hash
import jwt
from sqlalchemy.dialects.postgresql import TIME
from sqlalchemy import Column, String, Integer, Numeric, Date, DateTime, BigInteger
import os
from app.utils import create_jwt_token


class Products(Base):
    __tablename__ = 'products'
    code = Column(String(60), nullable=False)
    product_name = Column(String(150), nullable=False)
    ean = Column(String(13), nullable=False)
    amount = Column(Integer, nullable=False)
    jednostka = Column(String(4), nullable=False)
    unit_weight = Column(Numeric(precision=10, scale=2))
    location = Column(String(10))
    date = Column(Date, nullable=False)
    reserved_amount = Column(Integer)
    available_amount = Column(Integer, nullable=False)
    id = Column(Integer, primary_key=True)

    def __repr__(self):
        return f"<Product {self.name}>"

    @staticmethod
    def validation_ean(ean):
        if len(ean) != 13:
            raise ValueError("EAN must be exactly 13 characters long.")
        return ean

    @staticmethod
    def validation_date(date):
        if date <= datetime.today().date() + datetime.timedelta(days=90):
            raise ValueError('Date is too short')
        if not isinstance(value, datetime.date):
            raise ValueError("Invalid date format.")
        
    def to_dict(self):
        return{
            'Code': self.code,
            'Product_name': self.product_name,
            'Amount': self.amount,
            'EAN': self.ean,
            'Location': self.location
        }


class ConfirmProductsSchema(EanSchema, LocationSchema, AmountSchema, DateSchema, ChooseProductSchema):
    pass


class Users(Base):
    __tablename__ = 'users'
    id = Column(Integer, primary_key=True)
    user_id = Column(String(2), nullable=False, unique=True, index=True)
    user_name = Column(String(50), nullable=False, unique=True)
    password = Column(String, nullable=False)

    @staticmethod
    def generate_hashed_password(password: str) -> str:
        return generate_password_hash(password)

    def is_password_valid(self, password: str) -> bool:
        return check_password_hash(self.password, password)

    def generate_jwt(self):
        expire_minutes = int(os.getenv("JWT_EXPIRED_MINUTES", 60))
        secret = os.getenv("JWT_SECRET", "defaultsecret")
        payload = {
            'user_id': self.user_id,
            'exp': datetime.utcnow() + timedelta(minutes=expire_minutes)
        }
        # return jwt.encode(payload, secret, algorithm='HS256')
        return create_jwt_token(self.user_id)

class Relocate(Base):
    __tablename__ = 'relocation'
    id = Column(Integer, primary_key=True)
    initial_location = Column(String, nullable=True)
    product_name = Column(String, nullable=True)
    ean = Column(String, nullable=True)
    amount = Column(Integer, nullable=True)
    target_location = Column(String, nullable=True)
    user_id = Column(String, nullable=True)
    date = Column(Date, default=date.today)
    time = Column(DateTime(timezone=True), default=datetime.utcnow)
    status = Column(String, nullable=False, default="pending")

    def __repr__(self):
        return f"<Relocation {self.id} {self.product_name} {self.amount}>"
    
class Customer(Base):
    __tablename__ = 'customers'

    customer_id = Column(String(15), primary_key=True, nullable=False)
    company_name = Column(String(40), nullable=False)
    contact_name = Column(String(30))
    contact_title = Column(String(30))
    address = Column(String(60))
    city = Column(String(15))
    region = Column(String(15))
    postal_code = Column(String(10))
    country = Column(String(15))
    phone = Column(String(24))
    fax = Column(String(24))

    def __repr__(self):
        return f"<Customer {self.customer_id} - {self.company_name}>"
    

class DeliveryDetail(Base):
    __tablename__ = "deliver_details"

    id = Column(Integer, primary_key=True)
    deliver_id = Column(String, nullable=True)
    user_id = Column(String, nullable=True)
    product_name = Column(String, nullable=True)
    ean = Column(String, nullable=True)
    expected_amount = Column(Integer, nullable=True)
    amount = Column(Integer, nullable=True)
    date = Column(Date, nullable=True)
    deliver_time = Column(DateTime(timezone=True), nullable=True)
    status = Column(String, default="undone", nullable=True)
    target_location = Column(String, nullable=True)
    deliver_date = Column(Date, nullable=True)

    def __repr__(self):
        return f"<DeliveryDetail id={self.id}, product={self.product_name}, ean={self.ean}, status={self.status}>"
    

class Order(Base):
    __tablename__ = "orders" 
    order_id = Column(String(15), primary_key=True, nullable=False)
    customer_id = Column(String(15), nullable=True)
    amount = Column(Integer, nullable=True)
    create_date = Column(Date, nullable=False, default=date.today)
    status = Column(String(20), nullable=True)
    price = Column(Numeric(7, 2), nullable=True)
    total_weight = Column(Numeric(7, 2), nullable=True)
    pallet_used = Column(String(15), nullable=True)
    shipping_date = Column(Date, nullable=True)

    def __repr__(self):
        return f"<Order {self.order_id} - {self.customer_id}>"
    

class OrdersDetails(Base):
    __tablename__ = "orders_details"

    id = Column(Integer, primary_key=True)
    order_id = Column(String(15))
    product_name = Column(String(100))
    code = Column(String(60))
    amount = Column(Integer)
    ean = Column(String(20))
    price_netto = Column(Numeric(7, 2, asdecimal=False))
    price_brutto = Column(Numeric(10, 2, asdecimal=False))
    product_weight = Column(Numeric(5, 2, asdecimal=False))
    total_price = Column(Numeric(10, 2, asdecimal=False))
    status = Column(String, default="undone")
    collected_amount = Column(Integer, default=0)

    def __repr__(self):
        return f"<Order {self.order_id} - {self.product_name}>"
    
class ProductDetails(Base):
    __tablename__ = "product_details"

    id = Column(Integer, primary_key=True)  
    product_name = Column(String(150))
    code = Column(String(60))
    ean = Column(String(40))
    unit_weight = Column(Numeric(6, 2))
    purchase_price = Column(Numeric(6, 2), default=10)

    def __repr__(self):
        return f"<ProductDetails {self.code} - {self.product_name}>"
    
class Reservation(Base):
    __tablename__ = 'reservation'

    id = Column(Integer, primary_key=True) 
    product_name = Column(String(150))
    ean = Column(String(40))
    amount = Column(BigInteger)
    reserved_amount = Column(Integer)  
    available_amount = Column(BigInteger)  

    def __repr__(self):
        return f"<Reservation id={self.id} product_name={self.product_name} ean={self.ean}>"
    
class DeliveryOrder(Base):
    __tablename__ = "delivery_order"

    deliver_id = Column(String, primary_key=True, nullable=False)
    supplier = Column(String)
    delivery_date = Column(Date)
    status = Column(String, default='undone')
    deliver_external_number = Column(String)
    create_date = Column(Date)

class Suppliers(Base):
    __tablename__ = 'suppliers'

    supplier_id = Column(Integer, primary_key=True, autoincrement=True)
    company_name = Column(String(40), nullable=False)
    contact_name = Column(String(30))
    contact_title = Column(String(30))
    address = Column(String(60))
    city = Column(String(15))
    region = Column(String(15))
    postal_code = Column(String(10))
    country = Column(String(15))
    phone = Column(String(24))
    homepage = Column(String(24))

class Pick(Base):
    __tablename__ = 'picks'

    id = Column(Integer, primary_key=True)
    user_id = Column(String, nullable=True)
    order_id = Column(String, nullable=True)
    product_name = Column(String, nullable=True)
    amount = Column(Integer, nullable=True)
    date = Column(Date, nullable=True)
    time = Column(TIME(timezone=True), nullable=True)
    product_id = Column(Integer, nullable=True)
    location = Column(String, nullable=True)
    ean = Column(String(40))

    def __repr__(self):
        return f"<Pick {self.id} - {self.order_number}>"
    

class OrderPickingDetail(Base):
    __tablename__ = 'order_picking_details'

    id = Column(Integer, primary_key=True)
    product_id = Column(Integer, nullable=True)
    product_name = Column(String, nullable=True)
    expected_amount = Column(Integer, nullable=True)
    picked_amount = Column(Integer, nullable=True)
    picked_location = Column(String, nullable=True)
    picked_by = Column(String, nullable=True)
    scanned_ean = Column(String, nullable=True)
    picked_time = Column(TIME(timezone=True), nullable=True)
    status = Column(String, nullable=True)
    order_id = Column(String, nullable=True)
    picked_date = Column(Date, nullable=True)
    expected_ean = Column(String, nullable=True)
    product_date = Column(Date, nullable=True)

    def __repr__(self):
        return f"<OrderPickingDetail {self.id} - {self.order_number} - {self.product_name}>"
    
class LocationWeights(Base):
    __tablename__ = 'location_weights'

    location = Column(String(10), primary_key=True, nullable=False)
    weightlimitinloc = Column(Integer, nullable=True)
    actualweightinloc = Column(Numeric(10, 2), nullable=True) 
    limitofamountonloc = Column(Integer, nullable=True)
    actualamountonloc = Column(Integer, nullable=True)

    def __repr__(self):
        return f"""<LocationWeights(location='{self.location}', weightlimitinloc={self.weightlimitinloc}, actualweightinloc={self.actualweightinloc}, 
        limitofamountonloc={self.limitofamountonloc}, actualamountonloc={self.actualamountonloc})>"""