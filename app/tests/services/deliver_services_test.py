from sqlalchemy import text
import pytest
from functools import wraps
from app.warehouse_operations.deliver_services import DeliveryService
from datetime import datetime, date
from app.models import Suppliers, ProductDetails

params =[("RADU LEO", "RADUGA LEON BUT. 0,5 L", "5902176770099", 45, "szt ", 0.77, "RI-13-01", "2025-12-09", 0, 45),
                          ("KAZ_MUS_BUT_500", "KAZIMIERZ MUSTAFA BUT. 0,5 L", "5906660570493", 100, "szt ", 0.77, "RK-18-02", "2024-12-09", 0, 100),
                          ("FF USU P", "FUNKY FLUID USUAL PUSZKA 0,5 L", "5907772092798", 1124, "szt ", 0.54, "RA-04-02", "2024-12-09", 0, 1124)]

suppliers = [("New Orleans Cajun Delights", "Shelley Burke", "Order Administrator", "P.O. Box 78934", "New Orleans", "LA", "70117", "USA", "(100) 555-4822"	, "#CAJUN.HTM#"),
             ("Pavlova, Ltd.", "Ian Devling", "Marketing Manager", "74 Rose St. Moonie Ponds", "Melbourne", "Victoria", "3058", "Australia", "(03) 444-2343", '#CAJUN.HTM#'	)]

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
    for company_name, contact_name, contact_title, address, city, region, postal_code, country, phone, homepage in suppliers:
        db_session.execute(text("""INSERT INTO suppliers (company_name, contact_name, contact_title, address, city, region, 
                                postal_code, country, phone, homepage)
                                VALUES(:company_name, :contact_name, :contact_title, :address, :city, :region, :postal_code, 
                                :country, :phone, :homepage)"""),{'company_name': company_name, 'contact_name': contact_name, 'contact_title': contact_title, 
                                                                  'address': address, 'city': city, 'region': region, 'postal_code': postal_code, 
                                                                  'country': country, 'phone': phone, 'homepage': homepage})
    for _, product_name, ean, amount, *_, reserved_amount, available_amount in params:
        db_session.execute(text("""
            INSERT INTO reservation (product_name, ean, amount, reserved_amount, available_amount)
                                 VALUES (:product_name, :ean, :amount, :reserved_amount, :available_amount)"""),
                                {'product_name': product_name, 'ean': ean, 'amount': amount, 'reserved_amount': reserved_amount, 'available_amount': available_amount})

def test_DeliverIDGenerate(db_session):
    delivery_service = DeliveryService(db_session)
    result = delivery_service.DeliverIDGenerate()
    data = datetime.now()
    year = data.year
    month = data.month
    number = f'PZ-001-{month:02}-{year}'
    assert result is not None
    assert len(result) == len(number)
    assert result == number

def test_check_deliver_to_do(db_session, prepare_test_data):
    delivery_service = DeliveryService(db_session)
    supplier1 = 'New Orleans Cajun Delights'
    supplier2 = 'Firma Krzak'
    delivery_service.create_supplier_deliver(supplier1, '00001', '22-12-2026')
    delivery_service.create_supplier_deliver(supplier2, '00002', '22-12-2026')
    result = db_session.execute(text('SELECT * FROM delivery_order')).mappings().all()
    assert len(result) == 2


def test_supplier_exist(db_session, prepare_test_data):
    delivery_service = DeliveryService(db_session)
    supplier1 = 'New Orleans Cajun Delights'
    supplier2 = 'Firma Krzak'
    assert delivery_service.supplier_exist(supplier1) == True
    assert delivery_service.supplier_exist(supplier2) == False

def test_create_supplier_deliver(db_session, prepare_test_data):
    delivery_service = DeliveryService(db_session)
    supplier1 = 'New Orleans Cajun Delights'
    date_from_supplier = '2025-08-29'
    id = delivery_service.create_supplier_deliver(supplier1, '001/08/2025', date_from_supplier)
    result = db_session.execute(text('SELECT * FROM delivery_order WHERE deliver_id = :id'), {'id': id}).fetchone()
    assert result.supplier == supplier1
    assert str(result.delivery_date) == date_from_supplier
    assert result.deliver_external_number == '001/08/2025'

