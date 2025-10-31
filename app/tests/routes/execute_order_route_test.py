from app.database.database import db
from sqlalchemy import text
from app.tests.conftest import app, db_session, client, token
import pytest
from app.routes.location_operation_routes import get_products_on_location
from functools import wraps
from app.warehouse_operations.execute_order import Queue_To_Execute_Order, take_product_out_of_base, reservation_of_location, get_done_products, reverse_picked_product_out_of_base
from app.warehouse_operations.create_order import OrderNOGenerate, making_reservation, create_order


params =[("RADU LEO", "RADUGA LEON BUT. 0,5 L", "5902176770099", 45, "szt ", 0.77, "RI-13-03", "2025-12-09", 0, 45),
                          ("KAZ_MUS_BUT_500", "KAZIMIERZ MUSTAFA BUT. 0,5 L", "5906660570493", 100, "szt ", 0.77, "RK-18-01", "2025-12-09", 0, 100),
                          ("FF USU P", "FUNKY FLUID USUAL PUSZKA 0,5 L", "5907772092798", 1124, "szt ", 0.54, "RA-04-02", "2025-12-09", 0, 1124)]

customers = [("ALFKI", "Alfreds Futterkiste", "Maria Anders", "Sales Representative", "Obere Str. 57", "Berlin"	, "12209", "Germany", "030-0074321", "030-0076545"),
             ("ANATR", "Ana Trujillo Emparedados y helados", "Ana Trujillo", "Owner", "Avda. de la Constitución 2222", "México D.F.", "05021", "Mexico", "(5) 555-4729", "(5) 555-3745")]

suppliers = [("1", "Grandma Kelly's Homestead", "Regina Murphy", "Sales Representative", "707 Oxford Rd.", "Ann Arbor", "MI", "48104", "USA", "(313) 555-5735", "Cajun"),
             ("2", "Cooperativa de Quesos 'Las Cabras'", "Antonio del Valle Saavedra", "Export Administrator", "Calle del Rosal 4", "Oviedo", "Asturias", "33007", "Spain", "(98) 598 76 54", "Jay Jay Okocha")]


def parametrize_decorator(func):
    @pytest.mark.parametrize(
        "code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount", params)
    @wraps(func)
    def wrapper(*args, **kwargs):
        return func(*args, **kwargs)
    return wrapper

def parametrize_decorator_supplier(func):
    @pytest.mark.parametrize(
        "supplier_id, company_name, contact_name, contact_title, address, city, region, postal_code, country, phone, homepage", suppliers)
    @wraps(func)
    def wrapper(*args, **kwargs):
        return func(*args, **kwargs)
    return wrapper


def prepare_db():
    for code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount in params:
        db.session.execute(text("""INSERT INTO products (code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount)
                                VALUES (:code, :product_name, :ean, :amount, :jednostka, :unit_weight, :location, :date, :reserved_amount, :available_amount)"""),
                                {'code': code, 'product_name': product_name, 'ean': ean, 'amount': amount, 'jednostka': jednostka, 'unit_weight': unit_weight, 
                                'location': location, 'date': date, 'reserved_amount': reserved_amount, 'available_amount': available_amount})
        db.session.execute(text("""INSERT INTO product_details (product_name, code, ean, purchase_price, unit_weight) 
                                VALUES (:product_name, :code, :ean, :purchase_price, :unit_weight)"""), {'product_name': product_name,'code': code,
        'ean': ean,'purchase_price': 10, 'unit_weight': unit_weight})
        db.session.execute(text("""INSERT INTO reservation (product_name, ean, amount, reserved_amount, available_amount)
                                VALUES (:product_name, :ean, :amount, :reserved_amount, :available_amount)"""),
                                {'product_name': product_name, 'ean': ean, 'amount': amount, 'reserved_amount': reserved_amount, 'available_amount': available_amount})
        db.session.execute(text(f"INSERT INTO location_weights (location) VALUES (:location)"), {'location': location})
    for customer_id, company_name, contact_name, contact_title, address, city, postal_code, country, phone, fax in customers:
        db.session.execute(text("""INSERT INTO customers (customer_id, company_name, contact_name, contact_title, address, city, postal_code, country, phone, fax)
                                VALUES (:customer_id, :company_name, :contact_name, :contact_title, :address, :city, :postal_code, :country, :phone, :fax)"""),
                                {'customer_id': customer_id, 'company_name': company_name, 'contact_name': contact_name, 'contact_title': contact_title, 
                                 'address': address, 'city': city, 'postal_code': postal_code, 'country': country, 'phone': phone, 'fax': fax})  
    for supplier_id, company_name, contact_name, contact_title, address, city, region, postal_code, country, phone, homepage in suppliers:
        db.session.execute(text("""INSERT INTO suppliers (supplier_id, company_name, contact_name, contact_title, address, city, region, postal_code, country, phone, homepage)
                                VALUES (:supplier_id, :company_name, :contact_name, :contact_title, :address, :city, :region, :postal_code, :country, :phone, :homepage)"""),
                                {'supplier_id': supplier_id, 'company_name': company_name, 'contact_name': contact_name, 'contact_title': contact_title, 'address': address, 
                                 'city': city, 'region': region, 'postal_code': postal_code, 'country': country, 'phone': phone, 'homepage': homepage})
    db.session.execute(text(f"INSERT INTO location_weights (location) VALUES (:location)"), {'location': 'RB-01-01'}) 
    db.session.commit()

