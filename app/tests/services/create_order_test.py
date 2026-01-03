from sqlalchemy import text
from app.tests.conftest import db_session
import pytest
from functools import wraps
from app.warehouse_operations.create_order import CreateOrder
from app.warehouse_operations.product_operations import ProductService
import datetime
from app.models import OrdersDetails, Reservation
from fastapi import HTTPException


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

@pytest.fixture
def prepare_test_data(db_session):
    for code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount in params:
        db_session.execute(text("""
            INSERT INTO products (code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount)
                                 VALUES (:code, :product_name, :ean, :amount, :jednostka, :unit_weight, :location, :date, :reserved_amount, :available_amount)"""),
                                {'code': code, 'product_name': product_name, 'ean': ean, 'amount': amount, 'jednostka': jednostka, 'unit_weight': unit_weight, 
                                'location': location, 'date': date, 'reserved_amount': reserved_amount, 'available_amount': available_amount})
        db_session.execute(text("""INSERT INTO product_details (product_name, code, ean, purchase_price, unit_weight) 
                                VALUES (:product_name, :code, :ean, :purchase_price, :unit_weight)"""), {'product_name': product_name,'code': code,
        'ean': ean,'purchase_price': 10, 'unit_weight': unit_weight})
    for customer_id, company_name, contact_name, contact_title, address, city, postal_code, country, phone, fax in customers:
        db_session.execute(text("""INSERT INTO customers (customer_id, company_name, contact_name, contact_title, address, city, postal_code, country, phone, fax)
                                VALUES (:customer_id, :company_name, :contact_name, :contact_title, :address, :city, :postal_code, :country, :phone, :fax)"""),
                                {'customer_id': customer_id, 'company_name': company_name, 'contact_name': contact_name, 'contact_title': contact_title, 
                                 'address': address, 'city': city, 'postal_code': postal_code, 'country': country, 'phone': phone, 'fax': fax})
    for _, product_name, ean, amount, *_, reserved_amount, available_amount in params:
        db_session.execute(text("""
            INSERT INTO reservation (product_name, ean, amount, reserved_amount, available_amount)
                                 VALUES (:product_name, :ean, :amount, :reserved_amount, :available_amount)"""),
                                {'product_name': product_name, 'ean': ean, 'amount': amount, 'reserved_amount': reserved_amount, 'available_amount': available_amount})


def test_OrderNOGenerate_no_order(db_session):
    create_service = CreateOrder(db_session)
    result = create_service.OrderNOGenerate()
    data = datetime.datetime.now()
    year = data.year
    month = data.month
    number = f'ZO-001-{month:02}-{year}'
    assert result == number

def test_OrderNOGenerate_already_exist(db_session):
    today = datetime.date.today()
    db_session.execute(text('INSERT INTO orders (order_id, create_date) VALUES (:order_id, :create_date)'),{"order_id": "ZO-001", "create_date": today})
    db_session.commit()
    create_service = CreateOrder(db_session)
    result = create_service.OrderNOGenerate()
    data = datetime.datetime.now()
    year = data.year
    month = data.month
    number = f'ZO-002-{month:02}-{year}'
    assert result == number


def test_create_order(db_session, prepare_test_data):
    create_service = CreateOrder(db_session)
    create_service.create_random_order(3, '2025-09-20')
    order_id = db_session.execute(text('SELECT order_id FROM orders ORDER BY order_id DESC LIMIT 1')).scalar()
    result_orders = db_session.execute(text('SELECT * FROM orders WHERE order_id = :order_id'), {'order_id': order_id}).fetchone()
    result_orders_details = db_session.query(OrdersDetails).all()
    result_reservation = db_session.query(Reservation).all()
    assert result_orders.create_date == datetime.date.today()
    assert result_orders.status == 'undone'
    assert result_orders.price > 0
    assert result_orders.total_weight > 0
    assert len(result_orders_details) == 3
    for row in result_orders_details:
        assert row.collected_amount == 0
        assert row.status == 'undone'
        assert row.price_brutto * row.amount == row.total_price

def test_insert_into_orders(db_session, prepare_test_data):
    create_service = CreateOrder(db_session)
    order_id = create_service.OrderNOGenerate()
    create_service.insert_into_orders(order_id)
    result = db_session.execute(text('SELECT * FROM orders WHERE order_id = :order_id'), {'order_id': order_id}).fetchone()
    assert result.status == 'unconfirmed'
    assert result.create_date == datetime.date.today()

