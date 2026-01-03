from app.database.database import get_db
from sqlalchemy import text


def get_current_amount(ean, location, date = None):
    if date:
        query = text('SELECT amount FROM products WHERE location = :location AND ean= :ean AND date= :date')
        result = db.session.execute(query, {'location': location, 'ean': ean, 'date': date}).scalar()
    elif not date:
        query = text('SELECT amount FROM products WHERE location = :location AND ean= :ean')
        result = db.session.execute(query, {'location': location, 'ean': ean}).scalar()
    return result

def update_location(old_location, ean, new_location):
    query = text('UPDATE products SET location = :new_location WHERE ean = :ean AND location = :old_location')
    result = db.session.execute(query, {'new_location': new_location, 'ean': ean, 'old_location': old_location})
    db.session.commit()
    print("Product location updated successfully.")

def update_amount(ean, location, added_amount, operation):
    if operation == 'sum':
        query = text('UPDATE products SET amount = :new_amount WHERE ean = :ean AND location = :location')
        result = db.session.execute(query, {'new_amount': get_current_amount(ean, location)+ added_amount, 'ean': ean, 'location': location})
        db.session.commit()
    elif operation == 'reduce':
        query = text('UPDATE products SET amount = :new_amount WHERE ean = :ean AND location = :location')
        result = db.session.execute(query, {'new_amount': get_current_amount(ean, location)- added_amount, 'ean': ean, 'location': location})
        db.session.commit()
                                
def insert_new_product(amount, new_location, ean, location_choice, date):
    query = text("""
        INSERT INTO products (code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount) 
        SELECT code, product_name, ean, :amount, jednostka, unit_weight, :new_location, :date, :reserved_amount, :amount
        FROM products
        WHERE ean = :ean AND location = :location_choice AND date = :date
        ORDER BY date DESC
        LIMIT 1
    """)
    result = db.session.execute(query, {
                                'amount': amount, 'new_location': new_location, 'ean': ean, 'location_choice': location_choice, 'date': date, 'reserved_amount': 0})
    print(result)
    db.session.commit()

def product_exist_on_location(new_location, ean, location_choice, date):
    check_query = text("""SELECT 1 FROM products WHERE location = :new_location AND ean = :ean 
                            AND date = (SELECT date FROM products WHERE ean = :ean AND location = :location_choice AND date = :date)""")
    exist = db.session.execute(check_query, {
                        'new_location': new_location, 'ean': ean, 'location_choice': location_choice, 'date': date}).fetchone()
    return bool(exist)

def Execute_order(self, order_id, user_id, min_date=None):
    self.reservation_of_location(order_id, min_date)
    order = self.Queue_To_Execute_Order(order_id)
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
        result = self.db.execute(
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
        self.db.execute(picks_query, {'user_id': user_id, 'order_id': order_id, 'product_name': product.product_name,
                                        'product_amount': collected, 'date': datetime.date.today(), 'time': datetime.datetime.now().strftime("%H:%M:%S"), 'product_id': product.id})
        order_process_query = text("""INSERT INTO order_picking_details(product_id, product_name, expected_amount, picked_amount, picked_location,
                                picked_by, scanned_ean, picked_time, status, order_id, picked_date)
                                VALUES(:product_id, :product_name, :expected_amount, :picked_amount, :picked_location,
                                :picked_by, :scanned_ean, :picked_time, :status, :order_id, :picked_date)""")
        self.db.execute(order_process_query, {'product_id': product.id, 'product_name': product.product_name, 'expected_amount': product.amount,
                                                'picked_amount': collected, 'picked_location': location,
                                                'picked_by': user_id, 'scanned_ean': ean, 'picked_time': datetime.datetime.now().strftime("%H:%M:%S"),
                                                'status': 'done', 'order_id': order_id, 'picked_date': datetime.date.today()})
        if collected == product.amount:
            done_eans.add(product.ean)
            order_details_query = text(
                "UPDATE orders_details SET status = 'done', collected_amount = :collected WHERE ean = :ean AND order_id = :order_id")
            self.db.execute(order_details_query, {
                            'collected': collected, 'ean': product.ean, 'order_id': order_id})
        else:
            order_details_query = text(
                "UPDATE orders_details SET status = 'done', collected_amount = :collected WHERE id = :product_id AND order_id = :order_id")
            self.db.execute(order_details_query, {
                            'collected': collected, 'product_id': product.id, 'order_id': order_id})
        reservation_query = text("""UPDATE reservation SET amount = amount - :collected, reserved_amount = reserved_amount - :collected,
                                available_amount = available_amount - :collected  WHERE product_name = :product_name AND ean = :product_ean""")
        self.db.execute(reservation_query, {
                        'collected': collected, 'product_name': product.product_name, 'product_ean': product.ean})
        product_query = text("""UPDATE products SET amount = amount - :collected, reserved_amount = reserved_amount - :collected,
                            available_amount = available_amount - :collected WHERE ean = :product_ean AND location = :product_location AND date = :product_date""")
        self.db.execute(product_query, {'collected': collected, 'product_ean': product.ean,
                        'product_location': product.location, 'product_date': product.date})
        self.db.commit()
        print('Product collected')
    print('Summary')
    for i in done_products:
        print(f"{i['product_name']}   {i['collected_amount']}")
    order_query = text(
        "UPDATE orders SET status = 'done' WHERE order_id = :order_id")
    self.db.execute(order_query, {'order_id': order_id})