company_name = "Grandma Kelly's Homestead"
user_id = 'ks'
shipping_date = '2025-11-12'


def test_execute_order_choice_positive(app, client, token):
    prepare_db()
    create_order(3, shipping_date)
    orders = db.session.execute(text("""SELECT o.order_id, c.company_name, o.amount, o.total_weight FROM orders o
                        JOIN customers c ON o.customer_id = c.customer_id WHERE o.status = 'Undone'"""))
    response = client.get("/execute_order/order_choice", headers={"Authorization": f"Bearer {token}"})
    response_data = response.get_json()
    assert response.status_code == 200
    assert response_data['Check order'] == 'If you want to check products on order, enter Check order and put order number to the link'
    assert response_data['Order execute'] == 'If you want execute order, enter into  Start Order and put order number to the link'
    assert response_data['orders'] == [{
        'order_id': row.order_id,
        'company name': row.company_name,
        'amount': row.amount,
        'total_weight': row.total_weight
    } for row in orders]

def test_execute_order_choice_negative(app, client, token):
    prepare_db()
    response = client.get("/execute_order/order_choice", headers={"Authorization": f"Bearer {token}"})
    response_data = response.get_json()
    assert response.status_code == 404
    assert response_data['message'] == 'Orders not found'

def test_check_product_on_order_positive(client, token):
    prepare_db()
    create_order(3, shipping_date)
    order_id = db.session.execute(text('SELECT order_id FROM orders ORDER BY order_id DESC LIMIT 1')).scalar()
    products = db.session.execute(text('SELECT * FROM orders_details WHERE order_id = :order_id'), {'order_id': order_id})
    response = client.get(f"/execute_order/check_order/{order_id}", headers={"Authorization": f"Bearer {token}"})
    response_data = response.get_json()
    assert response.status_code == 200
    assert response_data['Products'] == [{
        'Product name': row.product_name,
                'Amount': row.amount
            } for row in products]
    

def test_check_product_on_order_negative(client, token):
    prepare_db()
    order_id = db.session.execute(text('SELECT order_id FROM orders ORDER BY order_id DESC LIMIT 1')).scalar()
    response = client.get(f"/execute_order/check_order/{order_id}", headers={"Authorization": f"Bearer {token}"})
    response_data = response.get_json()
    assert response.status_code == 404
    assert response_data['message'] == 'Order not found'


def test_start_order_positive(client, token):
    prepare_db()
    create_order(3, shipping_date)
    order_id = db.session.execute(text('SELECT order_id FROM orders ORDER BY order_id DESC LIMIT 1')).scalar()
    response = client.get(f"/execute_order/start_order/{order_id}", headers={"Authorization": f"Bearer {token}"})
    response_data = response.get_json()
    order = Queue_To_Execute_Order(order_id)
    first = order[0]
    amount_available_query = text('SELECT available_amount FROM products WHERE ean = :ean AND location = :location AND date = :date')
    amount_available = db.session.execute(amount_available_query, {'ean': first.ean, 'location': first.location, 'date': first.date}).scalar()
    assert response.status_code == 200
    assert response_data['product_name'] == first.product_name
    assert response_data['amount to collect/amount available'] == f'{first.amount}/{amount_available}'
    assert response_data['Location'] == first.location
    assert response_data['message'] ==  f'Confirm location {first.location}'

