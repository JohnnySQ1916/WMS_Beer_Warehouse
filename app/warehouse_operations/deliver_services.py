from app.database.database import db
from sqlalchemy.sql import text
import datetime
from app.models import DeliveryDetail, DeliveryOrder


def DeliverIDGenerate():
    data = datetime.datetime.now()
    year = data.year
    month = data.month
    try:
        if db.engine.name == 'postgresql':
        # Pobranie liczby zamówieni z danego miesiaca
            query = text("""SELECT COUNT (*) FROM delivery_order WHERE EXTRACT(MONTH FROM create_date) = :month
                        AND EXTRACT(YEAR FROM create_date) = :year""")
            AmountOfOrder = db.session.execute(query, {'month': month, 'year': year}).scalar()
        elif db.engine.name == 'sqlite':
            query = text("""SELECT COUNT (*) FROM delivery_order WHERE strftime('%m', create_date) = :month
                        AND strftime('%Y', create_date) = :year""")
            AmountOfOrder = db.session.execute(query, {'month': month, 'year': year}).scalar()
        orderNO = AmountOfOrder + 1
        DeliverNumber = f"PZ-{orderNO:03}-{month:02}-{year}"
        # Sprawdzenie, czy numer zamówienia jest unikalny
        checking_query = text(
            "SELECT deliver_id FROM delivery_order WHERE deliver_id = :deliver_id")
        checking = db.session.execute(
            checking_query, {'deliver_id': DeliverNumber}).fetchone()
        if checking:
            raise ValueError("Generated deliver number is already exist.")
        return DeliverNumber
    except Exception as e:
        print("Błąd zapytania SQL:", e)
        db.session.rollback()
        return None


def supplier_exist(supplier):
    result = db.session.execute(text(
        'SELECT company_name FROM suppliers WHERE company_name = :name'), {'name': supplier}).scalar()
    return bool(result)


def create_supplier_deliver(supplier, deliver_external_number, delivery_date):
    try:
        deliver_id = DeliverIDGenerate()
        delivery_order_query = text("""INSERT INTO delivery_order (deliver_id, supplier, delivery_date, deliver_external_number, create_date, status)
                                    VALUES(:deliver_id, :supplier, :delivery_date, :deliver_external_number, :create_date, :status)""")
        db.session.execute(delivery_order_query, {'deliver_id': deliver_id, 'supplier': supplier, 'delivery_date': delivery_date,
                                                  'deliver_external_number': deliver_external_number, 'create_date': datetime.datetime.today().date(), 'status': 'undone'})
        db.session.commit()
        return deliver_id
    except Exception as e:
        db.session.rollback()
        print(f'Error while creating delivery {e}')
        return False


def create_deliver_details(deliver_id, product_name, ean, expected_amount):
    try:
        new_item = DeliveryDetail(deliver_id = deliver_id, product_name = product_name, ean = ean, expected_amount = expected_amount)
        db.session.add(new_item)
        db.session.commit()
        return True
    except Exception as e:
        db.session.rollback()
        print(f'Error while creating delivery details {e}')
        return False


def check_status(ean, deliver_id):
    result = db.session.execute(text('SELECT status FROM deliver_details WHERE ean = :ean AND deliver_id = :deliver_id AND target_location IS NULL'),
                                {'ean': ean, 'deliver_id': deliver_id}).fetchone()
    if not result:
        return None
    return result[0]


def change_ean_status(ean, deliver_id):
    try:
        update_query = text(
            "UPDATE deliver_details SET status = 'ean confirmed' WHERE deliver_id = :deliver_id AND ean = :ean AND target_location IS NULL")
        update = db.session.execute(
            update_query, {'deliver_id': deliver_id, 'ean': ean})
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        print(f'Its appear an error {e}')


def update_products(target_location, ean, deliver_id):
    try:
        deliver_product = db.session.execute(text("""SELECT * FROM deliver_details WHERE deliver_id = :deliver_id AND ean = :ean  
                                                AND status IN ('pending', 'done') ORDER BY id DESC LIMIT 1"""),
                                             {'deliver_id': deliver_id, 'ean': ean}).fetchone()
        product = db.session.execute(
            text('SELECT * FROM product_details WHERE ean = :ean'), {'ean': ean}).fetchone()
        if not deliver_product or not product:
            print("No data in database!")
            return False
        is_exist_query = text(
            'SELECT 1 FROM products WHERE ean = :ean AND location = :location AND date = :date LIMIT 1')
        is_exist = db.session.execute(is_exist_query, {
                                      'ean': ean, 'location': target_location, 'date': deliver_product.date}).fetchone()
        if not is_exist:
            insert_query = text("""INSERT INTO products (code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount)
                                VALUES (:code, :product_name, :ean, :amount, :jednostka, :unit_weight, :location, :date, :reserved_amount, :available_amount)""")
            db.session.execute(insert_query, {'code': product.code, 'product_name': product.product_name, 'ean': ean,
                                              'amount': deliver_product.amount, 'jednostka': 'szt', 'unit_weight': product.unit_weight,
                                              'location': target_location, 'date': deliver_product.date, 'reserved_amount': 0,
                                              'available_amount': deliver_product.amount})
        else:
            update_query = text("""UPDATE products SET amount = amount + :new_amount, available_amount = available_amount + :new_amount
                                WHERE ean = :ean AND location = :location AND date = :date""")
            db.session.execute(update_query, {'new_amount': deliver_product.amount,
                               'ean': ean, 'location': target_location, 'date': deliver_product.date})
        db.session.commit()
        return True
    except Exception as e:
        db.session.rollback()
        print(f'It is appear an error: {e}')
        return False