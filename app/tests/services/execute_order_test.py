from sqlalchemy import text
from app.tests.conftest import db_session
import pytest
from functools import wraps
from app.warehouse_operations.execute_order import ExecuteOrder
from app.warehouse_operations.create_order import CreateOrder
from app.warehouse_operations.product_operations import ProductService
import datetime


params =[("RADU LEO", "RADUGA LEON BUT. 0,5 L", "5902176770099", 45, "szt ", 0.77, "RI-13-03", "2025-12-09", 0, 45),
                          ("KAZ_MUS_BUT_500", "KAZIMIERZ MUSTAFA BUT. 0,5 L", "5906660570493", 100, "szt ", 0.77, "RK-18-01", "2025-12-09", 0, 100),
                          ("FF USU P", "FUNKY FLUID USUAL PUSZKA 0,5 L", "5907772092798", 1124, "szt ", 0.54, "RA-04-02", "2025-12-09", 0, 1124)]

customers = [("ALFKI", "Alfreds Futterkiste", "Maria Anders", "Sales Representative", "Obere Str. 57", "Berlin"	, "12209", "Germany", "030-0074321", "030-0076545"),
             ("ANATR", "Ana Trujillo Emparedados y helados", "Ana Trujillo", "Owner", "Avda. de la Constitución 2222", "México D.F.", "05021", "Mexico", "(5) 555-4729", "(5) 555-3745")]


def parametrize_decorator(func):
    @pytest.mark.parametrize(
        "code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount", params)
    @wraps(func)
    def wrapper(*args, **kwargs):
        return func(*args, **kwargs)
    return wrapper


def prepare_db(db_session):
    create_service = CreateOrder(db_session)
    for code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount in params:
        db_session.execute(text("""INSERT INTO products (code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount)
                                VALUES (:code, :product_name, :ean, :amount, :jednostka, :unit_weight, :location, :date, :reserved_amount, :available_amount)"""),
                                {'code': code, 'product_name': product_name, 'ean': ean, 'amount': amount, 'jednostka': jednostka, 'unit_weight': unit_weight, 
                                'location': location, 'date': date, 'reserved_amount': reserved_amount, 'available_amount': available_amount})
        db_session.execute(text("""INSERT INTO product_details (product_name, code, ean, purchase_price, unit_weight) 
                                VALUES (:product_name, :code, :ean, :purchase_price, :unit_weight)"""), {'product_name': product_name,'code': code,
        'ean': ean,'purchase_price': 10, 'unit_weight': unit_weight})
        db_session.execute(text("""INSERT INTO reservation (product_name, ean, amount, reserved_amount, available_amount)
                                VALUES (:product_name, :ean, :amount, :reserved_amount, :available_amount)"""),
                                {'product_name': product_name, 'ean': ean, 'amount': amount, 'reserved_amount': reserved_amount, 'available_amount': available_amount})
    for customer_id, company_name, contact_name, contact_title, address, city, postal_code, country, phone, fax in customers:
        db_session.execute(text("""INSERT INTO customers (customer_id, company_name, contact_name, contact_title, address, city, postal_code, country, phone, fax)
                                VALUES (:customer_id, :company_name, :contact_name, :contact_title, :address, :city, :postal_code, :country, :phone, :fax)"""),
                                {'customer_id': customer_id, 'company_name': company_name, 'contact_name': contact_name, 'contact_title': contact_title, 
                                 'address': address, 'city': city, 'postal_code': postal_code, 'country': country, 'phone': phone, 'fax': fax})    
    db_session.commit()
    create_service.create_random_order(3, '18-09-2025')
    order_id = db_session.execute(text('SELECT order_id FROM orders ORDER BY order_id DESC LIMIT 1')).scalar()
    return order_id

def test_Queue_To_Execute_Order(db_session):
    execute_service = ExecuteOrder(db_session)
    order_id  = prepare_db(db_session)
    result = execute_service.Queue_To_Execute_Order(order_id)
    assert len(result) == 3
    assert result[0].location == "RA-04-02"
    assert result[0].product_name == "FUNKY FLUID USUAL PUSZKA 0,5 L"
    assert result[1].location == 'RK-18-01'
    assert result[1].product_name == "KAZIMIERZ MUSTAFA BUT. 0,5 L"
    assert result[2].location == 'RI-13-03'
    assert result[2].product_name == "RADUGA LEON BUT. 0,5 L"