def test_start_order_negative(client, token):
    prepare_db()
    order_id = db.session.execute(text('SELECT order_id FROM orders ORDER BY order_id DESC LIMIT 1')).scalar()
    response = client.get(f"/execute_order/start_order/{order_id}", headers={"Authorization": f"Bearer {token}"})
    response_data = response.get_json()
    assert response_data['message'] == 'No position to execute'


def test_confirm_location(client, token):
    prepare_db()
    create_order(3, shipping_date)
    order_id = db.session.execute(text('SELECT order_id FROM orders ORDER BY order_id DESC LIMIT 1')).scalar()
    order = Queue_To_Execute_Order(order_id)
    first = order[0]
    response = client.post(f"/execute_order/confirm_location/{order_id}", headers={"Authorization": f"Bearer {token}"}, json = {'location': first.location})
    response_data = response.get_json()
    assert response.status_code == 200
    assert response_data['message'] == 'Enter ean: '

def test_confirm_location_wrong_location(client, token):
    prepare_db()
    create_order(3, shipping_date)
    order_id = db.session.execute(text('SELECT order_id FROM orders ORDER BY order_id DESC LIMIT 1')).scalar()
    location = 'RB-01-01'
    response = client.post(f"/execute_order/confirm_location/{order_id}", headers={"Authorization": f"Bearer {token}"}, json = {'location': location})
    response_data = response.get_json()
    assert response_data['message'] == 'Wrong location. Try again'


def test_confirm_location_no_order(client, token):
    prepare_db()
    order_id = db.session.execute(text('SELECT order_id FROM orders ORDER BY order_id DESC LIMIT 1')).scalar()
    location = 'RB-01-01'
    response = client.post(f"/execute_order/confirm_location/{order_id}", headers={"Authorization": f"Bearer {token}"}, json = {'location': location})
    response_data = response.get_json()
    assert response.status_code == 404
    assert response_data['message'] == f'Brak elementów do zebrania dla zamówienia {order_id}'


def test_confirm_ean(client, token):
    prepare_db()
    create_order(3, shipping_date)
    order_id = db.session.execute(text('SELECT order_id FROM orders ORDER BY order_id DESC LIMIT 1')).scalar()
    order = Queue_To_Execute_Order(order_id)
    first = order[0]
    response = client.post(f"/execute_order/confirm_ean/{order_id}", headers={"Authorization": f"Bearer {token}"}, json = {'ean': first.ean})
    response_data = response.get_json()
    assert response.status_code == 200
    assert response_data['message'] == 'Enter amount: '

def test_confirm_location_wrong_ean(client, token):
    prepare_db()
    create_order(3, shipping_date)
    order_id = db.session.execute(text('SELECT order_id FROM orders ORDER BY order_id DESC LIMIT 1')).scalar()
    ean = '1234567891234'
    response = client.post(f"/execute_order/confirm_ean/{order_id}", headers={"Authorization": f"Bearer {token}"}, json = {'ean': ean})
    response_data = response.get_json()
    assert response_data['message'] == 'Wrong ean. Try again'

def test_confirm_location_no_order(client, token):
    prepare_db()
    order_id = db.session.execute(text('SELECT order_id FROM orders ORDER BY order_id DESC LIMIT 1')).scalar()
    ean = '1234567891234'
    response = client.post(f"/execute_order/confirm_ean/{order_id}", headers={"Authorization": f"Bearer {token}"}, json = {'ean': ean})
    response_data = response.get_json()
    assert response == 404
    assert response_data['message'] == f'Brak elementów do zebrania dla zamówienia {order_id}'

def test_confirm_amount_greater_than_location(client, token):
    prepare_db()
    create_order(3, shipping_date)
    order_id = db.session.execute(text('SELECT order_id FROM orders ORDER BY order_id DESC LIMIT 1')).scalar()
    order = Queue_To_Execute_Order(order_id)
    first = order[0]
    amount_on_location = db.session.execute(text('SELECT amount FROM products WHERE ean = :ean AND location = :location'),
                                            {'ean': first.ean, 'location': first.location}).scalar()
    amount = amount_on_location + 1
    response = client.post(f"/execute_order/confirm_amount/{order_id}", headers={"Authorization": f"Bearer {token}"}, json = {'amount': amount})
    response_data = response.get_json()
    assert response_data['message'] == f'It is only {amount_on_location} amount on location. Try again'
    

