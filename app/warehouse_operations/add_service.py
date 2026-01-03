from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError
from app.warehouse_operations.product_services import get_current_amount, update_location, update_amount, insert_new_product, product_exist_on_location
from sqlalchemy.orm import Session
from fastapi import HTTPException, Depends, status
from app.database.database import get_db
from sqlalchemy.exc import IntegrityError, SQLAlchemyError
from sqlalchemy.orm import Session

class AddService:
    def __init__(self, db: Session):
        self.db = db

    def insert_new_product(self, amount, new_location, ean, location_choice, date):
        query = text("""
            INSERT INTO products (code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount) 
            SELECT code, product_name, ean, :amount, jednostka, unit_weight, :new_location, :date, :reserved_amount, :amount
            FROM products
            WHERE ean = :ean AND location = :location_choice AND date = :date
            ORDER BY date DESC
            LIMIT 1
        """)
        result = self.db.execute(query, {
                                    'amount': amount, 'new_location': new_location, 'ean': ean, 'location_choice': location_choice, 'date': date, 'reserved_amount': 0})
        print(result)
        self.db.commit()

    def insert_new_customer(self, body):
        customer_id= body.customer_id
        company_name= body.company_name
        contact_name= body.contact_name
        contact_title= body.contact_title
        address= body.address
        city= body.city
        region= body.region
        postal_code= body.postal_code
        country= body.country
        phone= body.phone
        fax= body.fax
        result = self.db.execute(text("""INSERT INTO customers (customer_id, company_name, contact_name, contact_title, address, city, region, postal_code, country, phone, fax)
                                 VALUES (:customer_id, :company_name, :contact_name, :contact_title, :address, :city, :region, :postal_code, :country, :phone, :fax)"""),
                                 {'customer_id': customer_id, 'company_name': company_name, 'contact_name': contact_name, 'contact_title': contact_title, 
                                  'address': address, 'city': city, 'region': region, 'postal_code': postal_code, 'country': country, 'phone': phone, 'fax': fax})
        self.db.commit()
        return True

    def insert_new_supplier(self, body):   
        company_name= body.company_name
        contact_name= body.contact_name
        contact_title= body.contact_title
        address= body.address
        city= body.city
        region= body.region
        postal_code= body.postal_code
        country= body.country
        phone= body.phone
        fax= body.fax
        homepage = body.homepage
        result = self.db.execute(text("""INSERT INTO suppliers (company_name, contact_name, contact_title, address, city, region, postal_code, country, phone, fax, homepage)
                                 VALUES (:company_name, :contact_name, :contact_title, :address, :city, :region, :postal_code, :country, :phone, :fax, :homepage)"""),
                                 {'company_name': company_name, 'contact_name': contact_name, 'contact_title': contact_title, 
                                  'address': address, 'city': city, 'region': region, 'postal_code': postal_code, 'country': country, 'phone': phone, 'fax': fax, 'homepage': homepage})
        self.db.commit()
        return True

    def check_if_customer_exist(self, company_name):
        exist = self.db.execute(text('SELECT 1 FROM customers WHERE company_name = :company_name'), {'company_name': company_name}).scalar()
        if not exist:
            return False
        return True

    def check_if_supplier_exist(self, company_name):
        exist = self.db.execute(text('SELECT 1 FROM suppliers WHERE company_name = :company_name'), {'company_name': company_name}).scalar()
        if not exist:
            return False
        return True
    
    def check_if_product_exist(self, ean):
        exist = self.db.execute(text('SELECT 1 FROM product_details WHERE ean = :ean'), {'ean': ean}).scalar()
        if not exist:
            return False
        return True