@parametrize_decorator
def test_reservation_by_create_order(db_session, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    execute_service = ExecuteOrder(db_session)
    order_id = prepare_db(db_session)
    reservation = db_session.execute(text('SELECT * FROM reservation WHERE ean = :ean'), {'ean': ean}).fetchone()
    order_amount = db_session.execute(text('SELECT amount FROM orders_details WHERE ean = :ean AND order_id = :order_id'), {'ean': ean, 'order_id': order_id}).scalar()
    assert reservation.reserved_amount == order_amount
    assert reservation.available_amount == amount - order_amount

@parametrize_decorator
def test_reservation_of_location(db_session, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    execute_service = ExecuteOrder(db_session)
    order_id = prepare_db(db_session)
    execute_service.Queue_To_Execute_Order(order_id)
    execute_service.reservation_of_location(order_id)
    result = db_session.execute(text("""SELECT p.amount, p.reserved_amount, p.available_amount FROM products p JOIN orders_details od ON p.ean = od.ean 
                                     WHERE order_id = :order_id"""), {'order_id': order_id}).fetchall()
    assert len(result) == 3
    for row in result:
        assert row.reserved_amount > 0
        assert  0 < row.available_amount < row.amount
    product = db_session.execute(text('SELECT * FROM products WHERE ean = :ean'), {'ean': ean}).fetchone()
    amount_order = db_session.execute(text('SELECT amount FROM orders_details WHERE order_id = :order_id AND ean = :ean'), 
                                {'order_id': order_id, 'ean': ean}).scalar()
    assert product.reserved_amount == amount_order
    assert product.available_amount == product.amount - amount_order

@parametrize_decorator
def test_insert_into_picks(db_session, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    execute_service = ExecuteOrder(db_session)
    order_id = prepare_db(db_session)
    product = execute_service.Queue_To_Execute_Order(order_id)
    execute_service.reservation_of_location(order_id)
    for i in product:
        execute_service.insert_into_picks(order_id, i, i.amount, 'ks')
    picks = db_session.execute(text('SELECT * FROM picks WHERE order_id = :order_id AND ean = :ean'), {'order_id': order_id, 'ean': ean}).fetchone()
    amount_order = db_session.execute(text('SELECT amount FROM orders_details WHERE order_id = :order_id AND ean = :ean'), 
                                {'order_id': order_id, 'ean': ean}).scalar()
    assert picks.product_name == product_name
    assert picks.amount == amount_order
    assert picks.location == location

@parametrize_decorator
def test_take_product_out_of_base(db_session, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    execute_service = ExecuteOrder(db_session)
    order_id = prepare_db(db_session)
    user_id = 'KS'
    execute_service.reservation_of_location(order_id)
    products_before_taken = db_session.execute(text('SELECT amount FROM products  WHERE ean = :ean'), {'ean': ean}).scalar()
    product = db_session.execute(text("""SELECT od.product_name, od.code, od.amount, od.ean, od.status, p.id, p.location, p.date, p.available_amount
        FROM orders_details AS od JOIN products AS p ON od.ean = p.ean WHERE od.order_id = :order_id AND od.status != 'done' AND p.ean = :ean """), 
        {'order_id': order_id, 'ean': ean}).fetchone()
    amount_order = db_session.execute(text('SELECT amount FROM orders_details WHERE order_id = :order_id AND ean = :ean'), 
                                      {'order_id': order_id, 'ean': ean}).scalar()
    execute_service.take_product_out_of_base(order_id, product, amount_order, 0, user_id)
    products_after_taken = db_session.execute(text('SELECT amount FROM products  WHERE ean = :ean'), {'ean': ean}).scalar()
    picks = db_session.execute(text('SELECT * FROM picks WHERE order_id = :order_id AND ean = :ean'), {'order_id': order_id, 'ean': ean}).fetchone()
    order_picking = db_session.execute(text('SELECT * FROM order_picking_details WHERE order_id = :order_id AND expected_ean = :ean'), 
                                       {'order_id': order_id, 'ean': ean}).fetchone()
    order_details = db_session.execute(text('SELECT * FROM orders_details WHERE order_id = :order_id AND ean = :ean'), 
                                       {'order_id': order_id, 'ean': ean}).fetchone()
    reservation = db_session.execute(text('SELECT * FROM reservation WHERE ean = :ean'), {'ean': ean}).fetchone()
    assert products_before_taken > products_after_taken
    assert order_picking.product_name == product_name
    assert order_picking.picked_amount == amount_order
    assert order_picking.picked_location == location
    assert order_details.status == 'done'
    assert order_details.collected_amount == amount_order
    assert reservation.amount == amount - amount_order
    assert reservation.reserved_amount == 0

@parametrize_decorator
def test_delete_row_from_products(db_session, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    execute_service = ExecuteOrder(db_session)
    order_id = prepare_db(db_session)
    user_id = 'KS'
    execute_service.reservation_of_location(order_id)
    product = db_session.execute(text("""SELECT od.product_name, od.code, od.amount, od.ean, od.status, p.id, p.location, p.date, p.available_amount
        FROM orders_details AS od JOIN products AS p ON od.ean = p.ean WHERE od.order_id = :order_id AND od.status != 'done' AND p.ean = :ean """), 
        {'order_id': order_id, 'ean': ean}).fetchone()
    execute_service.take_product_out_of_base(order_id, product, amount, 0, user_id)
    product1 = db_session.execute(text('SELECT * FROM products WHERE ean = :ean AND location = :location AND date= :date'), {'ean': ean, 'location': location, 'date': date}).fetchone()
    execute_service.delete_row_from_products(product1)
    result = db_session.execute(text('SELECT * FROM products WHERE ean = :ean AND location = :location'), {'ean': ean, 'location': location}).mappings().all()
    assert len(result) == 0

@parametrize_decorator
def test_update_when_order_done(db_session, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    execute_service = ExecuteOrder(db_session)
    order_id = prepare_db(db_session)
    user_id = 'KS'
    execute_service.reservation_of_location(order_id)
    product = db_session.execute(text("""SELECT od.product_name, od.code, od.amount, od.ean, od.status, p.id, p.location, p.date, p.available_amount
        FROM orders_details AS od JOIN products AS p ON od.ean = p.ean WHERE od.order_id = :order_id AND od.status != 'done' AND p.ean = :ean """), 
        {'order_id': order_id, 'ean': ean}).fetchone()
    amount_order = db_session.execute(text('SELECT amount FROM orders_details WHERE order_id = :order_id AND ean = :ean'), 
                                      {'order_id': order_id, 'ean': ean}).scalar()
    execute_service.take_product_out_of_base(order_id, product, amount_order, 0, user_id)
    execute_service.update_when_order_done(order_id)
    result = db_session.execute(text('SELECT status FROM orders WHERE order_id = :order_id'), {'order_id': order_id}).scalar()
    assert result == 'done'


def test_get_done_products(db_session):
    execute_service = ExecuteOrder(db_session)
    order_id = prepare_db(db_session)
    user_id = 'KS'
    execute_service.reservation_of_location(order_id)
    for code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount in params:
        product = db_session.execute(text("""SELECT od.product_name, od.code, od.amount, od.ean, od.status, p.id, p.location, p.date, p.available_amount
            FROM orders_details AS od JOIN products AS p ON od.ean = p.ean WHERE od.order_id = :order_id AND od.status != 'done' AND p.ean = :ean """), 
            {'order_id': order_id, 'ean': ean}).fetchone()
        amount_order = db_session.execute(text('SELECT amount FROM orders_details WHERE order_id = :order_id AND ean = :ean'), 
                                        {'order_id': order_id, 'ean': ean}).scalar()
        execute_service.take_product_out_of_base(order_id, product, amount_order, 0, user_id)
    done = execute_service.get_done_products(order_id)
    for row in done:
        result = db_session.execute(text('SELECT * FROM order_picking_details WHERE order_id = :order_id AND expected_ean = :ean'),
                                    {'order_id': order_id, 'ean': row.expected_ean}).fetchone()
        assert row.product_name == result.product_name
        assert row.picked_amount == result.picked_amount
        assert row.picked_location == result.picked_location

@parametrize_decorator
def test_delete_row(db_session, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    execute_service = ExecuteOrder(db_session)
    order_id = prepare_db(db_session)
    user_id = 'KS'
    execute_service.reservation_of_location(order_id)
    product = db_session.execute(text("""SELECT od.product_name, od.code, od.amount, od.ean, od.status, p.id, p.location, p.date, p.available_amount
        FROM orders_details AS od JOIN products AS p ON od.ean = p.ean WHERE od.order_id = :order_id AND od.status != 'done' AND p.ean = :ean """), 
        {'order_id': order_id, 'ean': ean}).fetchone()
    amount_order = db_session.execute(text('SELECT amount FROM orders_details WHERE order_id = :order_id AND ean = :ean'), 
                                    {'order_id': order_id, 'ean': ean}).scalar()
    execute_service.take_product_out_of_base(order_id, product, amount_order, 0, user_id)
    execute_service.delete_row('picks', {'order_id': order_id, 'product_id': product.id})
    picks = db_session.execute(text('SELECT * FROM picks WHERE order_id = :order_id AND ean = :ean'), {'order_id': order_id, 'ean': ean}).fetchone()
    assert picks is None

@parametrize_decorator
def test_revers_orders_details(db_session, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    execute_service = ExecuteOrder(db_session)
    product_service = ProductService(db_session)
    order_id = prepare_db(db_session)
    user_id = 'KS'
    execute_service.reservation_of_location(order_id)
    product = db_session.execute(text("""SELECT od.product_name, od.code, od.amount, od.ean, od.status, p.id, p.location, p.date, p.available_amount
        FROM orders_details AS od JOIN products AS p ON od.ean = p.ean WHERE od.order_id = :order_id AND od.status != 'done' AND p.ean = :ean """), 
        {'order_id': order_id, 'ean': ean}).fetchone()
    amount_order = db_session.execute(text('SELECT amount FROM orders_details WHERE order_id = :order_id AND ean = :ean'), 
                                    {'order_id': order_id, 'ean': ean}).scalar()
    product2 = product_service.fetch_one({'order_id': order_id, 'product_id': product.id}, 'order_picking_details')
    execute_service.take_product_out_of_base(order_id, product, amount_order, 0, user_id)
    product2 = product_service.fetch_one({'order_id': order_id, 'product_id': product.id}, 'order_picking_details')
    collected = db_session.execute(text('SELECT collected_amount FROM orders_details WHERE order_id= :order_id AND product_name= :product_name'),
            {'order_id': order_id, 'product_name': product_name}).scalar()
    execute_service.update_order_details_reverse(product2, collected, order_id)
    order_details = db_session.execute(text('SELECT * FROM orders_details WHERE order_id = :order_id AND ean = :ean'), {'order_id': order_id, 'ean': ean}).fetchone()
    assert order_details.status == 'undone'
    assert order_details.collected_amount == 0

@parametrize_decorator
def test_revers_orders_details(db_session, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    execute_service = ExecuteOrder(db_session)
    product_service = ProductService(db_session)
    order_id = prepare_db(db_session)
    user_id = 'KS'
    execute_service.reservation_of_location(order_id)
    product = db_session.execute(text("""SELECT od.product_name, od.code, od.amount, od.ean, od.status, p.id, p.location, p.date, p.available_amount
        FROM orders_details AS od JOIN products AS p ON od.ean = p.ean WHERE od.order_id = :order_id AND od.status != 'done' AND p.ean = :ean """), 
        {'order_id': order_id, 'ean': ean}).fetchone()
    amount_order = db_session.execute(text('SELECT amount FROM orders_details WHERE order_id = :order_id AND ean = :ean'), 
                                    {'order_id': order_id, 'ean': ean}).scalar()
    execute_service.take_product_out_of_base(order_id, product, amount_order, 0, user_id)
    product_id = product_service.fetch_scalar('id', {'ean': ean, 'location': location, 'date': date}, 'products')
    product2 = product_service.fetch_one({'order_id': order_id, 'product_id': product_id}, 'order_picking_details')
    order_details = db_session.execute(text('SELECT * FROM orders_details WHERE order_id = :order_id AND ean = :ean'), {'order_id': order_id, 'ean': ean}).fetchone()
    execute_service.update_reservation_reverse(product2, order_id)
    reservation = db_session.execute(text('SELECT * FROM reservation WHERE ean = :ean'), {'ean': ean}).fetchone()
    assert reservation.amount == amount
    assert reservation.reserved_amount == order_details.amount


@parametrize_decorator
def test_reverse_picked_products(db_session, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    execute_service = ExecuteOrder(db_session)
    product_service = ProductService(db_session)
    order_id = prepare_db(db_session)
    user_id = 'KS'
    execute_service.reservation_of_location(order_id)
    product = db_session.execute(text("""SELECT od.product_name, od.code, od.amount, od.ean, od.status, p.id, p.location, p.date, p.available_amount
        FROM orders_details AS od JOIN products AS p ON od.ean = p.ean WHERE od.order_id = :order_id AND od.status != 'done' AND p.ean = :ean """), 
        {'order_id': order_id, 'ean': ean}).fetchone()
    amount_order = db_session.execute(text('SELECT amount FROM orders_details WHERE order_id = :order_id AND ean = :ean'), 
                                    {'order_id': order_id, 'ean': ean}).scalar()
    execute_service.take_product_out_of_base(order_id, product, amount_order, 0, user_id)
    done = db_session.execute(text('SELECT * FROM orders_details WHERE order_id = :order_id AND ean = :ean'), {'order_id': order_id, 'ean': ean}).fetchone()
    product_id = product_service.fetch_scalar('id', {'ean': ean, 'location': location, 'date': date}, 'products')
    product2 = product_service.fetch_one({'order_id': order_id, 'product_id': product_id}, 'order_picking_details')
    execute_service.reverse_picked_product_out_of_base(order_id, product2)
    order_picking = db_session.execute(text('SELECT * FROM order_picking_details WHERE order_id = :order_id AND product_id = :product_id'), {'order_id': order_id, 'product_id': product_id}).fetchone()
    product_amount = db_session.execute(text('SELECT amount FROM products WHERE ean = :ean'), {'ean': ean}).scalar()
    assert order_picking is None
    assert product_amount == amount
    assert done.status == 'done'
    assert done.collected_amount > 0