def test_confirm_amount_greater_than_location(client, token):
    prepare_db()
    create_order(3, shipping_date)
    order_id = db.session.execute(text('SELECT order_id FROM orders ORDER BY order_id DESC LIMIT 1')).scalar()
    order = Queue_To_Execute_Order(order_id)
    first = order[0]
    collected = db.session.execute(text('SELECT collected_amount FROM orders_details WHERE order_id = :order_id AND ean = :ean'), {'order_id': order_id, 'ean': first.ean}).scalar()
    amount = first.amount + collected + 1
    response = client.post(f"/execute_order/confirm_amount/{order_id}", headers={"Authorization": f"Bearer {token}"}, json = {'amount': amount})
    response_data = response.get_json()
    assert response_data['message'] == 'Too big number to take. Try again'

def test_confirm_amount_positive(client, token):
    prepare_db()
    create_order(3, shipping_date)
    order_id = db.session.execute(text('SELECT order_id FROM orders ORDER BY order_id DESC LIMIT 1')).scalar()
    order = Queue_To_Execute_Order(order_id)
    first = order[0]
    collected = db.session.execute(text('SELECT collected_amount FROM orders_details WHERE order_id = :order_id AND ean = :ean'), {'order_id': order_id, 'ean': first.ean}).scalar()
    amount = first.amount - collected
    response = client.post(f"/execute_order/confirm_amount/{order_id}", headers={"Authorization": f"Bearer {token}"}, json = {'amount': amount})
    response_data = response.get_json()
    assert response.status_code == 200
    assert response_data['message'] == 'Product fully completed. Get next product'

def test_confirm_amount_greater_collected(client, token):
    prepare_db()
    create_order(3, shipping_date)
    order_id = db.session.execute(text('SELECT order_id FROM orders ORDER BY order_id DESC LIMIT 1')).scalar()
    order = Queue_To_Execute_Order(order_id)
    first = order[0]
    collected = db.session.execute(text('SELECT collected_amount FROM orders_details WHERE order_id = :order_id AND ean = :ean'), {'order_id': order_id, 'ean': first.ean}).scalar()
    amount = first.amount - collected - 1
    response = client.post(f"/execute_order/confirm_amount/{order_id}", headers={"Authorization": f"Bearer {token}"}, json = {'amount': amount})
    response_data = response.get_json()
    assert response_data['message'] == f'You took already {amount + collected} units.'

def test_get_next_product(client, token):
    prepare_db()
    create_order(3, shipping_date)
    order_id = db.session.execute(text('SELECT order_id FROM orders ORDER BY order_id DESC LIMIT 1')).scalar()
    order = Queue_To_Execute_Order(order_id)
    first = order[0]
    amount_available = db.session.execute(text('SELECT available_amount FROM products WHERE ean = :ean AND location = :location AND date = :date'),
                                          {'ean': first.ean, 'location': first.location, 'date': first.date}).scalar()
    response = client.get(f"/execute_order/get_next_product/{order_id}", headers={"Authorization": f"Bearer {token}"})
    response_data = response.get_json()
    assert response.status_code == 200
    assert response_data['product_name'] == first.product_name
    assert response_data['amount to collect/amount available'] == f'{first.amount}/{amount_available}'
    assert response_data['Location'] ==  first.location
    assert response_data['message'] == f'Confirm location {first.location}'

def test_show_done_products(client, token):
    prepare_db()
    create_order(3, shipping_date)
    order_id = db.session.execute(text('SELECT order_id FROM orders ORDER BY order_id DESC LIMIT 1')).scalar()
    order = Queue_To_Execute_Order(order_id)
    first = order[0]
    collected = db.session.execute(text('SELECT collected_amount FROM orders_details WHERE order_id = :order_id AND ean = :ean'), {'order_id': order_id, 'ean': first.ean}).scalar()
    amount = first.amount - collected
    client.get(f"/execute_order/start_order/{order_id}", headers={"Authorization": f"Bearer {token}"})
    client.post(f"/execute_order/confirm_ean/{order_id}", headers={"Authorization": f"Bearer {token}"}, json = {'ean': first.ean})
    client.post(f"/execute_order/confirm_amount/{order_id}", headers={"Authorization": f"Bearer {token}"}, json = {'amount': amount})
    response = client.get(f"/execute_order/show_done_products/{order_id}", headers={"Authorization": f"Bearer {token}"})
    response_data = response.get_json()
    done = get_done_products(order_id)
    assert response_data['Done products'] == [{
                'Product name': row.product_name,
                'Amount': row.picked_amount}
                for row in done]
    
