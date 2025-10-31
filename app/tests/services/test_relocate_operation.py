from app.database.database import db
from sqlalchemy import text
from app.tests.conftest import app, db_session, client
import pytest
from functools import wraps
import random
from app.warehouse_operations.relocate_operation import new_record_relocation, confirm_location, confirm_amount, confirm_target_location, relocate_in_products, new_record_relocation_by_location, confirm_ean

params =[("RADU LEO", "RADUGA LEON BUT. 0,5 L", "5902176770099",	45, "szt ",	0.77, "RI-13-01", "2024-12-09", 0, 45),
                          ("KAZ_MUS_BUT_500", "KAZIMIERZ MUSTAFA BUT. 0,5 L", "5906660570493", 100, "szt ", 0.77, "RK-18-02", "2024-12-09", 0, 100),
                          ("FF USU P", "FUNKY FLUID USUAL PUSZKA 0,5 L", "5907772092798", 1124, "szt ", 0.54, "RA-04-02", "2024-12-09", 0, 1124)]

def parametrize_decorator(func):
    @pytest.mark.parametrize(
        "code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount", params)
    @wraps(func)
    def wrapper(*args, **kwargs):
        return func(*args, **kwargs)
    return wrapper

@parametrize_decorator
def test_new_record_relocation(db_session, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount ):
    db.session.execute(text("""INSERT INTO products (code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount)
                            VALUES (:code, :product_name, :ean, :amount, :jednostka, :unit_weight, :location, :date, :reserved_amount, :available_amount)"""),
                            {'code': code, 'product_name': product_name, 'ean': ean, 'amount': amount, 'jednostka': jednostka, 'unit_weight': unit_weight, 
                            'location': location, 'date': date, 'reserved_amount': reserved_amount, 'available_amount': available_amount})
    db.session.commit()
    new_record_relocation(ean)
    result = db.session.execute(text('SELECT * FROM relocation WHERE ean = :ean'), {'ean': ean}).fetchone()
    assert result is not None
    assert result.status == 'ean_confirmed'
    assert result.product_name == product_name

@parametrize_decorator
def test_confirm_location(db_session, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount ):
    db.session.execute(text("""INSERT INTO products (code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount)
                            VALUES (:code, :product_name, :ean, :amount, :jednostka, :unit_weight, :location, :date, :reserved_amount, :available_amount)"""),
                            {'code': code, 'product_name': product_name, 'ean': ean, 'amount': amount, 'jednostka': jednostka, 'unit_weight': unit_weight, 
                            'location': location, 'date': date, 'reserved_amount': reserved_amount, 'available_amount': available_amount})
    db.session.commit()
    new_record_relocation(ean)
    result = db.session.execute(text('SELECT * FROM relocation WHERE ean = :ean'), {'ean': ean}).fetchone()
    confirm_location(result.id, location, date)
    db.session.expire_all()
    result = db.session.execute(text('SELECT * FROM relocation WHERE ean = :ean'), {'ean': ean}).fetchone()
    assert result is not None
    assert result.status == 'date_confirmed'
    assert result.initial_location == location


@parametrize_decorator
def test_confirm_amount(db_session, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount ):
    db.session.execute(text("""INSERT INTO products (code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount)
                            VALUES (:code, :product_name, :ean, :amount, :jednostka, :unit_weight, :location, :date, :reserved_amount, :available_amount)"""),
                            {'code': code, 'product_name': product_name, 'ean': ean, 'amount': amount, 'jednostka': jednostka, 'unit_weight': unit_weight, 
                            'location': location, 'date': date, 'reserved_amount': reserved_amount, 'available_amount': available_amount})
    db.session.commit()
    new_record_relocation(ean)
    result = db.session.execute(text('SELECT * FROM relocation WHERE ean = :ean'), {'ean': ean}).fetchone()
    confirm_location(result.id, location, date)
    confirm_amount(result.id, amount)
    db.session.expire_all()
    result = db.session.execute(text('SELECT * FROM relocation WHERE ean = :ean'), {'ean': ean}).fetchone()
    assert result is not None
    assert result.status == 'amount_confirmed'
    assert result.amount == amount


