from app.database.database import get_db
from sqlalchemy.sql import text
from datetime import datetime, date, timezone
from app.models import DeliveryDetail, DeliveryOrder
from sqlalchemy.orm import Session


class DeliveryService:
    def __init__(self, db: Session):
        self.db = db

    def DeliverIDGenerate(self):
        data = datetime.now()
        year = data.year
        month = data.month
        if self.db.bind.dialect.name == 'postgresql':
        # Pobranie liczby zamówieni z danego miesiaca
            query = text("""SELECT COUNT (*) FROM delivery_order WHERE EXTRACT(MONTH FROM create_date) = :month
                        AND EXTRACT(YEAR FROM create_date) = :year""")
            AmountOfOrder = self.db.execute(query, {'month': month, 'year': year}).scalar()
        elif self.db.bind.dialect.name == 'sqlite':
            query = text("""SELECT COUNT (*) FROM delivery_order WHERE strftime('%m', create_date) = :month
                        AND strftime('%Y', create_date) = :year""")
            AmountOfOrder = self.db.execute(query, {'month': month, 'year': year}).scalar()
        orderNO = AmountOfOrder + 1
        DeliverNumber = f"PZ-{orderNO:03}-{month:02}-{year}"
        # Sprawdzenie, czy numer zamówienia jest unikalny
        checking_query = text(
            "SELECT deliver_id FROM delivery_order WHERE deliver_id = :deliver_id")
        checking = self.db.execute(
            checking_query, {'deliver_id': DeliverNumber}).fetchone()
        if checking:
            raise ValueError("Generated deliver number is already exist.")
        return DeliverNumber

    def check_deliver_to_do(self):
        result = self.db.execute(text("SELECT * FROM delivery_order WHERE status = 'undone' OR status = 'pending'")).fetchall()
        return result

    def supplier_exist(self, supplier):
        result = self.db.execute(text(
            'SELECT company_name FROM suppliers WHERE company_name = :name'), {'name': supplier}).scalar()
        return bool(result)


    def create_supplier_deliver(self, supplier, deliver_external_number, delivery_date):
        try:
            deliver_id = self.DeliverIDGenerate()
            delivery_order_query = text("""INSERT INTO delivery_order (deliver_id, supplier, delivery_date, deliver_external_number, create_date, status)
                                        VALUES(:deliver_id, :supplier, :delivery_date, :deliver_external_number, :create_date, :status)""")
            self.db.execute(delivery_order_query, {'deliver_id': deliver_id, 'supplier': supplier, 'delivery_date': delivery_date,
                                                    'deliver_external_number': deliver_external_number, 'create_date': date.today(), 'status': 'undone'})
            self.db.commit()
            print(deliver_id)
            return deliver_id
        except Exception as e:
            self.db.rollback()
            print(f'Error while creating delivery {e}')
            return False


    def create_deliver_details(self, deliver_id, product_name, ean, expected_amount):
        try:
            new_item = DeliveryDetail(deliver_id = deliver_id, product_name = product_name, ean = ean, expected_amount = expected_amount)
            self.db.add(new_item)
            self.db.commit()
            return deliver_id
        except Exception as e:
            self.db.rollback()
            print(f'Error while creating delivery details {e}')
            return False
        
    def check_undone_deliver(self, deliver_id):
        delivery_query = text("SELECT product_name, expected_amount, ean FROM deliver_details WHERE deliver_id = :deliver_id AND status NOT IN ('done', 'pending')")
        delivery = self.db.execute(delivery_query, {'deliver_id': deliver_id}).fetchall()
        return delivery


    def check_status(self, ean, deliver_id):
        result = self.db.execute(text('SELECT status FROM deliver_details WHERE ean = :ean AND deliver_id = :deliver_id AND target_location IS NULL'),
                                    {'ean': ean, 'deliver_id': deliver_id}).fetchone()
        if not result:
            return None
        return result[0]

    def update_date(self, deliver_id, expiration_date, ean):
        update_query = text("UPDATE deliver_details SET date = :date, status = 'date confirmed' WHERE deliver_id = :deliver_id AND ean = :ean AND target_location IS NULL")
        self.db.execute(update_query, {'date': expiration_date, 'deliver_id': deliver_id, 'ean': ean})
        self.db.commit()

    def update_amount_when_not_expected_amount(self, deliver_id, amount, ean):
        self.db.execute(text("UPDATE deliver_details SET amount = :amount, status = 'amount confirmed' WHERE deliver_id = :deliver_id AND ean = :ean AND target_location IS NULL"),
                        {'amount': amount, 'deliver_id': deliver_id, 'ean': ean})
        self.db.commit()

    def update_amount_with_expected_amount(self, deliver_id, amount, ean):
        self.db.execute(text("UPDATE deliver_details SET amount = :amount, status = 'amount confirmed' WHERE deliver_id = :deliver_id AND ean = :ean"),
                        {'amount': amount, 'deliver_id': deliver_id, 'ean': ean})
        self.db.commit()

    def update_target_location(self, target_location, user_id, ean, deliver_id, status):
        update_deliver_query = text("""UPDATE deliver_details SET user_id = :user_id, target_location = :target_location, deliver_time = :deliver_time, status = :status,
                                deliver_date = :deliver_date WHERE ean = :ean AND deliver_id = :deliver_id AND target_location IS NULL""")
        self.db.execute(update_deliver_query, {'user_id': user_id, 'target_location': target_location, 'ean': ean, 'deliver_id': deliver_id, 
                                            'deliver_time':  datetime.now(timezone.utc), 'status': status, 'deliver_date': date.today()})
        self.db.commit()

    def change_ean_status(self, ean, deliver_id):
        try:
            update_query = text(
                "UPDATE deliver_details SET status = 'ean confirmed' WHERE deliver_id = :deliver_id AND ean = :ean AND target_location IS NULL")
            update = self.db.execute(
                update_query, {'deliver_id': deliver_id, 'ean': ean})
            self.db.commit()
        except Exception as e:
            self.db.rollback()
            print(f'Its appear an error {e}')

    def insert_new_row_into_table(self, deliver_id, ean, user_id, total_amount):
        product_query = text('SELECT * FROM deliver_details WHERE deliver_id = :deliver_id AND ean = :ean ORDER BY id DESC LIMIT 1')
        product = self.db.execute(product_query, {'deliver_id': deliver_id, 'ean': ean}).fetchone()
        insert_query = text("""INSERT INTO deliver_details (deliver_id, user_id, product_name, ean, expected_amount, status)
                            VALUES (:deliver_id, :user_id, :product_name, :ean, :expected_amount, :status)""")
        self.db.execute(insert_query, {'deliver_id': deliver_id, 'user_id': user_id, 
                                                'product_name': product.product_name, 'ean': ean, 'expected_amount': product.expected_amount - total_amount, 'status': 'undone'})
        self.db.commit()

    def check_if_done(self, deliver_id):
        if_done = self.db.execute(text("SELECT * FROM deliver_details WHERE deliver_id = :deliver_id AND status = 'undone' LIMIT 1"), {'deliver_id': deliver_id}).fetchone()
        return if_done

    def update_deliver_order(self, deliver_id):
        self.db.execute(text("UPDATE delivery_order SET status = 'done' WHERE deliver_id = :deliver_id"), {'deliver_id': deliver_id})
        self.db.commit()

    def update_products(self, target_location, ean, deliver_id):
        try:
            deliver_product = self.db.execute(text("""SELECT * FROM deliver_details WHERE deliver_id = :deliver_id AND ean = :ean  
                                                    AND status IN ('pending', 'done') ORDER BY id DESC LIMIT 1"""),
                                                {'deliver_id': deliver_id, 'ean': ean}).fetchone()
            product = self.db.execute(
                text('SELECT * FROM product_details WHERE ean = :ean'), {'ean': ean}).fetchone()
            if not deliver_product or not product:
                print("No data in database!")
                return False
            is_exist_query = text(
                'SELECT 1 FROM products WHERE ean = :ean AND location = :location AND date = :date LIMIT 1')
            is_exist = self.db.execute(is_exist_query, {
                                        'ean': ean, 'location': target_location, 'date': deliver_product.date}).fetchone()
            if not is_exist:
                insert_query = text("""INSERT INTO products (code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount)
                                    VALUES (:code, :product_name, :ean, :amount, :jednostka, :unit_weight, :location, :date, :reserved_amount, :available_amount)""")
                self.db.execute(insert_query, {'code': product.code, 'product_name': product.product_name, 'ean': ean,
                                                'amount': deliver_product.amount, 'jednostka': 'szt', 'unit_weight': product.unit_weight,
                                                'location': target_location, 'date': deliver_product.date, 'reserved_amount': 0,
                                                'available_amount': deliver_product.amount})
            else:
                update_query = text("""UPDATE products SET amount = amount + :new_amount, available_amount = available_amount + :new_amount
                                    WHERE ean = :ean AND location = :location AND date = :date""")
                self.db.execute(update_query, {'new_amount': deliver_product.amount,
                                'ean': ean, 'location': target_location, 'date': deliver_product.date})
            self.db.commit()
            return True
        except Exception as e:
            self.db.rollback()
            print(f'It is appear an error: {e}')
            return False