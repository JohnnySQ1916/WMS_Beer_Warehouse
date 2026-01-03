import random 
from app.database.database import get_db
import datetime
from sqlalchemy.sql import text
from decimal import Decimal
from app.models import OrdersDetails
from sqlalchemy.orm import Session
from fastapi import Depends, HTTPException
from app.warehouse_operations.product_operations import ProductService
from sqlalchemy.exc import SQLAlchemyError


class CreateOrder:
    def __init__(self, db: Session):
        self.db = db

    def OrderNOGenerate(self):
        data = datetime.datetime.now()
        year = data.year
        month = data.month 
        try:
            if self.db.get_bind().dialect.name == 'postgresql':
                query = text("""SELECT COUNT (*) FROM orders WHERE EXTRACT(MONTH FROM create_date) = :month
                            AND EXTRACT(YEAR FROM create_date) = :year""")
                AmountOfOrder = self.db.execute(query, {'month': month, 'year': year}).scalar()
            elif self.db.get_bind().dialect.name == 'sqlite':
                query = text("""SELECT COUNT(*) FROM orders WHERE strftime('%m', create_date) = :month
                                AND strftime('%Y', create_date) = :year""")
                AmountOfOrder = self.db.execute(query, {'month': month, 'year': year}).scalar()
            orderNO = AmountOfOrder + 1
            order_id = f"ZO-{orderNO:03}-{month:02}-{year}"
            checking_query = text("SELECT order_id FROM orders WHERE order_id = :order_id")
            checking = self.db.execute(checking_query, {'order_id': order_id}).fetchone()
            if checking:
                raise ValueError(f"Wygenerowany numer zamówienia {order_id} już istnieje w bazie danych.")
            return order_id
        except Exception as e:
            print("Błąd zapytania SQL:", e)
            self.db.rollback()
            return None


    def making_reservation(self, order_id):
        try:
            query = text("SELECT * FROM orders_details WHERE order_id = :order_id")
            order = self.db.execute(query, {'order_number': order_id})
            for product in order:
                result_query = text("""SELECT amount, reserved_amount, available_amount FROM reservation WHERE product_name = :product_name AND ean = :ean""")
                result = self.db.execute(result_query, {'product_name': product.product_name, 'ean': product.ean}).fetchone()
                if not result:
                    print(f'There is no {product.product_name} in stock')
                    continue
                if product.amount > result.available_amount:
                    print(f'Too less product {product.product_name} in stock')
                    continue
                reservation_query = text("""UPDATE reservation SET reserved_amount = reserved_amount + :reserved_amount, available_amount = amount - :product_amount 
                                        WHERE product_name = :product_name AND ean = :ean""")
                self.db.execute(reservation_query, {'reserved_amount': product.amount, 'product_amount': product.amount, 'product_name': product.product_name,
                                                'ean': product.ean})
            self.db.commit()
            print('Dokonany rezerwacji na podany nr zamówienia')
        except Exception as e:
            self.db.rollback()
            print(f"Błąd przy rezerwacji: {e}")
            return None

    def insert_into_orders(self, order_id):
        insert_query = text("INSERT INTO orders (order_id, create_date, status) VALUES (:order_id, :create_date, :status)")
        self.db.execute(insert_query, {"order_id": order_id, 'create_date': datetime.date.today(), 'status': 'unconfirmed'})
        self.db.commit()
        return True

    def fetch_available_products(self):
        query = text("""SELECT pd.product_name, pd.code, pd.ean, pd.purchase_price, pd.unit_weight, p.amount 
                        FROM product_details AS pd JOIN products AS p  ON pd.ean = p.ean WHERE p.amount > 0""")
        products = self.db.execute(query).fetchall()
        return products
    
    def select_random_products_and_amount(self, selected_products, order_id):
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
                'order_id' : order_id,
                'product_name': product.product_name,
                'code': product.code,
                'amount': quantity,
                'ean': product.ean,
                'price_netto': float(price_netto),
                'price_brutto': float(price_brutto),
                'product_weight': float(product.unit_weight),
                'total_price': float(quantity * price_brutto)
            })
        return order_products

    def insert_products_into_orders_details(self, order_products):
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
                self.db.add(new_item)

    def make_reservation_for_order(self, order_id):
        products = self.db.execute(text('SELECT * FROM orders_details WHERE order_id = :order_id'), {'order_id': order_id}).mappings().all()
        for i in products:
            reservation_query = text("""UPDATE reservation SET reserved_amount = reserved_amount + :amount, available_amount = available_amount - :amount WHERE ean = :i_ean""")
            self.db.execute(reservation_query, {'amount': i['amount'], 'i_ean': i['ean']})

    def update_status_orders(self, order_id):
        self.db.execute(text('UPDATE orders_details SET status = :status WHERE order_id = :order_id'), {'status': 'Undone', 'order_id': order_id})

    def update_orders_with_details(self, customer_id, amount, price, weight, order_id, shipping_date):
        insert_query2 = text("""UPDATE orders SET customer_id = :customer_id, amount = :amount, create_date = :create_date, 
                                status = :status, price= :price, total_weight= :total_weight, shipping_date = :shipping_date WHERE order_id = :order_id""")
        self.db.execute(insert_query2, {'customer_id': customer_id, 'amount': amount, 'create_date': datetime.date.today(), 
                                            'status': 'undone', 'price': price, 'total_weight': weight, 'order_id': order_id, 'shipping_date': shipping_date})


    # Funkcja create_order tworzy losowe zamówienie na podstawie ilości różnych produktów zgłoszonych do zamówienia. 
    # Klient, produkty oraz ich ilości są losowo przyporządkowane. Funkcja została stworzona, gdyż normalne tworzenia zamówienia, 
    # tak jak to sie odbywa w zakładach pracy, zajmuje za dużo czasu :) Właściwa funkcja zostanie stworzona. 
    def create_random_order(self, item_amount, shipping_date):
        product_service = ProductService(self.db)
        try:
            order_id = self.OrderNOGenerate()
            self.insert_into_orders(order_id)
            if not order_id:
                raise HTTPException(status_code= 404, detail= 'There is no order_id')
            products = self.fetch_available_products()
            selected_products = random.sample(products, item_amount)
            order_products = self.select_random_products_and_amount(selected_products, order_id)
            self.insert_products_into_orders_details(order_products)
            self.db.flush()
            self.make_reservation_for_order(order_id)
            self.db.flush()
            customer_query = self.db.execute(text('SELECT customer_id FROM customers')).fetchall()
            customer = random.choice(customer_query)
            customer_id = customer[0]
            amount = product_service.fetch_scalar('SUM(amount)', {'order_id': order_id}, 'orders_details')
            price = product_service.fetch_scalar('SUM(total_price)', {'order_id': order_id}, 'orders_details')
            weight = product_service.fetch_scalar('SUM(product_weight * amount)', {'order_id': order_id}, 'orders_details')
            self.update_orders_with_details(customer_id, amount, price, weight, order_id, shipping_date)
            self.db.commit()
            return order_id
        except Exception as e:
            self.db.rollback()
            raise HTTPException(status_code= 404, detail= f'Appears error: {e}')
            return None
        
    def insert_single_product_into_orders_details(self, ean, amount, order_id):
        product = self.db.execute(text('SELECT * FROM product_details WHERE ean = :ean'), {'ean': ean}).fetchone()
        self.db.execute(text("""INSERT INTO orders_details (order_id, product_name, code, amount,ean, price_netto, price_brutto, product_weight, total_price, status)
                             VALUES (:order_id, :product_name, :code, :amount, :ean, :price_netto, :price_brutto, :product_weight, :total_price, :status)"""),
                             {'order_id': order_id, 'product_name': product.product_name, 'code': product.code, 'amount': amount, 'ean': ean, 
                              'price_netto': product.purchase_price * Decimal(1.3), 
                              'price_brutto': (product.purchase_price * Decimal(1.3)) * Decimal(1.23).quantize(Decimal("0.01")), 'product_weight': product.unit_weight,
                              'total_price': amount * (product.purchase_price * Decimal(1.3)) * Decimal(1.23).quantize(Decimal("0.01")), 'status': 'unconfirmed'})
        self.db.commit()
        return True
    
    def add_customer_to_order(self, company_name, order_id):
        customer_id = self.db.execute(text('SELECT customer_id FROM customers WHERE company_name = :company_name'), {'company_name': company_name}).scalar()
        self.db.execute(text('UPDATE orders SET customer_id= :customer_id WHERE order_id = :order_id'), 
                        {'customer_id': customer_id, 'order_id': order_id})
        self.db.commit()
        return True
    
    def check_if_ean_exist(self, ean):
        result = self.db.execute(text('SELECT 1 FROM product_details WHERE ean= :ean'), {'ean': ean}).scalar()
        if not result: 
            raise HTTPException(status_code=404, detail= 'There is no such ean in database')
        return True
    
    def check_if_is_enough_amount(self, ean, amount):
        available_amount = self.db.execute(text('SELECT SUM(available_amount) FROM products WHERE ean= :ean'), {'ean': ean}).scalar()
        if available_amount < amount: 
            raise HTTPException(status_code=404, detail= 'There is not enough amount on warehouse')
        return True
    
    def check_if_order_open(self, order_id):
        product_service = ProductService(self.db)
        result = product_service.fetch_scalar('status', {'order_id': order_id}, 'orders')
        if result != 'unconfirmed':
            raise HTTPException(status_code= 404, detail= 'Order is closed')
        return True
    
    def finish_order(self, order_id):
        product_service = ProductService(self.db)
        self.make_reservation_for_order(order_id)
        self.update_status_orders(order_id)
        customer_id = product_service.fetch_scalar('customer_id', {'order_id': order_id}, 'orders')
        shipping_date = product_service.fetch_scalar('shipping_date', {'order_id': order_id}, 'orders')
        amount = product_service.fetch_scalar('SUM(amount)', {'order_id': order_id}, 'orders_details')
        price = product_service.fetch_scalar('SUM(total_price)', {'order_id': order_id}, 'orders_details')
        weight = product_service.fetch_scalar('SUM(product_weight * amount)', {'order_id': order_id}, 'orders_details')
        self.update_orders_with_details(customer_id, amount, price, weight, order_id, shipping_date)
        self.db.commit()
        return True

    def cancel_order(self, order_id):
        try:
            self.db.execute(text('DELETE FROM orders_details WHERE order_id =:order_id'), {'order_id': order_id})
            self.db.execute(text('UPDATE orders SET status = :status WHERE order_id= :order_id'), {'status': 'cancelled', 'order_id': order_id})
            self.db.commit()
            return True
        except SQLAlchemyError as e:
            self.db.rollback()
            raise 
