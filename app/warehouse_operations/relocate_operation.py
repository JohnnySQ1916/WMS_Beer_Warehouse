from app.database.database import get_db
from sqlalchemy import text
from app.warehouse_operations.product_services import get_current_amount, update_location, update_amount, insert_new_product, product_exist_on_location
from app.warehouse_operations.product_operations import ProductService
from datetime import datetime, date, timezone
from sqlalchemy.orm import Session
from fastapi import HTTPException


class RelocationService:
    def __init__(self, db: Session):
        self.db = db

    def new_record_relocation(self, ean: str):
        query = text("""INSERT INTO relocation (product_name, ean, status)
                    SELECT p.product_name, p.ean, :status
                    FROM products p
                    WHERE ean = :ean
                    RETURNING id""")
        new_record = self.db.execute(
            query, {'ean': ean, 'status': 'ean_confirmed'}).scalar()
        self.db.commit()
        return new_record

    def confirm_location(self, relocation_id: int, location: str, date: date, user_id: str):
        query = text(
            'UPDATE relocation SET initial_location= :location, date = :date, status = :status, user_id = :user_id WHERE id = :id')
        self.db.execute(query, {'location': location, 'date': date,
                        'status': 'date_confirmed', 'user_id': user_id, 'id': relocation_id})
        self.db.commit()

    def update_date(self, product_id: int, relocation_id: int):
        query = text(
            'UPDATE relocation SET date = (SELECT date FROM products WHERE id = :product_id), status = :status WHERE id = :id')
        self.db.execute(query, {'product_id': product_id,
                   'status': 'date_confirmed', 'id': relocation_id})
        self.db.commit()


    def confirm_amount(self, relocation_id: int, amount: int):
        amount_query = text(
            'UPDATE relocation SET amount = :amount, status = :status WHERE id = :id')
        result = self.db.execute(
            amount_query, {'amount': amount, 'status': 'amount_confirmed', 'id': relocation_id})
        self.db.commit()


    def confirm_target_location(self, relocation_id, target_location):
        query = text(
            'UPDATE relocation SET  target_location = :target_location, time = :time, status = :status WHERE id = :id')
        self.db.execute(query, {'target_location': target_location, 'time': datetime.now(timezone.utc).replace(microsecond=0), 'status': 'done', 'id': relocation_id})
        self.db.commit()


    def relocate_in_products(self, ean, location, date, amount, target_location):
        product_service = ProductService(self.db)
        amount_on_location = product_service.get_current_amount(ean, location, date)
        if amount == amount_on_location:
            product_service.update_location(location, ean, target_location)
        elif amount < amount_on_location:
            product_service.update_amount(ean, location, amount, 'reduce')
            exist = product_service.product_exist_on_location(target_location, ean, location, date)
            if exist:
                product_service.update_amount(ean, target_location, amount, 'sum')
            else:
                product_service.insert_new_product(amount, target_location, ean, location, date)
        else:
            raise ValueError(
                f"Amount {amount} exceeds amount on location {amount_on_location}")


    def new_record_relocation_by_location(self, location, user_id):
        query = text("""INSERT INTO relocation (initial_location, user_id, status)
                    VALUES (:location, :user_id, :status)
                    RETURNING id""")
        new_id = self.db.execute(
            query, {'location': location, 'user_id': user_id,  'status': 'location_confirmed'}).scalar()
        self.db.flush()
        return new_id


    def confirm_ean(self, id, product_name, ean, date):
        query = text(
            'UPDATE relocation SET product_name = :product_name , ean= :ean, date = :date, status = :status WHERE id = :id')
        self.db.execute(query, {
                                    'product_name': product_name, 'ean': ean, 'date': date, 'status': 'date_confirmed', 'id': id})
        self.db.commit()
