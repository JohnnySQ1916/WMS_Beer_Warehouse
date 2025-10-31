from app.database.database import db
from sqlalchemy import text
from app.tests.conftest import app, db_session, client
import pytest
from functools import wraps
from app.warehouse_operations.create_order import OrderNOGenerate, making_reservation, create_order
import datetime
from app.models import OrdersDetails, Reservation


params =[("RADU LEO", "RADUGA LEON BUT. 0,5 L", "5902176770099", 45, "szt ", 0.77, "RI-13-01", "2024-12-09", 0, 45),
                          ("KAZ_MUS_BUT_500", "KAZIMIERZ MUSTAFA BUT. 0,5 L", "5906660570493", 100, "szt ", 0.77, "RK-18-02", "2024-12-09", 0, 100),
                          ("FF USU P", "FUNKY FLUID USUAL PUSZKA 0,5 L", "5907772092798", 1124, "szt ", 0.54, "RA-04-02", "2024-12-09", 0, 1124)]

customers = [("ALFKI", "Alfreds Futterkiste", "Maria Anders", "Sales Representative", "Obere Str. 57", "Berlin"	, "12209", "Germany", "030-0074321", "030-0076545"),
             ("ANATR", "Ana Trujillo Emparedados y helados", "Ana Trujillo", "Owner", "Avda. de la Constitución 2222", "México D.F.", "05021", "Mexico", "(5) 555-4729", "(5) 555-3745")]

def parametrize_decorator(func):
    @pytest.mark.parametrize(
        "code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount", params)
    @wraps(func)
    def wrapper(*args, **kwargs):
        return func(*args, **kwargs)
    return wrapper


def test_OrderNOGenerate(app):
    result = OrderNOGenerate()
    data = datetime.datetime.now()
    year = data.year
    month = data.month
    number = f'ZO-001-{month:02}-{year}'
    assert result is not None
    assert len(result) == len(number)
    assert result == number


def test_create_order(db_session):
    for code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount in params:
        db.session.execute(text("""INSERT INTO products (code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount)
                                VALUES (:code, :product_name, :ean, :amount, :jednostka, :unit_weight, :location, :date, :reserved_amount, :available_amount)"""),
                                {'code': code, 'product_name': product_name, 'ean': ean, 'amount': amount, 'jednostka': jednostka, 'unit_weight': unit_weight, 
                                'location': location, 'date': date, 'reserved_amount': reserved_amount, 'available_amount': available_amount})
        db.session.execute(text("""INSERT INTO product_details (product_name, code, ean, purchase_price, unit_weight) 
                                VALUES (:product_name, :code, :ean, :purchase_price, :unit_weight)"""), {'product_name': product_name,'code': code,
        'ean': ean,'purchase_price': 10, 'unit_weight': unit_weight})
    for customer_id, company_name, contact_name, contact_title, address, city, postal_code, country, phone, fax in customers:
        db.session.execute(text("""INSERT INTO customers (customer_id, company_name, contact_name, contact_title, address, city, postal_code, country, phone, fax)
                                VALUES (:customer_id, :company_name, :contact_name, :contact_title, :address, :city, :postal_code, :country, :phone, :fax)"""),
                                {'customer_id': customer_id, 'company_name': company_name, 'contact_name': contact_name, 'contact_title': contact_title, 
                                 'address': address, 'city': city, 'postal_code': postal_code, 'country': country, 'phone': phone, 'fax': fax})    
    db.session.commit()
    create_order(3, '2025-09-20')
    order_id = db.session.execute(text('SELECT order_id FROM orders ORDER BY order_id DESC LIMIT 1')).scalar()
    result_orders = db.session.execute(text('SELECT * FROM orders WHERE order_id = :order_id'), {'order_id': order_id}).fetchone()
    # result_orders_details = db.session.execute(text('SELECT * FROM orders_details WHERE order_id = :order_id'), {'order_id': order_id}).mappings().all()
    result_orders_details = db.session.query(OrdersDetails).all()
    result_reservation = db.session.query(Reservation).all()
    assert result_orders.create_date == str(datetime.date.today())
    assert result_orders.status == 'Undone'
    assert result_orders.price > 0
    assert result_orders.total_weight > 0
    assert len(result_orders_details) == 3
    for row in result_orders_details:
        assert row.collected_amount == 0
        assert row.status == 'undone'
        assert row.price_brutto * row.amount == row.total_price
    for i in result_reservation:
        assert i.reserved_amount == amount
