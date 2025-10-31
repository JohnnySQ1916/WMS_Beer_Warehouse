from marshmallow import Schema, fields, validates, ValidationError, validates_schema, validate
from app.database.database import db
from sqlalchemy.sql import text
import datetime
from werkzeug.security import check_password_hash

class EanSchema(Schema):
    ean = fields.Str(required=True)

    @validates('ean')
    def validate_ean(self, value, **kwargs):
        if not value.isdigit() or len(value) != 13:
            raise ValidationError('EAN has to be consist of 13 character')
        
class LocationSchema(Schema):
    location = fields.Str(required=True)

    @validates('location')
    def validate_location(self, value,**kwargs):
        query = text('SELECT 1 FROM location_weights WHERE location = :loc LIMIT 1')
        result = db.session.execute(query, {'loc': value}).fetchone()
        if not result:
            raise ValidationError('Entered location doesnt exist')
        
class AmountSchema(Schema):
    amount = fields.Int(required=True)
    force = fields.Boolean(load_default=False)

    @validates('amount')
    def validate_amount(self, value, **kwargs):
        if value <= 0:
            raise ValidationError('Amount has to be over 0')
        
class DateSchema(Schema):
    date = fields.Date(required=True)

    @validates('date')
    def validate_date(self, value, **kwargs):
        if value <= datetime.date.today():
            raise ValidationError('Date has to be bigger than today')
        
class ChooseProductSchema(Schema):
    product_id = fields.Int(required=True)

class AuthRegisterSchema(Schema):
    user_id = fields.Str(required=True)
    user_name = fields.Str(required=True)
    password = fields.Str(required = True, load_only=True, validate=validate.Length(min=1, max=4))

    @validates('user_id')
    def validate_user_id(self, value, **kwargs):
        if len(value) != 2:
            raise ValidationError('User_id is the persons initials')
        user = db.session.execute(text('SELECT 1 FROM users WHERE user_id = :value'), {'value': value}).scalar()
        if not user:
            raise ValidationError('There is not such user in datas')
    
    @validates_schema
    def validate_password(self, data, **kwargs):
        user_id = data.get('user_id')
        password = data.get('password')
        if len(password)< 1 or len(password)> 4:
            raise ValidationError('Password has to be over than 0 charackter and below 4')
        result = db.session.execute(text('SELECT password FROM users WHERE user_id = :user_id'), {'user_id': user_id}).scalar()
        if not result or check_password_hash(password, result):
            raise ValidationError('Wrong password')
        
class AuthLoginSchema(Schema):
    user_id = fields.Str(required=True)
    password = fields.Str(required = True, load_only=True, validate=validate.Length(min=1, max=4))

    @validates('user_id')
    def validate_user_id(self, value, **kwargs):
        if len(value) != 2:
            raise ValidationError('User_id is the persons initials')
        user = db.session.execute(text('SELECT 1 FROM users WHERE user_id = :value'), {'value': value}).scalar()
        if not user:
            raise ValidationError('There is not such user in datas')
    
    @validates_schema
    def validate_password(self, data, **kwargs):
        user_id = data.get('user_id')
        password = data.get('password')
        if len(password)< 1 or len(password)> 4:
            raise ValidationError('Password has to be over than 0 charackter and below 4')
        result = db.session.execute(text('SELECT password FROM users WHERE user_id = :user_id'), {'user_id': user_id}).scalar()
        if not result or not check_password_hash(result, password):
            raise ValidationError('Wrong password')
        
class DeliverCreateSupplier(Schema):
    supplier = fields.Str(required=True)
    deliver_external_number = fields.Str(required=True)
    delivery_date = fields.Date(required=True)


class DeliverCreateDetails(Schema):
    product_name = fields.Str(required=True)
    ean = fields.Str(required=True)
    expected_amount = fields.Integer(required=True)

    @validates('ean')
    def validate_ean(self, value, **kwargs):
        if not value.isdigit() or len(value) != 13:
            raise ValidationError('EAN must consist of 13 exactly digits')
        
    @validates('expected_amount')
    def validate_amount(self, value, **kwargs):
        if value <= 0:
            raise ValidationError('Amount must be greater than 0')
        
class DeliverProductsListSchema(Schema):
    products = fields.List(fields.Nested(DeliverCreateDetails), required=True)