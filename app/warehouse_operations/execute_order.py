from app.database.database import get_db
from sqlalchemy.sql import text
import datetime
from sqlalchemy.orm import Session
from app.warehouse_operations.product_operations import ProductService


class ExecuteOrder:
    def __init__(self, db:Session):
        self.db = db

    def Queue_To_Execute_Order(self, order_id, min_date=None):
        try:
            bind = self.db.bind or self.db.engine
            dialect = bind.dialect.name
            query = """SELECT
                od.product_name,
                od.code,
                od.amount ,
                od.ean,
                od.status,
                p.id,
                p.location,
                p.date,
                p.reserved_amount,
                p.available_amount
            FROM orders_details AS od
            JOIN products AS p ON od.ean = p.ean
            WHERE od.order_id = :order_id AND od.status != 'done' """
            params = {'order_id': order_id}
            if min_date:
                query += ' AND p.date >= :min_date '
                params['min_date'] = min_date
            if dialect == 'postgresql':
                query += """ORDER BY
                    p.date,
                    CASE
                        WHEN p.location LIKE 'R%' AND split_part(p.location, '-', 3) IN ('00', '01', '02') THEN 1
                        WHEN p.location LIKE 'AT%' THEN 2
                        WHEN p.location LIKE 'R%' AND split_part(p.location, '-', 3) IN ('03', '04') THEN 3
                        ELSE 4
                    END,
                    split_part(p.location, '-', 1),
                    split_part(p.location, '-', 2)::int,
                    split_part(p.location, '-', 3)::int"""
            else:
                query += """ORDER BY
                    p.date,
                    CASE
                        WHEN p.location LIKE 'R%' AND substr(p.location, length(p.location)-1, 2) IN ('00','01','02') THEN 1
                        WHEN p.location LIKE 'AT%' THEN 2
                        WHEN p.location LIKE 'R%' AND substr(p.location, length(p.location)-1, 2) IN ('03','04') THEN 3
                        ELSE 4
                    END,
                    p.location"""
            result = self.db.execute(text(query), params).fetchall()
            if not result:
                return []
            return result
        except Exception as e:
            raise RuntimeError("Queue_To_Execute_Order failed") from e

