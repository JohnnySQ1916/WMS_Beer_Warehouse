import logging
from contextlib import contextmanager
from datetime import date

from sqlalchemy import text
from sqlalchemy.orm import Session

from app.common_schema import AddCustomer, AddSupplier

logger = logging.getLogger(__name__)


@contextmanager
def transaction(db: Session):
    try:
        yield db
        db.commit()
    except Exception as e:
        db.rollback()
        logger.exception(f"Bład w transakcji: {e}")
        raise


class AddService:
    def __init__(self, db: Session):
        self.db = db

    def insert_new_product(
        self, amount: int, new_location: str, ean: str, location_choice: str, date: date
    ) -> None:
        with transaction(self.db):
            query = text("""
                INSERT INTO products (code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount) 
                SELECT code, product_name, ean, :amount, jednostka, unit_weight, :new_location, :date, :reserved_amount, :amount
                FROM products
                WHERE ean = :ean AND location = :location_choice AND date = :date
                ORDER BY date DESC
                LIMIT 1
            """)
            self.db.execute(
                query,
                {
                    "amount": amount,
                    "new_location": new_location,
                    "ean": ean,
                    "location_choice": location_choice,
                    "date": date,
                    "reserved_amount": 0,
                },
            )

    def insert_new_customer(self, body: AddCustomer) -> None:
        with transaction(self.db):
            customer_id = body.customer_id
            company_name = body.company_name
            contact_name = body.contact_name
            contact_title = body.contact_title
            address = body.address
            city = body.city
            region = body.region
            postal_code = body.postal_code
            country = body.country
            phone = body.phone
            fax = body.fax
            self.db.execute(
                text("""INSERT INTO customers (customer_id, company_name, contact_name, contact_title, address, city, region, postal_code, country, phone, fax)
                                    VALUES (:customer_id, :company_name, :contact_name, :contact_title, :address, :city, :region, :postal_code, :country, :phone, :fax)"""),
                {
                    "customer_id": customer_id,
                    "company_name": company_name,
                    "contact_name": contact_name,
                    "contact_title": contact_title,
                    "address": address,
                    "city": city,
                    "region": region,
                    "postal_code": postal_code,
                    "country": country,
                    "phone": phone,
                    "fax": fax,
                },
            )

    def insert_new_supplier(self, body: AddSupplier) -> None:
        with transaction(self.db):
            company_name = body.company_name
            contact_name = body.contact_name
            contact_title = body.contact_title
            address = body.address
            city = body.city
            region = body.region
            postal_code = body.postal_code
            country = body.country
            phone = body.phone
            fax = body.fax
            homepage = body.homepage
            self.db.execute(
                text("""INSERT INTO suppliers (company_name, contact_name, contact_title, address, city, region, postal_code, country, phone, fax, homepage)
                                    VALUES (:company_name, :contact_name, :contact_title, :address, :city, :region, :postal_code, :country, :phone, :fax, :homepage)"""),
                {
                    "company_name": company_name,
                    "contact_name": contact_name,
                    "contact_title": contact_title,
                    "address": address,
                    "city": city,
                    "region": region,
                    "postal_code": postal_code,
                    "country": country,
                    "phone": phone,
                    "fax": fax,
                    "homepage": homepage,
                },
            )

    def check_if_customer_exist(self, company_name: str) -> bool:
        exist = self.db.execute(
            text("SELECT 1 FROM customers WHERE company_name = :company_name"),
            {"company_name": company_name},
        ).scalar()
        if not exist:
            return False
        return True

    def check_if_supplier_exist(self, company_name: str) -> bool:
        exist = self.db.execute(
            text("SELECT 1 FROM suppliers WHERE company_name = :company_name"),
            {"company_name": company_name},
        ).scalar()
        if not exist:
            return False
        return True

    def check_if_product_exist(self, ean: str) -> bool:
        exist = self.db.execute(
            text("SELECT 1 FROM product_details WHERE ean = :ean"), {"ean": ean}
        ).scalar()
        if not exist:
            return False
        return True