@parametrize_decorator
def test_insert_single_product_into_order_details(db_session, prepare_test_data, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    create_service = CreateOrder(db_session)
    order_id = create_service.OrderNOGenerate()
    create_service.insert_into_orders(order_id)
    order_amount = 10
    create_service.insert_single_product_into_orders_details(ean, order_amount, order_id)
    result = db_session.execute(text('SELECT * FROM orders_details WHERE ean = :ean AND order_id = :order_id'), {'ean': ean, 'order_id': order_id}).fetchone()
    assert result.amount == order_amount
    assert result.status == 'unconfirmed'
    assert result.total_price == result.price_brutto * result.amount


def test_add_customer_to_order(db_session, prepare_test_data):
    create_service = CreateOrder(db_session)
    order_id = create_service.OrderNOGenerate()
    create_service.insert_into_orders(order_id)
    customer = "Alfreds Futterkiste"
    customer_id = "ALFKI"
    create_service.add_customer_to_order(customer, order_id)
    result = db_session.execute(text('SELECT customer_id FROM orders WHERE order_id = :order_id'), {'order_id': order_id}).scalar()
    assert result == customer_id

@parametrize_decorator
def test_make_reservation_to_order(db_session, prepare_test_data, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    create_service = CreateOrder(db_session)
    order_id = create_service.OrderNOGenerate()
    create_service.insert_into_orders(order_id)
    customer = "Alfreds Futterkiste"
    customer_id = "ALFKI"
    create_service.add_customer_to_order(customer, order_id)
    order_amount = 10
    create_service.insert_single_product_into_orders_details(ean, order_amount, order_id)
    create_service.make_reservation_for_order(order_id)
    result_reservation = db_session.execute(text('SELECT * FROM reservation WHERE ean = :ean'), {'ean': ean}).fetchone()
    assert result_reservation.reserved_amount == 10
    assert result_reservation.available_amount == amount - 10

def test_check_if_ean_exist_ok(db_session, prepare_test_data):
    create_service = CreateOrder(db_session)
    assert create_service.check_if_ean_exist('5902176770099') is True

def test_check_if_ean_exist_not_found(db_session):
    create_service = CreateOrder(db_session)
    with pytest.raises(HTTPException):
        create_service.check_if_ean_exist('0000000000000')

def test_enough_amount_ok(db_session, prepare_test_data):
    create_service = CreateOrder(db_session)
    assert create_service.check_if_is_enough_amount('5902176770099', 5)

def test_not_enough_amount(db_session, prepare_test_data):
    create_service = CreateOrder(db_session)
    with pytest.raises(HTTPException):
        create_service.check_if_is_enough_amount('5902176770099', 999)

def test_order_open_ok(db_session, prepare_test_data):
    create_service = CreateOrder(db_session)
    order_id = create_service.OrderNOGenerate()
    create_service.insert_into_orders(order_id)
    assert create_service.check_if_order_open(order_id)

def test_order_closed(db_session, prepare_test_data):
    create_service = CreateOrder(db_session)
    order_id = create_service.OrderNOGenerate()
    create_service.insert_into_orders(order_id)
    db_session.execute(
        text("UPDATE orders SET status = 'done' WHERE order_id = :order_id"),
        {"order_id": order_id}
    )
    db_session.commit()
    with pytest.raises(HTTPException):
        create_service.check_if_order_open(order_id)

def test_finish_order(db_session, prepare_test_data):
    product_service = ProductService(db_session)
    create_service = CreateOrder(db_session)
    order_id = create_service.OrderNOGenerate()
    create_service.insert_into_orders(order_id)
    customer = "Alfreds Futterkiste"
    customer_id = "ALFKI"
    create_service.add_customer_to_order(customer, order_id)
    order_amount = 10
    products = db_session.execute(text('SELECT * FROM products ')).mappings().all()
    for i in products:
        create_service.insert_single_product_into_orders_details(i.ean, order_amount, order_id)
    create_service.finish_order(order_id)
    order_status = db_session.execute(text('SELECT status FROM orders WHERE order_id = :order_id'), {'order_id': order_id}).scalar()
    price = product_service.fetch_scalar('SUM(total_price)', {'order_id': order_id}, 'orders_details')
    weight = product_service.fetch_scalar('SUM(product_weight * amount)', {'order_id': order_id}, 'orders_details')
    orders = db_session.execute(text('SELECT * FROM orders WHERE order_id = :order_id'), {'order_id': order_id}).fetchone()
    assert order_status == 'undone'
    assert orders.total_weight == weight
    assert orders.price == price
    assert orders.customer_id == customer_id
    assert orders.amount == 30

def test_cancel_order(db_session, prepare_test_data):
    product_service = ProductService(db_session)
    create_service = CreateOrder(db_session)
    order_id = create_service.OrderNOGenerate()
    create_service.insert_into_orders(order_id)
    customer = "Alfreds Futterkiste"
    customer_id = "ALFKI"
    create_service.add_customer_to_order(customer, order_id)
    order_amount = 10
    products = db_session.execute(text('SELECT * FROM products ')).mappings().all()
    for i in products:
        create_service.insert_single_product_into_orders_details(i.ean, order_amount, order_id)
    create_service.finish_order(order_id)
    create_service.cancel_order(order_id)
    order_status = db_session.execute(text('SELECT status FROM orders WHERE order_id = :order_id'), {'order_id': order_id}).scalar()
    list_order_details = db_session.execute(text('SELECT * FROM orders_details WHERE order_id = :order_id'), {'order_id': order_id}).mappings().all()
    assert len(list_order_details) == 0
    assert order_status == 'cancelled'