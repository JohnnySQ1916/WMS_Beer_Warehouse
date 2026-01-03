from sqlalchemy import text
import pytest
from app.routes.location_operation_routes import get_products_on_location
from functools import wraps
from app.warehouse_operations.deliver_services import DeliveryService
from datetime import date as dt, timedelta


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


def prepare_db(db_session):
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
        db_session.execute(text(f"INSERT INTO location_weights (location) VALUES (:location)"), {'location': location})
    for customer_id, company_name, contact_name, contact_title, address, city, postal_code, country, phone, fax in customers:
        db_session.execute(text("""INSERT INTO customers (customer_id, company_name, contact_name, contact_title, address, city, postal_code, country, phone, fax)
                                VALUES (:customer_id, :company_name, :contact_name, :contact_title, :address, :city, :postal_code, :country, :phone, :fax)"""),
                                {'customer_id': customer_id, 'company_name': company_name, 'contact_name': contact_name, 'contact_title': contact_title, 
                                 'address': address, 'city': city, 'postal_code': postal_code, 'country': country, 'phone': phone, 'fax': fax})  
    for supplier_id, company_name, contact_name, contact_title, address, city, region, postal_code, country, phone, homepage in suppliers:
        db_session.execute(text("""INSERT INTO suppliers (supplier_id, company_name, contact_name, contact_title, address, city, region, postal_code, country, phone, homepage)
                                VALUES (:supplier_id, :company_name, :contact_name, :contact_title, :address, :city, :region, :postal_code, :country, :phone, :homepage)"""),
                                {'supplier_id': supplier_id, 'company_name': company_name, 'contact_name': contact_name, 'contact_title': contact_title, 'address': address, 
                                 'city': city, 'region': region, 'postal_code': postal_code, 'country': country, 'phone': phone, 'homepage': homepage})
    db_session.execute(text(f"INSERT INTO location_weights (location) VALUES (:location)"), {'location': 'RB-01-01'}) 
    db_session.commit()

company_name = "Grandma Kelly's Homestead"
external_number = 'ZO-001-2025'
delivery_date = '2025-11-12'
user_id = 'ks'

@parametrize_decorator_supplier
def test_create_supplier_delivery_document(db_session, token, client, supplier_id, company_name, contact_name, contact_title, address, city, region, postal_code, country, phone, homepage):
    prepare_db(db_session)
    deliver_service = DeliveryService(db_session)
    response = client.post('/delivery/create_supplier_delivery', headers={"Authorization": f"Bearer {token}"}, 
                    json = {'supplier': company_name, 'deliver_external_number': external_number, 'delivery_date': delivery_date})
    response_data = response.json()
    exist = deliver_service.supplier_exist(company_name)
    create = deliver_service.create_supplier_deliver
    if exist:
        response.status_code == 200
        response_data['message'] == f'Delivery add to database with number {create}'
    else:
        response.status_code == 400
        response_data['message'] == 'There is no such supplier in database. Add supplier to database'

