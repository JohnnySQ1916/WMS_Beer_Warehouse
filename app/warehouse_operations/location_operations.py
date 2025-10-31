from app.database.database import db
from sqlalchemy import text


def find_product_by_location(location):
    query = text("SELECT code, product_name, ean, amount, jednostka, location FROM products WHERE location = :location")
    result = db.session.execute(query, {"location": location}).fetchall()
    location = [dict(row._mapping) for row in result]
    if result:
        return location
    return None
