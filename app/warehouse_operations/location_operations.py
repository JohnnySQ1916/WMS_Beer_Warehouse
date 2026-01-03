from app.database.database import get_db
from sqlalchemy import text
from sqlalchemy.orm import Session
from fastapi import HTTPException

class LocationService:
    def __init__(self, db: Session):
        self.db = db

    def find_product_by_location(self, location: str):
        query = text("SELECT code, product_name, ean, amount, jednostka, location FROM products WHERE location = :location")
        result = self.db.execute(query, {"location": location}).fetchall()
        if not result:
            raise HTTPException(status_code = 404, detail = 'No product on location')
        location = [dict(row._mapping) for row in result]
        return location

    def check_is_location_in_base(self, location):
        query = self.db.execute(text('SELECT COUNT(*) FROM location_weights WHERE location = :location'), {'location': location}).scalar()
        return bool(query)