def test_reverse_product_positive(client, token):
    prepare_db()
    create_order(3, shipping_date)
    order_id = db.session.execute(text('SELECT order_id FROM orders ORDER BY order_id DESC LIMIT 1')).scalar()
    order = Queue_To_Execute_Order(order_id)
    first = order[0]
    collected = db.session.execute(text('SELECT collected_amount FROM orders_details WHERE order_id = :order_id AND ean = :ean'), {'order_id': order_id, 'ean': first.ean}).scalar()
    amount = first.amount - collected
    client.get(f"/execute_order/start_order/{order_id}", headers={"Authorization": f"Bearer {token}"})
    client.post(f"/execute_order/confirm_ean/{order_id}", headers={"Authorization": f"Bearer {token}"}, json = {'ean': first.ean})
    client.post(f"/execute_order/confirm_amount/{order_id}", headers={"Authorization": f"Bearer {token}"}, json = {'amount': amount})
    first = order[0]
    collected = db.session.execute(text('SELECT collected_amount FROM orders_details WHERE order_id = :order_id AND ean = :ean'), {'order_id': order_id, 'ean': first.ean}).scalar()
    amount = first.amount - collected
    client.get(f"/execute_order/start_order/{order_id}", headers={"Authorization": f"Bearer {token}"})
    client.post(f"/execute_order/confirm_ean/{order_id}", headers={"Authorization": f"Bearer {token}"}, json = {'ean': first.ean})
    client.post(f"/execute_order/confirm_amount/{order_id}", headers={"Authorization": f"Bearer {token}"}, json = {'amount': amount})
    product_id = 3
    response = client.post(f"/execute_order/reverse_product/{order_id}", headers={"Authorization": f"Bearer {token}"}, json = {'product_id': product_id})
    response_data = response.get_json()
    assert response_data['message'] == 'Picked product has been reverse'

def test_reverse_product_negative(client, token):
    prepare_db()
    create_order(3, shipping_date)
    order_id = db.session.execute(text('SELECT order_id FROM orders ORDER BY order_id DESC LIMIT 1')).scalar()
    order = Queue_To_Execute_Order(order_id)
    first = order[0]
    collected = db.session.execute(text('SELECT collected_amount FROM orders_details WHERE order_id = :order_id AND ean = :ean'), {'order_id': order_id, 'ean': first.ean}).scalar()
    amount = first.amount - collected
    client.get(f"/execute_order/start_order/{order_id}", headers={"Authorization": f"Bearer {token}"})
    client.post(f"/execute_order/confirm_ean/{order_id}", headers={"Authorization": f"Bearer {token}"}, json = {'ean': first.ean})
    client.post(f"/execute_order/confirm_amount/{order_id}", headers={"Authorization": f"Bearer {token}"}, json = {'amount': amount})
    first = order[0]
    collected = db.session.execute(text('SELECT collected_amount FROM orders_details WHERE order_id = :order_id AND ean = :ean'), {'order_id': order_id, 'ean': first.ean}).scalar()
    amount = first.amount - collected
    client.get(f"/execute_order/start_order/{order_id}", headers={"Authorization": f"Bearer {token}"})
    client.post(f"/execute_order/confirm_ean/{order_id}", headers={"Authorization": f"Bearer {token}"}, json = {'ean': first.ean})
    client.post(f"/execute_order/confirm_amount/{order_id}", headers={"Authorization": f"Bearer {token}"}, json = {'amount': amount})
    product_id = 999
    response = client.post(f"/execute_order/reverse_product/{order_id}", headers={"Authorization": f"Bearer {token}"}, json = {'product_id': product_id})
    response_data = response.get_json()
    assert response.status_code == 404
    assert response_data['message'] == f'Product with id {product_id} not found for order {order_id}'