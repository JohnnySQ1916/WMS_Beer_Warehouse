import random 
from app.database.database import db
import datetime
from sqlalchemy.sql import text
from decimal import Decimal
from app.models import OrdersDetails

def OrderNOGenerate():
    data = datetime.datetime.now()
    year = data.year
    month = data.month 
    try:
        if db.engine.name == 'postgresql':
            query = text("""SELECT COUNT (*) FROM orders WHERE EXTRACT(MONTH FROM create_date) = :month
                        AND EXTRACT(YEAR FROM create_date) = :year""")
            AmountOfOrder = db.session.execute(query, {'month': month, 'year': year}).scalar()
        elif db.engine.name == 'sqlite':
            query = text("""SELECT COUNT(*) FROM orders WHERE strftime('%m', create_date) = :month
                            AND strftime('%Y', create_date) = :year""")
            AmountOfOrder = db.session.execute(query, {'month': month, 'year': year}).scalar()
        orderNO = AmountOfOrder + 1
        orderNumber = f"ZO-{orderNO:03}-{month:02}-{year}"
        checking_query = text("SELECT order_id FROM orders WHERE order_id = :order_number")
        checking = db.session.execute(checking_query, {'order_number': orderNumber}).fetchone()
        if checking:
            raise ValueError("Wygenerowany numer zamówienia już istnieje w bazie danych.")
        return orderNumber
    except Exception as e:
        print("Błąd zapytania SQL:", e)
        db.session.rollback()
        return None


def making_reservation(order_number):
    try:
        query = text("SELECT * FROM orders_details WHERE order_id = :order_number")
        order = db.session.execute(query, {'order_number': order_number})
        for product in order:
            result_query = text("""SELECT amount, reserved_amount, available_amount FROM reservation WHERE product_name = :product_name AND ean = :ean""")
            result = db.session.execute(result_query, {'product_name': product.product_name, 'ean': product.ean}).fetchone()
            if not result:
                print(f'There is no {product.product_name} in stock')
                continue
            if product.amount > result.available_amount:
                print(f'Too less product {product.product_name} in stock')
                continue
            reservation_query = text("""UPDATE reservation SET reserved_amount = reserved_amount + :reserved_amount, available_amount = amount - :product_amount 
                                     WHERE product_name = :product_name AND ean = :ean""")
            db.session.execute(reservation_query, {'reserved_amount': product.amount, 'product_amount': product.amount, 'product_name': product.product_name,
                                               'ean': product.ean})
        db.session.commit()
        print('Dokonany rezerwacji na podany nr zamówienia')
    except Exception as e:
        db.session.rollback()
        print(f"Błąd przy rezerwacji: {e}")
        return None




# Funkcja create_order tworzy losowe zamówienie na podstawie ilości różnych produktów zgłoszonych do zamówienia. 
# Klient, produkty oraz ich ilości są losowo przyporządkowane. Funkcja została stworzona, gdyż normalne tworzenia zamówienia, 
# tak jak to sie odbywa w zakładach pracy, zajmuje za dużo czasu :) Właściwa funkcja zostanie stworzona. 
def create_order(item_amount, shipping_date):
    order_number = OrderNOGenerate()
    print(order_number)
    insert_query = text("INSERT INTO orders (order_id) VALUES (:order_id)")
    db.session.execute(insert_query, {"order_id": order_number})
    db.session.commit()
    if not order_number:
        print("Nie udało się wygenerować numeru zamówienia.")
        return
    query = text("""SELECT pd.product_name, pd.code, pd.ean, pd.purchase_price, pd.unit_weight, p.amount 
                 FROM product_details AS pd JOIN products AS p  ON pd.ean = p.ean WHERE p.amount > 0""")
    products = db.session.execute(query).fetchall()
    selected_products = random.sample(products, item_amount)
    order_products = []
    for product in selected_products:
        max_amount = min(15, product.amount)
        if max_amount < 5:
            quantity = product.amount
        else:
            quantity = random.randint(5,max_amount)
        #Hurtownia nakłada 30% marży na wszystkie produkty
        price_netto = product.purchase_price * Decimal(1.3)
        price_brutto = price_netto * Decimal(1.23).quantize(Decimal("0.01"))
        order_products.append({
            'order_id' : order_number,
            'product_name': product.product_name,
            'code': product.code,
            'amount': quantity,
            'ean': product.ean,
            'price_netto': float(price_netto),
            'price_brutto': float(price_brutto),
            'product_weight': float(product.unit_weight),
            'total_price': float(quantity * price_brutto)
        })
    for i in order_products:
        new_item = OrdersDetails(
        order_id=i["order_id"],
        product_name=i["product_name"],
        code=i["code"],
        amount=i["amount"],
        ean=i["ean"],
        price_netto=i["price_netto"],
        price_brutto=i["price_brutto"],
        product_weight=i["product_weight"],
        total_price=i["total_price"])
        db.session.add(new_item)
        #Tworzenie rezerwacji na podstawie nowego zamówienia
        reservation_query = text("""UPDATE reservation SET reserved_amount = :amount WHERE ean = :i_ean AND product_name = :i_product_name""")
        db.session.execute(reservation_query, {'amount': i['amount'], 'i_ean': i['ean'], 'i_product_name': i['product_name']})
    db.session.flush()
    query= text('SELECT customer_id FROM customers')
    customer_query = db.session.execute(query).fetchall()
    customer = random.choice(customer_query)
    customer_id = customer[0]
    amount_query = text('SELECT SUM(amount) FROM orders_details WHERE order_id = :order_number')
    amount = db.session.execute(amount_query, {'order_number': order_number}).fetchone()
    price_query= text('SELECT SUM(total_price) FROM orders_details WHERE order_id = :order_number')
    price = db.session.execute(price_query, {'order_number': order_number}).fetchone()
    weight_query = text('SELECT SUM(product_weight * amount) FROM orders_details WHERE order_id = :order_number')
    weight = db.session.execute(weight_query, {'order_number': order_number}).fetchone()
    insert_query2 = text("""UPDATE orders SET customer_id = :customer_id, amount = :amount, create_date = :create_date, 
                         status = :status, price= :price, total_weight= :total_weight, shipping_date = :shipping_date WHERE order_id = :order_id""")
    db.session.execute(insert_query2, {'customer_id': customer_id, 'amount': amount[0], 'create_date': datetime.date.today(), 
                                       'status': 'Undone', 'price': price[0], 'total_weight': weight[0], 'order_id': order_number, 'shipping_date': shipping_date})
    db.session.commit()
    print(f'Order with number: {order_number} has been created')