@parametrize_decorator
def test_create_deliver_details_document(db_session, client, token, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    prepare_db(db_session)
    deliver_service = DeliveryService(db_session)
    products = []
    for code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount in params:
        products.append({'product_name': product_name, 'ean': ean, 'expected_amount': 10})
    deliver_id = deliver_service.create_supplier_deliver(company_name, external_number, delivery_date)
    response = client.post(f'/delivery/create_delivery/{deliver_id}', headers={"Authorization": f"Bearer {token}"}, json = {'products': products})
    response_data = response.json()
    assert response.status_code == 200
    assert response_data['message'] == f'Products add to deliver_order number {deliver_id}'

@parametrize_decorator
def test_check_supplier_delivery_positive(db_session, client, token, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    prepare_db(db_session)
    deliver_service = DeliveryService(db_session)
    products = []
    for code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount in params:
        products.append({'product_name': product_name, 'ean': ean, 'expected_amount': 10})
    deliver_id = deliver_service.create_supplier_deliver(company_name, external_number, delivery_date)
    client.post(f'/delivery/create_delivery/{deliver_id}', headers={"Authorization": f"Bearer {token}"}, json = {'products': products})
    response = client.get(f'/delivery/check_supplier_deliver', headers={"Authorization": f"Bearer {token}"})
    response_data = response.json()
    delivery = db_session.execute(text("SELECT supplier FROM delivery_order WHERE status = 'undone' OR status = 'pending'")).fetchall()
    assert response.status_code == 200
    assert response_data == {'Supplier': [{'Supplier': row.supplier} for row in delivery]}

@parametrize_decorator
def test_check_supplier_delivery_negative(db_session, client, token, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    prepare_db(db_session)
    deliver_service = DeliveryService(db_session)
    deliver_id = '111'
    products = []
    for code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount in params:
        products.append({'product_name': product_name, 'ean': ean, 'expected_amount': 10})
    client.post(f'/delivery/create_delivery/{deliver_id}', headers={"Authorization": f"Bearer {token}"}, json = {'products': products})
    response = client.get(f'/delivery/check_supplier_deliver', headers={"Authorization": f"Bearer {token}"})
    response_data = response.json()
    delivery = db_session.execute(text("SELECT supplier FROM delivery_order WHERE status = 'undone' OR status = 'pending'")).fetchall()
    assert response.status_code == 404
    assert response_data['detail'] == 'No products found for execute delivery'
    
@parametrize_decorator
def test_check_delivery_positive(db_session, client, token, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    prepare_db(db_session)
    deliver_service = DeliveryService(db_session)
    products = []
    for code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount in params:
        products.append({'product_name': product_name, 'ean': ean, 'expected_amount': 10})
    deliver_id = deliver_service.create_supplier_deliver(company_name, external_number, delivery_date)
    client.post(f'/delivery/create_delivery/{deliver_id}', headers={"Authorization": f"Bearer {token}"}, json = {'products': products})
    response = client.get(f'/delivery/check_delivery/{deliver_id}', headers={"Authorization": f"Bearer {token}"})
    response_data = response.json()
    delivery_query = text("SELECT product_name, expected_amount, ean FROM deliver_details WHERE deliver_id = :deliver_id AND status = 'undone'")
    delivery = db_session.execute(delivery_query, {'deliver_id': deliver_id}).fetchall()
    assert response.status_code == 200
    assert response_data == {
        'Products': [
            {'Product_name': row.product_name,
            'Expected_Amount': row.expected_amount,
            'EAN': row.ean}
        for row in delivery]}

@parametrize_decorator
def test_check_delivery_negative(db_session, client, token, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    prepare_db(db_session)
    products = []
    deliver_id = '111'
    for code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount in params:
        products.append({'product_name': product_name, 'ean': ean, 'expected_amount': 10})
    response = client.get(f'/delivery/check_delivery/{deliver_id}', headers={"Authorization": f"Bearer {token}"})
    response_data = response.json()
    assert response.status_code == 404
    assert response_data['detail']== 'No products found for given delivery ID'

@parametrize_decorator
def test_enter_ean_delivery_positive(db_session, client, token, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    prepare_db(db_session)
    deliver_service = DeliveryService(db_session)
    products = []
    for code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount in params:
        products.append({'product_name': product_name, 'ean': ean, 'expected_amount': 10})
    deliver_id = deliver_service.create_supplier_deliver(company_name, external_number, delivery_date)
    client.post(f'/delivery/create_delivery/{deliver_id}', headers={"Authorization": f"Bearer {token}"}, json = {'products': products})
    response = client.post(f'/delivery/enter_ean_delivery/{deliver_id}', headers={"Authorization": f"Bearer {token}"}, json = {'ean': ean})
    response_data = response.json()
    ean_location = db_session.execute(text('SELECT product_name, amount, location, date FROM products WHERE ean = :ean'), {'ean': ean}).fetchall()
    assert response.status_code == 200
    assert response_data['Expected Amount'] == 10
    assert response_data['Products'] == [{
                'Product name': row.product_name,
                'Amount': row.amount,
                'Location': row.location,
                'Date': row.date.strftime('%Y-%m-%d')
            } for row in ean_location]
    assert response_data['message'] == 'Enter product date expired'


@parametrize_decorator
def test_enter_ean_delivery_negative(db_session, client, token, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    prepare_db(db_session)
    products = []
    for code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount in params:
        products.append({'product_name': product_name, 'ean': ean, 'expected_amount': 10})
    deliver_id = '111'
    response = client.post(f'/delivery/enter_ean_delivery/{deliver_id}', headers={"Authorization": f"Bearer {token}"}, json = {'ean': ean})
    response_data = response.json()
    assert response.status_code == 404
    assert response_data['detail'] == 'There is no such ean on deliver list'

@parametrize_decorator
def test_enter_date_delivery_positive(db_session, client, token, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    prepare_db(db_session)
    deliver_service = DeliveryService(db_session)
    products = []
    for code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount in params:
        products.append({'product_name': product_name, 'ean': ean, 'expected_amount': 10})
    expiration_date = (dt.today() + timedelta(days=90)).isoformat()
    deliver_id = deliver_service.create_supplier_deliver(company_name, external_number, delivery_date)
    client.post(f'/delivery/create_delivery/{deliver_id}', headers={"Authorization": f"Bearer {token}"}, json = {'products': products})
    client.post(f'/delivery/enter_ean_delivery/{deliver_id}', headers={"Authorization": f"Bearer {token}"}, json = {'ean': ean})
    response = client.post(f'/delivery/enter_date/{deliver_id}/{ean}', headers={"Authorization": f"Bearer {token}"}, json = {'date': expiration_date})
    response_data = response.json()
    print(response_data)
    assert response.status_code == 200
    assert response_data['message'] == "Enter amount of that product. If there is bigger number than expected amount, add to args 'force': true "


@parametrize_decorator
def test_enter_date_delivery_no_ean(db_session, client, token, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    prepare_db(db_session)
    deliver_service = DeliveryService(db_session)
    products = []
    for code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount in params:
        products.append({'product_name': product_name, 'ean': ean, 'expected_amount': 10})
    expiration_date = (dt.today() + timedelta(days=90)).isoformat()
    deliver_id = deliver_service.create_supplier_deliver(company_name, external_number, delivery_date)
    client.post(f'/delivery/create_delivery/{deliver_id}', headers={"Authorization": f"Bearer {token}"}, json = {'products': products})
    response = client.post(f'/delivery/enter_date/{deliver_id}/{ean}', headers={"Authorization": f"Bearer {token}"}, json = {'date': expiration_date})
    response_data = response.json()
    assert response_data['detail'] == 'Confirm ean'

@parametrize_decorator
def test_enter_date_delivery_wrong_ean(db_session, client, token, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    prepare_db(db_session)
    deliver_service = DeliveryService(db_session)
    products = []
    new_ean = '1234567890000'
    for code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount in params:
        products.append({'product_name': product_name, 'ean': ean, 'expected_amount': 10})
    expiration_date = (dt.today() + timedelta(days=90)).isoformat()
    deliver_id = deliver_service.create_supplier_deliver(company_name, external_number, delivery_date)
    client.post(f'/delivery/create_delivery/{deliver_id}', headers={"Authorization": f"Bearer {token}"}, json = {'products': products})
    client.post(f'/delivery/enter_ean_delivery/{deliver_id}', headers={"Authorization": f"Bearer {token}"}, json = {'ean': ean})
    response = client.post(f'/delivery/enter_date/{deliver_id}/{new_ean}', headers={"Authorization": f"Bearer {token}"}, json = {'date': expiration_date})
    response_data = response.json()
    assert response.status_code == 404
    assert response_data['detail'] == 'There is no such ean on deliver list'


@parametrize_decorator
def test_enter_amount_delivery_positive(db_session, client, token, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    prepare_db(db_session)
    deliver_service = DeliveryService(db_session)
    products = []
    for code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount in params:
        products.append({'product_name': product_name, 'ean': ean, 'expected_amount': 10})
    expiration_date = (dt.today() + timedelta(days=90)).isoformat()
    new_amount = 10
    deliver_id = deliver_service.create_supplier_deliver(company_name, external_number, delivery_date)
    client.post(f'/delivery/create_delivery/{deliver_id}', headers={"Authorization": f"Bearer {token}"}, json = {'products': products})
    client.post(f'/delivery/enter_ean_delivery/{deliver_id}', headers={"Authorization": f"Bearer {token}"}, json = {'ean': ean})
    client.post(f'/delivery/enter_date/{deliver_id}/{ean}', headers={"Authorization": f"Bearer {token}"}, json = {'date': expiration_date})
    response = client.post(f'/delivery/enter_amount_delivery/{deliver_id}/{ean}', headers={"Authorization": f"Bearer {token}"}, json = {'amount': new_amount})
    response_data = response.json()
    assert response.status_code == 200
    assert response_data['message'] == 'Enter target location'

@parametrize_decorator
def test_enter_amount_delivery_greater_amount(db_session, client, token, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    prepare_db(db_session)
    deliver_service = DeliveryService(db_session)
    products = []
    for code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount in params:
        products.append({'product_name': product_name, 'ean': ean, 'expected_amount': 10})
    expiration_date = (dt.today() + timedelta(days=90)).isoformat()
    new_amount = 15
    deliver_id = deliver_service.create_supplier_deliver(company_name, external_number, delivery_date)
    client.post(f'/delivery/create_delivery/{deliver_id}', headers={"Authorization": f"Bearer {token}"}, json = {'products': products})
    client.post(f'/delivery/enter_ean_delivery/{deliver_id}', headers={"Authorization": f"Bearer {token}"}, json = {'ean': ean})
    client.post(f'/delivery/enter_date/{deliver_id}/{ean}', headers={"Authorization": f"Bearer {token}"}, json = {'date': expiration_date})
    response = client.post(f'/delivery/enter_amount_delivery/{deliver_id}/{ean}', headers={"Authorization": f"Bearer {token}"}, json = {'amount': new_amount})
    response_data = response.json()
    assert response.status_code == 400
    assert response_data['detail'] == "Entered amount is bigger than expected amount. If you want to confirm that amount, add to args 'force': true"

@parametrize_decorator
def test_enter_amount_delivery_no_date(db_session, client, token, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    prepare_db(db_session)
    deliver_service = DeliveryService(db_session)
    products = []
    for code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount in params:
        products.append({'product_name': product_name, 'ean': ean, 'expected_amount': 10})
    expiration_date = (dt.today() + timedelta(days=90)).isoformat()
    new_amount = 15
    deliver_id = deliver_service.create_supplier_deliver(company_name, external_number, delivery_date)
    client.post(f'/delivery/create_delivery/{deliver_id}', headers={"Authorization": f"Bearer {token}"}, json = {'products': products})
    client.post(f'/delivery/enter_ean_delivery/{deliver_id}', headers={"Authorization": f"Bearer {token}"}, json = {'ean': ean})
    response = client.post(f'/delivery/enter_amount_delivery/{deliver_id}/{ean}', headers={"Authorization": f"Bearer {token}"}, json = {'amount': new_amount})
    response_data = response.json()
    assert response_data['detail'] == "Confirm date"


@parametrize_decorator
def test_enter_target_location_delivery_positive(db_session, client, token, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    prepare_db(db_session)
    deliver_service = DeliveryService(db_session)
    products = []
    for code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount in params:
        products.append({'product_name': product_name, 'ean': ean, 'expected_amount': 10})
    expiration_date = (dt.today() + timedelta(days=90)).isoformat()
    new_amount = 10
    target_location = 'RB-01-01'
    deliver_id = deliver_service.create_supplier_deliver(company_name, external_number, delivery_date)
    client.post(f'/delivery/create_delivery/{deliver_id}', headers={"Authorization": f"Bearer {token}"}, json = {'products': products})
    client.post(f'/delivery/enter_ean_delivery/{deliver_id}', headers={"Authorization": f"Bearer {token}"}, json = {'ean': ean})
    client.post(f'/delivery/enter_date/{deliver_id}/{ean}', headers={"Authorization": f"Bearer {token}"}, json = {'date': expiration_date})
    client.post(f'/delivery/enter_amount_delivery/{deliver_id}/{ean}', headers={"Authorization": f"Bearer {token}"}, json = {'amount': new_amount})
    response = client.post(f'/delivery/enter_location_delivery/{deliver_id}/{ean}', headers={"Authorization": f"Bearer {token}"}, json = {'location': target_location})
    response_data = response.json()
    assert response.status_code == 200
    assert response_data['message'] == 'Product accepted on location'


@parametrize_decorator
def test_enter_target_location_delivery_no_amount(db_session, client, token, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    prepare_db(db_session)
    deliver_service = DeliveryService(db_session)
    products = []
    for code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount in params:
        products.append({'product_name': product_name, 'ean': ean, 'expected_amount': 10})
    expiration_date = (dt.today() + timedelta(days=90)).isoformat()
    new_amount = 10
    target_location = 'RB-01-01'
    deliver_id = deliver_service.create_supplier_deliver(company_name, external_number, delivery_date)
    client.post(f'/delivery/create_delivery/{deliver_id}', headers={"Authorization": f"Bearer {token}"}, json = {'products': products})
    client.post(f'/delivery/enter_ean_delivery/{deliver_id}', headers={"Authorization": f"Bearer {token}"}, json = {'ean': ean})
    client.post(f'/delivery/enter_date/{deliver_id}/{ean}', headers={"Authorization": f"Bearer {token}"}, json = {'date': expiration_date})
    response = client.post(f'/delivery/enter_location_delivery/{deliver_id}/{ean}', headers={"Authorization": f"Bearer {token}"}, json = {'location': target_location})
    response_data = response.json()
    assert response.status_code == 400
    assert response_data['detail'] == 'Confirm amount'