from app.database.database import db
from sqlalchemy import text
from app.tests.conftest import app, db_session, client
import pytest
from app.warehouse_operations.location_operations import find_product_by_location


@pytest.mark.parametrize("code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount",
                         [("RADU LEO", "RADUGA LEON BUT. 0,5 L", "5902176770099",	45, "szt ",	0.77, "RI-13-01", "2024-12-09", 0, 45),
                          ("KAZ_MUS_BUT_500", "KAZIMIERZ MUSTAFA BUT. 0,5 L", "5906660570493", 100, "szt ", 0.77, "RK-18-02", "2024-12-09", 0, 100),
                          ("FF USU P", "FUNKY FLUID USUAL PUSZKA 0,5 L", "5907772092798", 1124, "szt ", 0.54, "RA-04-02", "2024-12-09", 0, 1124)]
                         )

def test_find_product_by_location(db_session, code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount ):
    db.session.execute(text("""INSERT INTO products (code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount)
                            VALUES (:code, :product_name, :ean, :amount, :jednostka, :unit_weight, :location, :date, :reserved_amount, :available_amount)"""),
                            {'code': code, 'product_name': product_name, 'ean': ean, 'amount': amount, 'jednostka': jednostka, 'unit_weight': unit_weight, 
                            'location': location, 'date': date, 'reserved_amount': reserved_amount, 'available_amount': available_amount})
    db.session.commit()
    result = find_product_by_location(location)
    assert result is not None
    assert len(result)== 1
    assert result[0]['ean'] == ean
    assert result[0]['product_name'] == product_name