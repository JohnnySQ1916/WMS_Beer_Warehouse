from marshmallow import Schema, fields, validates, ValidationError, validates_schema, validate
from sqlalchemy.sql import text
from datetime import date
from werkzeug.security import check_password_hash
from pydantic import BaseModel, field_validator
from pydantic_core.core_schema import FieldValidationInfo
from fastapi import  Depends
from typing import List
from sqlalchemy.orm import Session
from decimal import Decimal

class EanSchema(BaseModel):
    ean : str

    @field_validator('ean')
    def validate_ean(cls, value):
        if not value.isdigit() or len(value) != 13:
            raise ValueError('EAN has to be consist of 13 character')
        return value
    
class ProductSchema(BaseModel):
    product_name: str
    code: str
    ean : str
    unit_weight: Decimal
    purchase_price: Decimal

    @field_validator('ean')
    def validate_ean(cls, value):
        if not value.isdigit() or len(value) != 13:
            raise ValueError('EAN has to be consist of 13 character')
        return value

class LocationSchema(BaseModel):
    location: str

        
class AmountSchema(BaseModel):
    amount : int
    force : bool = False

    @field_validator('amount')
    def validate_amount(cls, value):
        if value <= 0:
            raise ValueError('Amount has to be over 0')
        return value
        
class DateSchema(BaseModel):
    date : date

    @field_validator('date')
    def validate_date(cls, value):
        if value <= date.today():
            raise ValueError('Date has to be bigger than today')
        return value
        
class ChooseProductSchema(BaseModel):
    product_id : int

#napisac funkcje w klasie sprawdzające czy dany uzytkownik jest w bazie dancyh
class AuthRegisterSchema(BaseModel):
    user_id : str
    user_name : str
    password : str
    # password = fields.Str(required = True, load_only=True, validate=validate.Length(min=1, max=4))

    @field_validator('user_id')
    def validate_user_id(cls, value):
        if len(value) != 2:
            raise ValueError('User_id is the persons initials')
        return value
    
    @field_validator('password', mode = 'after')
    def validate_password_lenght(cls, value, info: FieldValidationInfo):
        if len(value)< 1 or len(value)> 4:
            raise ValueError('Password has to be over than 0 charackter and below 4')
        return value
        
class AuthLoginSchema(BaseModel):
    user_id : str
    password : str

    @field_validator('user_id')
    def validate_user_id(cls, value):
        if len(value) != 2:
            raise ValueError('User_id is the persons initials')
        return value

        
class DeliverCreateSupplier(BaseModel):
    supplier : str
    deliver_external_number : str
    delivery_date : str


class DeliverCreateDetails(BaseModel):
    product_name : str
    ean : str
    expected_amount : int

    @field_validator('ean')
    def validate_ean(cls, value):
        if not value.isdigit() or len(value) != 13:
            raise ValueError('EAN must consist of 13 exactly digits')
        return value
        
    @field_validator('expected_amount')
    def validate_amount(cls, value):
        if value <= 0:
            raise ValueError('Amount must be greater than 0')
        return value
        
class DeliverProductsListSchema(BaseModel):
    products : List[DeliverCreateDetails]

class CreateRandomOrder(BaseModel):
    amount: int
    shipping_date: date

    @field_validator('shipping_date')
    def validate_date(cls, value):
        if value <= date.today():
            raise ValueError('Shipping date must be in future')
        return value
    
class AddProductToOrder(BaseModel):
    amount: int
    ean: str

    @field_validator('amount')
    def validate_amount(cls, value):
        if value <= 0:
            raise ValueError('Amount must be greater than 0')
        return value
    
    @field_validator('ean')
    def validate_ean(cls, value):
        if not value.isdigit() or len(value) != 13:
            raise ValueError('EAN must consist of 13 exactly digits')
        return value


class AddCustomer(BaseModel):
    customer_id: str
    company_name: str
    contact_name: str
    contact_title: str
    address: str
    city: str
    region: str
    postal_code: str
    country: str
    phone: str
    fax: str

class AddCustomerToOrder(BaseModel):
    company_name: str

class AddSupplier(BaseModel):
    company_name: str
    contact_name: str
    contact_title: str
    address: str
    city: str
    region: str
    postal_code: str
    country: str
    phone: str
    fax: str
    homepage: str