@parametrize_decorator
def test_create_deliver_details(db_session, prepare_test_data, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    delivery_service = DeliveryService(db_session)
    supplier1 = 'New Orleans Cajun Delights'
    date_from_supplier = '2025-08-29'
    new_amount = 100
    id = delivery_service.create_supplier_deliver(supplier1, '001/08/2025', date_from_supplier)
    delivery_service.create_deliver_details(id, product_name, ean, new_amount)
    result = db_session.execute(text('SELECT * FROM  deliver_details WHERE deliver_id = :id AND ean = :ean'), {'id': id, 'ean': ean}).fetchone()
    assert result.deliver_id == id
    assert result.product_name == product_name
    assert result.ean == ean
    assert result.expected_amount == new_amount

@parametrize_decorator
def test_check_status(db_session, prepare_test_data, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    delivery_service = DeliveryService(db_session)
    supplier1 = 'New Orleans Cajun Delights'
    date_from_supplier = '2025-08-29'
    new_amount = 100
    id = delivery_service.create_supplier_deliver(supplier1, '001/08/2025', date_from_supplier)
    delivery_service.create_deliver_details(id, product_name, ean, new_amount)
    result = delivery_service.check_status(ean, id)
    assert result == 'undone'

@parametrize_decorator
def test_change_ean_status(db_session, prepare_test_data, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    delivery_service = DeliveryService(db_session)
    supplier1 = 'New Orleans Cajun Delights'
    date_from_supplier = '2025-08-29'
    new_amount = 100
    id = delivery_service.create_supplier_deliver(supplier1, '001/08/2025', date_from_supplier)
    delivery_service.create_deliver_details(id, product_name, ean, new_amount)
    delivery_service.change_ean_status(ean, id)
    result = db_session.execute(text('SELECT * FROM  deliver_details WHERE deliver_id = :id AND ean = :ean'), {'id': id, 'ean': ean}).fetchone()
    assert result.status == 'ean confirmed'

@parametrize_decorator
def test_update_products(db_session, prepare_test_data, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    delivery_service = DeliveryService(db_session)
    user_id = 'ks'
    new_item = ProductDetails(code = code, product_name = product_name, ean = ean, unit_weight = unit_weight)
    db_session.add(new_item)
    db_session.commit()
    supplier1 = 'New Orleans Cajun Delights'
    date_from_supplier = '2025-08-29'
    new_amount = 100
    id = delivery_service.create_supplier_deliver(supplier1, '001/08/2025', date_from_supplier)
    delivery_service.create_deliver_details(id, product_name, ean, new_amount)
    db_session.execute(text('UPDATE deliver_details SET amount = :new_amount, date = :date WHERE ean = :ean AND deliver_id = :deliver_id'), 
                       {'ean': ean, 'deliver_id': id, 'date': date, 'new_amount': new_amount})
    delivery_service.change_ean_status(ean, id)
    target_location = 'RB-02-02'
    delivery_service.update_target_location(target_location, user_id, ean, id, 'done')
    delivery_service.update_products(target_location, ean, id)
    result= db_session.execute(text('SELECT * FROM products WHERE ean = :ean AND location = :target_location'),
                               {'ean': ean, 'target_location': target_location}).fetchone()
    assert result.product_name == product_name
    assert result.location == target_location
    assert result.amount >= new_amount
    assert str(result.date) == date

@parametrize_decorator
def test_insert_new_row(db_session, prepare_test_data, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount):
    delivery_service = DeliveryService(db_session)
    supplier1 = 'New Orleans Cajun Delights'
    date_from_supplier = '2025-08-29'
    new_amount = 100
    id = delivery_service.create_supplier_deliver(supplier1, '001/08/2025', date_from_supplier)
    delivery_service.create_deliver_details(id, product_name, ean, new_amount)
    delivery_service.insert_new_row_into_table(id, ean, 'ks', 50)
    result = db_session.execute(text('SELECT * FROM deliver_details')).mappings().all()
    assert len(result) == 2