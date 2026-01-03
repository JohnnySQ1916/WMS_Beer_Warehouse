from sqlalchemy import text
from app.tests.conftest import db_session, client, token
import pytest
from functools import wraps
from app.warehouse_operations.relocate_operation import RelocationService


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
    db_session.execute(text(f"INSERT INTO location_weights (location) VALUES (:location)"), {'location': 'RB-01-01'}) 
    db_session.commit()

user_id = 'ks'

@parametrize_decorator
def test_get_product_by_ean(db_session, token, client, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    prepare_db(db_session)
    relocate_service = RelocationService(db_session)
    response = client.get(f'/relocation/start/{ean}', headers={"Authorization": f"Bearer {token}"})
    product = [{'code': code, 'product_name': product_name, 'amount': amount, 'jednostka': jednostka, 
               'location': location, 'date': date}]
    response_data = response.json()
    relocation_id = db_session.execute(text('SELECT id FROM relocation WHERE ean = :ean ORDER BY id DESC LIMIT 1'), {'ean': ean}).scalar()
    assert response_data['product'] == product
    assert response_data['message'] == 'Enter location'
    assert response_data['relocation_id'] == relocation_id

@parametrize_decorator
def test_enter_location(db_session, client, token, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    prepare_db(db_session)
    relocate_service = RelocationService(db_session)
    relocate_service.new_record_relocation(ean)
    relocation_id = db_session.execute(text('SELECT id FROM relocation WHERE ean = :ean ORDER BY id DESC LIMIT 1'), {'ean': ean}).scalar()
    response = client.post(f'/relocation/enter_location/{relocation_id}', headers={"Authorization": f"Bearer {token}"}, json= {'location':location})
    response_data = response.json()
    dooble = db_session.execute(text(
        'SELECT id, product_name, date, amount FROM products WHERE ean= :ean AND location = :location'),{'ean': ean, 'location': location}).fetchall()
    print(response_data)
    if len(dooble) == 1:
        assert response_data['message'] == 'Enter amount: '
    elif len(dooble) > 1:
        assert response_data['message'] == 'Choose product to relocate'
        for row in dooble:
            assert row.id == response_data['id']
            assert row.date == response_data['date']
            assert row.product_name == response_data['product_date']
            assert row.amount == response_data['amount']
    else: 
        assert response_data['message'] == f'No product found with EAN {ean} on location {location}.'

@parametrize_decorator
def test_enter_amount(db_session, client, token, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    prepare_db(db_session)
    relocate_service = RelocationService(db_session)
    relocate_service.new_record_relocation(ean)
    relocation_id = db_session.execute(text('SELECT id FROM relocation WHERE ean = :ean ORDER BY id DESC LIMIT 1'), {'ean': ean}).scalar()
    relocate_service.confirm_location(relocation_id, location, date, user_id)
    new_amount = 40
    response = client.post(f'/relocation/confirm_amount/{relocation_id}', headers={"Authorization": f"Bearer {token}"}, json= {'amount':new_amount})
    response_data = response.json()
    if new_amount > amount:
        assert response_data['message'] == f'Too high number to relocate. On location it is only {amount}.'
        assert response.status_code == 200
    else:
        assert response_data['message'] == 'Enter target location'
        assert response.status_code == 200

@parametrize_decorator
def test_enter_target_location(db_session, client, token, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    prepare_db(db_session)
    relocate_service = RelocationService(db_session)
    relocate_service.new_record_relocation(ean)
    relocation_id = db_session.execute(text('SELECT id FROM relocation WHERE ean = :ean ORDER BY id DESC LIMIT 1'), {'ean': ean}).scalar()
    relocate_service.confirm_location(relocation_id, location, date, user_id)
    new_amount = 40
    relocate_service.confirm_amount(relocation_id, new_amount)
    status = db_session.execute(text("SELECT status FROM relocation WHERE id = :id"),{'id': relocation_id}).scalar()
    target_location = 'RB-01-01'
    response = client.post(f'/relocation/confirm_target_location/{relocation_id}', headers={"Authorization": f"Bearer {token}"}, json= {'location':target_location})
    response_data = response.json()
    print(response_data)
    assert response_data['message'] == 'Relocate confirmed'
    assert response.status_code == 200

@parametrize_decorator
def test_get_product_by_location(db_session, client, token, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    prepare_db(db_session)
    relocate_service = RelocationService(db_session)
    response = client.get(f'/relocation/relocate_by_location/{location}', headers={"Authorization": f"Bearer {token}"})
    response_data = response.json()
    user_id = 'ks'
    product = db_session.execute(text("SELECT code, product_name, ean, amount, jednostka, location FROM products WHERE location = :location"),
                                 {'location': location}).mappings().all()
    relocate_service.new_record_relocation_by_location(location, user_id)
    id = db_session.execute(text('SELECT id FROM relocation ORDER BY id')).scalar()
    print(id)
    print(response_data)
    assert response.status_code == 200
    assert response_data['message'] == 'Enter ean'
    assert response_data['id'] == id
    assert response_data['product'] == product

@parametrize_decorator
def test_get_product_by_location(db_session, client, token, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    prepare_db(db_session)
    relocate_service = RelocationService(db_session)
    user_id = 'ks'
    relocate_service.new_record_relocation_by_location(location, user_id)
    relocation_id = db_session.execute(text('SELECT id FROM relocation ORDER BY id')).scalar()
    response = client.post(f'/relocation/enter_ean/{relocation_id}', headers={"Authorization": f"Bearer {token}"}, json = {'ean': ean})
    response_data = response.json()
    result = db_session.execute(text('SELECT * FROM products WHERE ean = :ean AND location = :location'), {'ean': ean, 'location': location}).fetchall()
    assert response.status_code == 200
    if len(result)> 1:
        assert response_data['message'] == 'Choose product to relocate'
        for row in response_data['data']:
            for i in result:
                if row.ean == i.ean:
                    assert row.id == i.id
                    assert row.product_name == i.product_name
                    assert row.date == i.date
                    assert row.amount == i.amount
    elif len(result)== 1:
        assert response_data['message'] == 'Enter amount: '
    else:
        assert response_data['message'] == f'No product found with EAN {ean} on location {location}.'