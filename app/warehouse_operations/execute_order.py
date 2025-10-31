from app.database.database import db
from sqlalchemy.sql import text
# from app.routes.confirm_routes import confirm_location
import datetime



def Queue_To_Execute_Order(order_id, min_date=None):
    try:
        bind = db.session.bind or db.engine
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
        result = db.session.execute(text(query), params).fetchall()
        for i in result:
            print(i)
        if not result:
            print(f"Brak elementów do zebrania dla zamówienia {order_id}.")
            return []
        return result
    except Exception as e:
        print(f"Błąd podczas generowania kolejki: {e}")
        return []

# funkcja reservation_of_location czyli funkcja, która przy rezerwacji uwzglednia lokalizacje danego towaru. Funkcja zostaje użyta, gdy magazynier przechodzi do realizacji danego zamówienia
def reservation_of_location(order_id, min_date=None):
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
        WHERE od.order_id = :orderNumber
        """
        params = {'orderNumber': order_id}
        if min_date:
            query += ' AND p.date >= :min_date'
            params['min_date'] = min_date
        query += """ORDER BY
            p.date,
            CASE
                WHEN p.location LIKE 'R%' AND (p.location LIKE '%00' OR p.location LIKE '%01' OR p.location LIKE '%02') THEN 1
                WHEN p.location LIKE 'AT%' THEN 2
                WHEN p.location LIKE 'R%' AND p.location LIKE '%03' OR p.location LIKE '%04' THEN 3
                ELSE 4
            END,
            p.amount DESC,
            p.location"""
        products = db.session.execute(text(query), params).fetchall()
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
                db.session.execute(update_query, {
                                   'take_amount': take_amount, 'product_id': product.id})
                reserved_items[key]['taken_amount'] += take_amount
                reserved_items[key]['location'].append(product.location)

        db.session.commit()
        print('Dokonano rezerwacji na podany nr zamówienia')
        return reserved_items
    except Exception as e:
        db.session.rollback()
        print(f"Błąd przy rezerwacji: {e}")
        return None

def Execute_order(order_id, user_id, min_date=None):
    reservation_of_location(order_id, min_date)
    order = Queue_To_Execute_Order(order_id)
    if not order:
        print("No products to collect for this order.")
        return
    done_products = []
    done_eans = set()
    for product in order:
        if product.ean in done_eans:
            continue
        status_query = text(
            'SELECT status FROM orders_details WHERE id = :product_id AND order_id = :order_id')
        result = db.session.execute(
            status_query, {'product_id': product.id, 'order_id': order_id}).scalar()
        print(f'Product to collect {product.product_name}')
        print(f'Collect from {product.location}. Confirm location:')
        while True:
            location = input('Confirm location: ')
            if location == product.location:
                break
            elif location.lower() == 'skip':
                break
            else:
                print('Wrong location')
        if location.lower() == 'skip':
            continue
        while True:
            ean = input('Enter ean: ')
            if ean == product.ean or ean == '1':
                break
            elif ean.lower() == 'skip':
                break
            else:
                print('Wrong ean')
        if ean.lower() == 'skip':
            continue
        collected = 0
        print(f'Collect {product.amount} items')
        while collected != product.amount:
            amount_input = input('Enter amount: ')
            if amount_input.lower() == 'skip':
                break
            try:
                amount = int(amount_input)
                if amount + collected > product.amount or amount <= 0:
                    print('Wrong amount. Try again')
                else:
                    collected += amount
                    print(f'Collected {collected}/{product.amount}')
                    if collected == product.amount:
                        print('Product fully collected')
                        break
            except ValueError:
                print('Invalid input')
        if amount_input.lower() == 'skip':
            continue
        done_products.append({
            'product_name': product.product_name,
            'collected_amount': collected,
            'expected_amount': product.amount
        })
        picks_query = text("""INSERT INTO picks (user_id, order_id, product_name, amount, date, time, product_id)
                           VALUES (:user_id, :order_id, :product_name, :product_amount, :date, :time, :product_id)""")
        db.session.execute(picks_query, {'user_id': user_id, 'order_id': order_id, 'product_name': product.product_name,
                                         'product_amount': collected, 'date': datetime.date.today(), 'time': datetime.datetime.now().strftime("%H:%M:%S"), 'product_id': product.id})
        order_process_query = text("""INSERT INTO order_picking_details(product_id, product_name, expected_amount, picked_amount, picked_location,
                                   picked_by, scanned_ean, picked_time, status, order_id, picked_date)
                                   VALUES(:product_id, :product_name, :expected_amount, :picked_amount, :picked_location,
                                   :picked_by, :scanned_ean, :picked_time, :status, :order_id, :picked_date)""")
        db.session.execute(order_process_query, {'product_id': product.id, 'product_name': product.product_name, 'expected_amount': product.amount,
                                                 'picked_amount': collected, 'picked_location': location,
                                                 'picked_by': user_id, 'scanned_ean': ean, 'picked_time': datetime.datetime.now().strftime("%H:%M:%S"),
                                                 'status': 'done', 'order_id': order_id, 'picked_date': datetime.date.today()})
        if collected == product.amount:
            done_eans.add(product.ean)
            order_details_query = text(
                "UPDATE orders_details SET status = 'done', collected_amount = :collected WHERE ean = :ean AND order_id = :order_id")
            db.session.execute(order_details_query, {
                               'collected': collected, 'ean': product.ean, 'order_id': order_id})
        else:
            order_details_query = text(
                "UPDATE orders_details SET status = 'done', collected_amount = :collected WHERE id = :product_id AND order_id = :order_id")
            db.session.execute(order_details_query, {
                               'collected': collected, 'product_id': product.id, 'order_id': order_id})
        reservation_query = text("""UPDATE reservation SET amount = amount - :collected, reserved_amount = reserved_amount - :collected,
                                 available_amount = available_amount - :collected  WHERE product_name = :product_name AND ean = :product_ean""")
        db.session.execute(reservation_query, {
                           'collected': collected, 'product_name': product.product_name, 'product_ean': product.ean})
        product_query = text("""UPDATE products SET amount = amount - :collected, reserved_amount = reserved_amount - :collected,
                             available_amount = available_amount - :collected WHERE ean = :product_ean AND location = :product_location AND date = :product_date""")
        db.session.execute(product_query, {'collected': collected, 'product_ean': product.ean,
                           'product_location': product.location, 'product_date': product.date})
        db.session.commit()
        print('Product collected')
    print('Summary')
    for i in done_products:
        print(f"{i['product_name']}   {i['collected_amount']}")
    order_query = text(
        "UPDATE orders SET status = 'done' WHERE order_id = :order_id")
    db.session.execute(order_query, {'order_id': order_id})


def take_product_out_of_base(order_id, product, amount, collected, user_id):
    try:
        picks_query = text("""INSERT INTO picks (user_id, order_id, product_name, amount, date, time, product_id, location, ean)
                            VALUES (:user_id, :order_id, :product_name, :product_amount, :date, :time, :product_id, :location, :ean)""")
        db.session.execute(picks_query, {'user_id': user_id, 'order_id': order_id, 'product_name': product.product_name,
                                         'product_amount': amount, 'date': datetime.date.today(), 'time': datetime.datetime.now().strftime("%H:%M:%S"), 
                                         'product_id': product.id, 'location': product.location, 'ean': product.ean})
        new_collected = collected + amount

        status = 'done' if new_collected == product.amount else 'part'
        order_status = 'done' if status == 'done' else 'pending'

        order_details_query = text(
            "UPDATE orders_details SET status = :status, collected_amount = :collected WHERE ean = :ean AND order_id = :order_id")
        db.session.execute(order_details_query, {
                           'status': order_status, 'collected': new_collected, 'ean': product.ean, 'order_id': order_id})
        order_process_query = text("""INSERT INTO order_picking_details(product_id, product_name, expected_amount, picked_amount, picked_location, 
                            picked_by, scanned_ean, picked_time, status, order_id, picked_date, expected_ean, product_date)
                            VALUES(:product_id, :product_name, :expected_amount, :picked_amount, :picked_location, 
                            :picked_by, :scanned_ean, :picked_time, :status, :order_id, :picked_date, :expected_ean, :product_date)""")
        db.session.execute(order_process_query, {'product_id': product.id, 'product_name': product.product_name, 'expected_amount': product.amount,
                                                 'picked_amount': amount, 'picked_location': product.location,
                                                 'picked_by': user_id, 'scanned_ean': product.ean, 'picked_time': datetime.datetime.now().strftime("%H:%M:%S"),
                                                 'status': status, 'order_id': order_id, 'picked_date': datetime.date.today(), 'expected_ean': product.ean, 
                                                 'product_date': product.date})
        reservation_query = text("""UPDATE reservation SET amount = amount - :collected, reserved_amount = reserved_amount - :collected,
                                    available_amount = available_amount - :collected  WHERE product_name = :product_name AND ean = :product_ean""")
        db.session.execute(reservation_query, {
            'collected': amount, 'product_name': product.product_name, 'product_ean': product.ean})
        product_query = text("""UPDATE products SET amount = amount - :collected, reserved_amount = reserved_amount - :collected,
                                available_amount = available_amount - :collected WHERE ean = :product_ean AND location = :product_location AND date = :product_date""")
        db.session.execute(product_query, {'collected': amount, 'product_ean': product.ean,
                                           'product_location': product.location, 'product_date': product.date})
        amount_on_location_query = text(
            'SELECT available_amount FROM products WHERE ean = :ean AND location = :location AND date = :date')
        amount_on_location = db.session.execute(amount_on_location_query, {
                                                'ean': product.ean, 'location': product.location, 'date': product.date}).scalar()
        if amount_on_location - (amount + collected) == 0:
            delete_row_query = text(
                'DELETE FROM products WHERE ean = :ean AND location = :location AND date = :date')
            db.session.execute(delete_row_query, {
                               'ean': product.ean, 'location': product.location, 'date': product.date})
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        print(f"❌ Błąd podczas zdejmowania produktu z bazy: {e}")


def get_done_products(order_id):
    done_products_query = text("""SELECT product_id, product_name, expected_ean, picked_amount, picked_location FROM order_picking_details 
                               WHERE order_id = :order_id AND status = 'done'""")
    done_products = db.session.execute(
        done_products_query, {'order_id': order_id}).fetchall()
    return done_products


def reverse_picked_product_out_of_base(order_id, product):
    try:
        delete_picks_query = text(
            'DELETE FROM picks WHERE order_id = :order_id AND product_id = :product_id')
        db.session.execute(delete_picks_query, {
                           'order_id': order_id, 'product_id': product.product_id})

        collected_query = text(
            'SELECT collected_amount FROM orders_details WHERE order_id = :order_id AND product_name = :product_name')
        collected = db.session.execute(collected_query, {
                                       'order_id': order_id, 'product_name': product.product_name}).scalar()

        order_details_query = text(
            "UPDATE orders_details SET status = :status, collected_amount = :collected WHERE ean = :ean AND order_id = :order_id")
        db.session.execute(order_details_query, {'status': 'undone', 'collected': collected - product.picked_amount,
                                                 'ean': product.expected_ean, 'order_id': order_id})

        reverse_reservation_query = text("""UPDATE reservation SET amount = amount + :collected, reserved_amount = reserved_amount + :collected,
                                        available_amount = available_amount + :collected  WHERE ean = :ean""")
        db.session.execute(reverse_reservation_query, {
                           'collected': product.picked_amount, 'ean': product.expected_ean, 'order_id': order_id})

        order_picking_query = text(
            'DELETE FROM order_picking_details WHERE order_id = :order_id AND product_id = :product_id')
        db.session.execute(order_picking_query, {
                           'order_id': order_id, 'product_id': product.product_id})

        check_product = text(
            'SELECT COUNT(*) FROM products WHERE ean = :ean AND location = :location AND date = :date')
        exists = db.session.execute(check_product, {
                                    'ean': product.expected_ean, 'location': product.picked_location, 'date': product.product_date}).scalar()
        product_from_db = db.session.execute(text("SELECT ean, location, date FROM products WHERE ean = :ean"),{"ean": product.expected_ean}).fetchall()

        if not exists:
            insert_back = text("""INSERT INTO products (code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount)
                            VALUES (:code, :product_name, :ean, :amount, :jednostka, :unit_weight, :location, :date, :reserved_amount, :available_amount)""")
            product_query = text(
                'SELECT * FROM product_details WHERE ean = :ean')
            product_details = db.session.execute(product_query, {'ean': product.expected_ean}).fetchone()
            db.session.execute(insert_back, {'code': product_details.code, 'product_name': product.product_name, 'ean': product_details.ean,
                                             'amount': product.picked_amount, 'jednostka': 'szt', 'unit_weight': product_details.unit_weight,
                                             'location': product.picked_location, 'date': product.picked_date, 'reserved_amount': 0,
                                             'available_amount': product.picked_amount})
        else:
            update_products = text("""UPDATE products SET amount = amount + :collected, reserved_amount = reserved_amount + :collected, 
                                available_amount= available_amount + :collected WHERE ean = :product_ean AND location = :product_location AND date = :product_date""")
            db.session.execute(update_products, {
                               'collected': product.picked_amount, 'product_ean': product.expected_ean,
                                           'product_location': product.picked_location, 'product_date': product.product_date})
        db.session.commit()
        print('Pick of product has been reverse')
    except Exception as e:
        db.session.rollback()
        print(f"❌ Mistake with rollback pick: {e}")