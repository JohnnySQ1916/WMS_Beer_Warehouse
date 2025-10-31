from app.database.database import db
from sqlalchemy import text
from app.warehouse_operations.product_services import get_current_amount, update_location, update_amount, insert_new_product, product_exist_on_location
from datetime import datetime



def new_record_relocation(ean):
    query = text("""INSERT INTO relocation (product_name, ean, status)
                 SELECT p.product_name, ean, :status
                 FROM products p
                 WHERE ean = :ean
                 RETURNING id""")
    new_record = db.session.execute(query, {'ean': ean, 'status': 'ean_confirmed'}).scalar()
    db.session.commit()
    return new_record


def confirm_location(id, location, date, user_id):
    query = text('UPDATE relocation SET initial_location= :location, date = :date, status = :status, user_id = :user_id WHERE id = :id')
    result = db.session.execute(query, {'location': location, 'date': date, 'status': 'date_confirmed', 'user_id': user_id,'id': id})
    db.session.commit()

def confirm_amount(id, amount):
    amount_query = text('UPDATE relocation SET amount = :amount, status = :status WHERE id = :id')
    result = db.session.execute(amount_query, {'amount': amount, 'status': 'amount_confirmed', 'id': id})
    db.session.commit()

def confirm_target_location(id, target_location):
    query = text('UPDATE relocation SET  target_location = :target_location, time = :time, status = :status WHERE id = :id')
    result = db.session.execute(query, {'target_location': target_location, 'time': datetime.now().time().strftime('%H:%M:%S'), 'status': 'done', 'id': id})
    db.session.commit()


def relocate_in_products(ean, location, date, amount, target_location):
    amount_on_location = get_current_amount(ean, location, date)
    if amount == amount_on_location:
        update_location(location, ean, target_location)
    elif amount < amount_on_location:
        update_amount(ean, location, amount, 'reduce')
        exist = product_exist_on_location(target_location, ean, location, date)
        if exist:
            update_amount(ean, target_location, amount, 'sum')
        else:
            insert_new_product(amount, target_location, ean, location, date)
    else:
        raise ValueError(f"Amount {amount} exceeds amount on location {amount_on_location}")
    

def new_record_relocation_by_location(location, user_id):
    query = text("""INSERT INTO relocation (initial_location, user_id, status)
                 VALUES (:location, :user_id, :status)""")
    new_record = db.session.execute(query, {'location': location, 'user_id': user_id,  'status': 'location_confirmed'})
    db.session.commit()
    new_id = new_record.lastrowid
    return new_id

def confirm_ean(id, product_name, ean, date):
    query = text('UPDATE relocation SET product_name = :product_name , ean= :ean, date = :date, status = :status WHERE id = :id')
    result = db.session.execute(query, {'product_name': product_name, 'ean': ean, 'date': date, 'status': 'date_confirmed', 'id': id})
    db.session.commit()

