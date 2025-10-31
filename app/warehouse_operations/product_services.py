from app.database.database import db
from sqlalchemy import text


def get_current_amount(ean, location, date = None):
    if date:
        query = text('SELECT amount FROM products WHERE location = :location AND ean= :ean AND date= :date')
        result = db.session.execute(query, {'location': location, 'ean': ean, 'date': date}).scalar()
    elif not date:
        query = text('SELECT amount FROM products WHERE location = :location AND ean= :ean')
        result = db.session.execute(query, {'location': location, 'ean': ean}).scalar()
    return result

def update_location(old_location, ean, new_location):
    query = text('UPDATE products SET location = :new_location WHERE ean = :ean AND location = :old_location')
    result = db.session.execute(query, {'new_location': new_location, 'ean': ean, 'old_location': old_location})
    db.session.commit()
    print("Product location updated successfully.")

def update_amount(ean, location, added_amount, operation):
    if operation == 'sum':
        query = text('UPDATE products SET amount = :new_amount WHERE ean = :ean AND location = :location')
        result = db.session.execute(query, {'new_amount': get_current_amount(ean, location)+ added_amount, 'ean': ean, 'location': location})
        db.session.commit()
    elif operation == 'reduce':
        query = text('UPDATE products SET amount = :new_amount WHERE ean = :ean AND location = :location')
        result = db.session.execute(query, {'new_amount': get_current_amount(ean, location)- added_amount, 'ean': ean, 'location': location})
        db.session.commit()
                                
def insert_new_product(amount, new_location, ean, location_choice, date):
    query = text("""
        INSERT INTO products (code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount) 
        SELECT code, product_name, ean, :amount, jednostka, unit_weight, :new_location, :date, :reserved_amount, :amount
        FROM products
        WHERE ean = :ean AND location = :location_choice AND date = :date
        ORDER BY date DESC
        LIMIT 1
    """)
    result = db.session.execute(query, {
                                'amount': amount, 'new_location': new_location, 'ean': ean, 'location_choice': location_choice, 'date': date, 'reserved_amount': 0})
    print(result)
    db.session.commit()

def product_exist_on_location(new_location, ean, location_choice, date):
    check_query = text("""SELECT 1 FROM products WHERE location = :new_location AND ean = :ean 
                            AND date = (SELECT date FROM products WHERE ean = :ean AND location = :location_choice AND date = :date)""")
    exist = db.session.execute(check_query, {
                        'new_location': new_location, 'ean': ean, 'location_choice': location_choice, 'date': date}).fetchone()
    return bool(exist)