@parametrize_decorator
def test_confirm_target_location(db_session, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount ):
    db.session.execute(text("""INSERT INTO products (code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount)
                            VALUES (:code, :product_name, :ean, :amount, :jednostka, :unit_weight, :location, :date, :reserved_amount, :available_amount)"""),
                            {'code': code, 'product_name': product_name, 'ean': ean, 'amount': amount, 'jednostka': jednostka, 'unit_weight': unit_weight, 
                            'location': location, 'date': date, 'reserved_amount': reserved_amount, 'available_amount': available_amount})
    db.session.commit()
    new_record_relocation(ean)
    result = db.session.execute(text('SELECT * FROM relocation WHERE ean = :ean'), {'ean': ean}).fetchone()
    confirm_location(result.id, location, date)
    confirm_amount(result.id, amount)
    target_location = random.choice(['RD-01-01', 'RE-10-02', 'RG-03-03'])
    confirm_target_location(result.id, target_location)
    db.session.expire_all()
    result = db.session.execute(text('SELECT * FROM relocation WHERE ean = :ean'), {'ean': ean}).fetchone()
    assert result is not None
    assert result.status == 'done'
    assert result.target_location == target_location


@parametrize_decorator
def test_relocate_in_products(db_session, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount ):
    db.session.execute(text("""INSERT INTO products (code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount)
                            VALUES (:code, :product_name, :ean, :amount, :jednostka, :unit_weight, :location, :date, :reserved_amount, :available_amount)"""),
                            {'code': code, 'product_name': product_name, 'ean': ean, 'amount': amount, 'jednostka': jednostka, 'unit_weight': unit_weight, 
                            'location': location, 'date': date, 'reserved_amount': reserved_amount, 'available_amount': available_amount})
    db.session.commit()
    new_record_relocation(ean)
    result = db.session.execute(text('SELECT * FROM relocation WHERE ean = :ean'), {'ean': ean}).fetchone()
    confirm_location(result.id, location, date)
    confirm_amount(result.id, amount)
    target_location = random.choice(['RD-01-01', 'RE-10-02', 'RG-03-03'])
    confirm_target_location(result.id, target_location)
    relocate_in_products(ean, location, date, amount, target_location)
    relocated_product = db.session.execute(text('SELECT * FROM products WHERE ean = :ean AND date = :date AND location = :target_location'), 
                                           {'ean': ean, 'date': date, 'target_location': target_location}).fetchone()
    assert relocated_product is not None
    assert relocated_product.location == target_location
    assert relocated_product.date == date
    assert relocated_product.amount >= amount

@parametrize_decorator
def test_new_record_relocation_by_location(db_session, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount ):
    db.session.execute(text("""INSERT INTO products (code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount)
                            VALUES (:code, :product_name, :ean, :amount, :jednostka, :unit_weight, :location, :date, :reserved_amount, :available_amount)"""),
                            {'code': code, 'product_name': product_name, 'ean': ean, 'amount': amount, 'jednostka': jednostka, 'unit_weight': unit_weight, 
                            'location': location, 'date': date, 'reserved_amount': reserved_amount, 'available_amount': available_amount})
    db.session.commit()
    user_id = 'KS'
    new_id = new_record_relocation_by_location(location, user_id)
    result = db.session.execute(text('SELECT * FROM relocation WHERE initial_location = :location AND id = :id'), {'location': location, 'id': new_id}).fetchone()
    assert result is not None
    assert result.status == 'location_confirmed'
    assert result.initial_location == location
    assert result.id == new_id


@parametrize_decorator
def test_confirm_ean(db_session, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount ):
    db.session.execute(text("""INSERT INTO products (code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount)
                            VALUES (:code, :product_name, :ean, :amount, :jednostka, :unit_weight, :location, :date, :reserved_amount, :available_amount)"""),
                            {'code': code, 'product_name': product_name, 'ean': ean, 'amount': amount, 'jednostka': jednostka, 'unit_weight': unit_weight, 
                            'location': location, 'date': date, 'reserved_amount': reserved_amount, 'available_amount': available_amount})
    db.session.commit()
    user_id = 'KS'
    new_id = new_record_relocation_by_location(location, user_id)
    confirm_ean(new_id, product_name, ean, date)
    result = db.session.execute(text('SELECT * FROM relocation WHERE id = :id'), {'id': new_id}).fetchone()
    assert result is not None
    assert result.status == 'date_confirmed'
    assert result.product_name == product_name
    assert result.ean == ean
    assert result.date == date