# funkcja reservation_of_location czyli funkcja, która przy rezerwacji uwzglednia lokalizacje danego towaru. Funkcja zostaje użyta, gdy magazynier przechodzi do realizacji danego zamówienia
    def reservation_of_location(self, order_id, min_date= None):
        try:
            query = """SELECT
                od.product_name,
                od.code,
                od.amount AS required_amount,
                od.ean,
                p.id,
                p.location,
                p.date,
                p.amount,
                p.reserved_amount,
                p.available_amount
            FROM orders_details AS od
            JOIN products AS p ON od.ean = p.ean
            WHERE od.order_id = :order_id
            """
            params = {'order_id': order_id}
            if min_date:
                query += ' AND p.date >= :min_date'
                params['min_date'] = min_date
            query += """ORDER BY
                p.date,
                CASE
                    WHEN p.location LIKE 'R%' AND (p.location LIKE '%00' OR p.location LIKE '%01' OR p.location LIKE '%02') THEN 1
                    WHEN p.location LIKE 'AT%' THEN 2
                    WHEN p.location LIKE 'R%' AND (p.location LIKE '%03' OR p.location LIKE '%04') THEN 3
                    ELSE 4
                END,
                p.amount DESC,
                p.location"""
            products = self.db.execute(text(query), params).fetchall()
            reserved_items = {}
            for product in products:
                key = product.ean
                if key not in reserved_items:
                    reserved_items[key] = {
                        'taken_amount': 0,
                        'required_amount': product.required_amount,
                        'location': []}
                left_to_reserve = reserved_items[key]['required_amount'] - \
                    reserved_items[key]['taken_amount']
                if left_to_reserve <= 0:
                    continue
                take_amount = min(left_to_reserve, product.available_amount)
                if take_amount > 0:
                    update_query = text("""UPDATE products SET reserved_amount = reserved_amount + :take_amount,
                                        available_amount = available_amount -:take_amount WHERE id = :product_id""")
                    self.db.execute(update_query, {
                                    'take_amount': take_amount, 'product_id': product.id})
                    reserved_items[key]['taken_amount'] += take_amount
                    reserved_items[key]['location'].append(product.location)
            self.db.commit()
            return reserved_items
        except Exception as e:
            self.db.rollback()
            print(f"Błąd przy rezerwacji: {e}")
            return None

    def insert_into_picks(self, order_id, product, amount, user_id):
        picks_query = text("""INSERT INTO picks (user_id, order_id, product_name, amount, date, time, product_id, location, ean)
                                VALUES (:user_id, :order_id, :product_name, :product_amount, :date, :time, :product_id, :location, :ean)""")
        self.db.execute(picks_query, {'user_id': user_id, 'order_id': order_id, 'product_name': product.product_name,
                                            'product_amount': amount, 'date': datetime.date.today(), 'time': datetime.datetime.now().strftime("%H:%M:%S"), 
                                            'product_id': product.id, 'location': product.location, 'ean': product.ean})
        
    def update_order_details(self, new_collected, product, order_id):
        status = 'done' if new_collected == product.amount else 'part'
        order_details_query = text(
                "UPDATE orders_details SET status = :status, collected_amount = :collected WHERE ean = :ean AND order_id = :order_id")
        self.db.execute(order_details_query, {
                            'status': status, 'collected': new_collected, 'ean': product.ean, 'order_id': order_id})
        
    def insert_into_order_picking(self, order_id, product, amount, user_id, status):
        order_process_query = text("""INSERT INTO order_picking_details(product_id, product_name, expected_amount, picked_amount, picked_location, 
                                picked_by, scanned_ean, picked_time, status, order_id, picked_date, expected_ean, product_date)
                                VALUES(:product_id, :product_name, :expected_amount, :picked_amount, :picked_location, 
                                :picked_by, :scanned_ean, :picked_time, :status, :order_id, :picked_date, :expected_ean, :product_date)""")
        self.db.execute(order_process_query, {'product_id': product.id, 'product_name': product.product_name, 'expected_amount': product.amount,
                                                'picked_amount': amount, 'picked_location': product.location,
                                                'picked_by': user_id, 'scanned_ean': product.ean, 'picked_time': datetime.datetime.now().strftime("%H:%M:%S"),
                                                'status': status, 'order_id': order_id, 'picked_date': datetime.date.today(), 'expected_ean': product.ean, 
                                                'product_date': product.date})
        
    def update_reservation(self, product, amount):
        reservation_query = text("""UPDATE reservation SET amount = amount - :collected, reserved_amount = reserved_amount - :collected WHERE product_name = :product_name AND ean = :product_ean""")
        self.db.execute(reservation_query, {
            'collected': amount, 'product_name': product.product_name, 'product_ean': product.ean})

    def delete_row_from_products(self, product):
        delete_row_query = text(
                    'DELETE FROM products WHERE ean = :ean AND location = :location AND date = :date')
        self.db.execute(delete_row_query, {
                        'ean': product.ean, 'location': product.location, 'date': product.date})
        
    def delete_row(self, table, params, operator = 'AND'):
        product_service = ProductService(self.db)
        where = product_service.dict_to_where(params, operator)
        delete_row_query = text(
                    f'DELETE FROM {table} WHERE {where}')
        self.db.execute(delete_row_query, params)

    def update_products(self, product, amount):
        self.db.execute(text('UPDATE products SET amount = amount - :amount WHERE ean = :ean AND location = :location AND date = :date'),
                        {'amount': amount, 'ean': product.ean, 'location': product.location, 'date': product.date})


    def take_product_out_of_base(self, order_id, product, amount, collected, user_id):
        product_service = ProductService(self.db)
        try:
            self.insert_into_picks(order_id, product, amount, user_id)
            new_collected = collected + amount

            status = 'done' if new_collected == product.amount else 'part'

            self.update_order_details(new_collected, product, order_id)
            self.insert_into_order_picking(order_id, product, amount, user_id, status)
            self.update_reservation(product, amount)
            amount_on_location = product_service.fetch_scalar('available_amount', {
                                                    'ean': product.ean, 'location': product.location, 'date': product.date}, 'products')
            self.update_products(product, amount)
            if amount_on_location == 0:
                self.delete_row_from_products(product)
            self.db.commit()
        except Exception as e:
            self.db.rollback()
            print(f"❌ Błąd podczas zdejmowania produktu z bazy: {e}")


    def update_when_order_done(self, order_id):
        self.db.execute(text('UPDATE orders SET status = :status WHERE order_id = :order_id'), {'status': 'done', 'order_id': order_id})
        self.db.commit()


    def get_done_products(self, order_id):
        product_service = ProductService(self.db)
        done_products = product_service.fetch_all({'order_id': order_id, 'status': 'done'}, 'order_picking_details', 
                                                  arg = 'product_id, product_name, expected_ean, picked_amount, picked_location')
        return done_products
    
    def update_order_details_reverse(self, product, collected, order_id):
        order_details_query = text("UPDATE orders_details SET status = :status, collected_amount = :collected WHERE ean = :ean AND order_id = :order_id")
        self.db.execute(order_details_query, {'status': 'undone', 'collected': collected - product.picked_amount,
                                                'ean': product.expected_ean, 'order_id': order_id})
        
    def update_reservation_reverse(self, product, order_id):
        product_service = ProductService(self.db)
        reverse_reservation_query = text("""UPDATE reservation SET amount = amount + :collected, reserved_amount = reserved_amount + :collected,
                                            available_amount = available_amount + :collected  WHERE ean = :ean""")
        self.db.execute(reverse_reservation_query, {
                        'collected': product.picked_amount, 'ean': product.expected_ean, 'order_id': order_id})
    
    def insert_product_back(self, product):
        insert_back = text("""INSERT INTO products (code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount)
                                VALUES (:code, :product_name, :ean, :amount, :jednostka, :unit_weight, :location, :date, :reserved_amount, :available_amount)""")
        product_query = text(
            'SELECT * FROM product_details WHERE ean = :ean')
        product_details = self.db.execute(product_query, {'ean': product.expected_ean}).fetchone()
        self.db.execute(insert_back, {'code': product_details.code, 'product_name': product.product_name, 'ean': product_details.ean,
                                        'amount': product.picked_amount, 'jednostka': 'szt', 'unit_weight': product_details.unit_weight,
                                        'location': product.picked_location, 'date': product.picked_date, 'reserved_amount': 0,
                                        'available_amount': product.picked_amount})

    def update_reverse_product(self, product):
        update_products = text("""UPDATE products SET amount = amount + :collected, reserved_amount = reserved_amount + :collected, 
                                    available_amount= available_amount + :collected WHERE ean = :product_ean AND location = :product_location AND date = :product_date""")
        self.db.execute(update_products, {
                        'collected': product.picked_amount, 'product_ean': product.expected_ean,
                                    'product_location': product.picked_location, 'product_date': product.product_date})

    def reverse_picked_product_out_of_base(self, order_id, product):
        try:
            self.delete_row('picks', {'order_id': order_id, 'product_id': product.id})
            product_service = ProductService(self.db)
            collected = product_service.fetch_scalar('collected_amount', {
                                        'order_id': order_id, 'product_name': product.product_name}, 'orders_details')
            self.update_order_details_reverse(product, collected, order_id)
            self.update_reservation_reverse(product, order_id)
            self.delete_row('order_picking_details', {'order_id': order_id, 'product_id': product.product_id})
            exists = product_service.fetch_scalar('COUNT(*)', {
                                        'ean': product.expected_ean, 'location': product.picked_location, 'date': product.product_date}, 'products')
            if not exists:
                self.insert_product_back(product)
            else:
                self.update_reverse_product(product)
            self.db.commit()
            print('Pick of product has been reverse')
        except Exception as e:
            self.db.rollback()
            print(f"❌ Mistake with rollback pick: {e}")