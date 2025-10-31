from app.database.database import db
from datetime import datetime, date, timedelta
from app.common_schema import EanSchema, LocationSchema, AmountSchema, DateSchema, ChooseProductSchema
from werkzeug.security import generate_password_hash, check_password_hash
import jwt
from flask import current_app
from sqlalchemy.dialects.postgresql import TIME


class Products(db.Model):
    __tablename__ = 'products'
    code = db.Column(db.String(60), nullable=False)
    product_name = db.Column(db.String(150), nullable=False)
    ean = db.Column(db.String(13), nullable=False)
    amount = db.Column(db.Integer, nullable=False)
    jednostka = db.Column(db.String(4), nullable=False)
    unit_weight = db.Column(db.Numeric(precision=10, scale=2))
    location = db.Column(db.String(10))
    date = db.Column(db.Date, nullable=False)
    reserved_amount = db.Column(db.Integer)
    available_amount = db.Column(db.Integer, nullable=False)
    id = db.Column(db.Integer, primary_key=True)

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


class Users(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.String(2), nullable=False, unique=True, index=True)
    user_name = db.Column(db.String(50), nullable=False, unique=True)
    password = db.Column(db.String(4), nullable=False)

    @staticmethod
    def generate_hashed_password(password: str) -> str:
        return generate_password_hash(password)

    def is_password_valid(self, password: str) -> bool:
        return check_password_hash(self.password, password)

    def generate_jwt(self):
        payload = {
            'user_id': self.user_id,
            'exp': datetime.utcnow() + timedelta(minutes=current_app.config.get('JWT_EXPIRED_MINUTES', 60))
        }
        return jwt.encode(payload, current_app.config.get('SECRET_KEY'))

class Relocate(db.Model):
    __tablename__ = 'relocation'
    id = db.Column(db.Integer, primary_key=True)
    initial_location = db.Column(db.String, nullable=True)
    product_name = db.Column(db.String, nullable=True)
    ean = db.Column(db.String, nullable=True)
    amount = db.Column(db.Integer, nullable=True)
    target_location = db.Column(db.String, nullable=True)
    user_id = db.Column(db.String, nullable=True)
    date = db.Column(db.Date, default=date.today)
    time = db.Column(db.DateTime(timezone=True), default=datetime.utcnow)
    status = db.Column(db.String, nullable=False, default="pending")

    def __repr__(self):
        return f"<Relocation {self.id} {self.product_name} {self.amount}>"
    
class Customer(db.Model):
    __tablename__ = 'customers'

    customer_id = db.Column(db.String(15), primary_key=True, nullable=False)
    company_name = db.Column(db.String(40), nullable=False)
    contact_name = db.Column(db.String(30))
    contact_title = db.Column(db.String(30))
    address = db.Column(db.String(60))
    city = db.Column(db.String(15))
    region = db.Column(db.String(15))
    postal_code = db.Column(db.String(10))
    country = db.Column(db.String(15))
    phone = db.Column(db.String(24))
    fax = db.Column(db.String(24))

    def __repr__(self):
        return f"<Customer {self.customer_id} - {self.company_name}>"
    

class DeliveryDetail(db.Model):
    __tablename__ = "deliver_details"

    id = db.Column(db.Integer, primary_key=True)
    deliver_id = db.Column(db.String, nullable=True)
    user_id = db.Column(db.String, nullable=True)
    product_name = db.Column(db.String, nullable=True)
    ean = db.Column(db.String, nullable=True)
    expected_amount = db.Column(db.Integer, nullable=True)
    amount = db.Column(db.Integer, nullable=True)
    date = db.Column(db.Date, nullable=True)
    deliver_time = db.Column(db.DateTime(timezone=True), nullable=True)
    status = db.Column(db.String, default="undone", nullable=True)
    target_location = db.Column(db.String, nullable=True)
    deliver_date = db.Column(db.Date, nullable=True)

    def __repr__(self):
        return f"<DeliveryDetail id={self.id}, product={self.product_name}, ean={self.ean}, status={self.status}>"
    

class Order(db.Model):
    __tablename__ = "orders" 
    order_id = db.Column(db.String(15), primary_key=True, nullable=False)
    customer_id = db.Column(db.String(15), nullable=True)
    amount = db.Column(db.Integer, nullable=True)
    create_date = db.Column(db.Date, nullable=True, default=date.today)
    status = db.Column(db.String(20), nullable=True)
    price = db.Column(db.Numeric(7, 2), nullable=True)
    total_weight = db.Column(db.Numeric(7, 2), nullable=True)
    pallet_used = db.Column(db.String(15), nullable=True)
    shipping_date = db.Column(db.Date, nullable=True)

    def __repr__(self):
        return f"<Order {self.order_id} - {self.customer_id}>"
    

class OrdersDetails(db.Model):
    __tablename__ = "orders_details"

    id = db.Column(db.Integer, primary_key=True)
    order_id = db.Column(db.String(15))
    product_name = db.Column(db.String(100))
    code = db.Column(db.String(60))
    amount = db.Column(db.Integer)
    ean = db.Column(db.String(20))
    price_netto = db.Column(db.Numeric(7, 2, asdecimal=False))
    price_brutto = db.Column(db.Numeric(10, 2, asdecimal=False))
    product_weight = db.Column(db.Numeric(5, 2, asdecimal=False))
    total_price = db.Column(db.Numeric(10, 2, asdecimal=False))
    status = db.Column(db.String, default="undone")
    collected_amount = db.Column(db.Integer, default=0)

    def __repr__(self):
        return f"<Order {self.order_id} - {self.product_name}>"
    
class ProductDetails(db.Model):
    __tablename__ = "product_details"

    id = db.Column(db.Integer, primary_key=True)  
    product_name = db.Column(db.String(150))
    code = db.Column(db.String(60))
    ean = db.Column(db.String(40))
    unit_weight = db.Column(db.Numeric(6, 2))
    purchase_price = db.Column(db.Numeric(6, 2), default=10)

    def __repr__(self):
        return f"<ProductDetails {self.code} - {self.product_name}>"
    
class Reservation(db.Model):
    __tablename__ = 'reservation'

    id = db.Column(db.Integer, primary_key=True) 
    product_name = db.Column(db.String(150))
    ean = db.Column(db.String(40))
    amount = db.Column(db.BigInteger)
    reserved_amount = db.Column(db.Integer)  
    available_amount = db.Column(db.BigInteger)  

    def __repr__(self):
        return f"<Reservation id={self.id} product_name={self.product_name} ean={self.ean}>"
    
class DeliveryOrder(db.Model):
    __tablename__ = "delivery_order"

    deliver_id = db.Column(db.String, primary_key=True, nullable=False)
    supplier = db.Column(db.String)
    delivery_date = db.Column(db.Date)
    status = db.Column(db.String, default='undone')
    deliver_external_number = db.Column(db.String)
    create_date = db.Column(db.Date)

class Suppliers(db.Model):
    __tablename__ = 'suppliers'

    supplier_id = db.Column(db.Integer, primary_key=True)
    company_name = db.Column(db.String(40), nullable=False)
    contact_name = db.Column(db.String(30))
    contact_title = db.Column(db.String(30))
    address = db.Column(db.String(60))
    city = db.Column(db.String(15))
    region = db.Column(db.String(15))
    postal_code = db.Column(db.String(10))
    country = db.Column(db.String(15))
    phone = db.Column(db.String(24))
    homepage = db.Column(db.String(24))

class Pick(db.Model):
    __tablename__ = 'picks'

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.String, nullable=True)
    order_id = db.Column(db.String, nullable=True)
    product_name = db.Column(db.String, nullable=True)
    amount = db.Column(db.Integer, nullable=True)
    date = db.Column(db.Date, nullable=True)
    time = db.Column(TIME(timezone=True), nullable=True)
    product_id = db.Column(db.Integer, nullable=True)
    location = db.Column(db.String, nullable=True)
    ean = db.Column(db.String(40))

    def __repr__(self):
        return f"<Pick {self.id} - {self.order_number}>"
    

class OrderPickingDetail(db.Model):
    __tablename__ = 'order_picking_details'

    id = db.Column(db.Integer, primary_key=True)
    product_id = db.Column(db.Integer, nullable=True)
    product_name = db.Column(db.String, nullable=True)
    expected_amount = db.Column(db.Integer, nullable=True)
    picked_amount = db.Column(db.Integer, nullable=True)
    picked_location = db.Column(db.String, nullable=True)
    picked_by = db.Column(db.String, nullable=True)
    scanned_ean = db.Column(db.String, nullable=True)
    picked_time = db.Column(TIME(timezone=True), nullable=True)
    status = db.Column(db.String, nullable=True)
    order_id = db.Column(db.String, nullable=True)
    picked_date = db.Column(db.Date, nullable=True)
    expected_ean = db.Column(db.String, nullable=True)
    product_date = db.Column(db.Date, nullable=True)

    def __repr__(self):
        return f"<OrderPickingDetail {self.id} - {self.order_number} - {self.product_name}>"
    
class LocationWeights(db.Model):
    __tablename__ = 'location_weights'

    location = db.Column(db.String(10), primary_key=True, nullable=False)
    weightlimitinloc = db.Column(db.Integer, nullable=True)
    actualweightinloc = db.Column(db.Numeric(10, 2), nullable=True) 
    limitofamountonloc = db.Column(db.Integer, nullable=True)
    actualamountonloc = db.Column(db.Integer, nullable=True)

    def __repr__(self):
        return f"""<LocationWeights(location='{self.location}', weightlimitinloc={self.weightlimitinloc}, actualweightinloc={self.actualweightinloc}, 
        limitofamountonloc={self.limitofamountonloc}, actualamountonloc={self.actualamountonloc})>"""