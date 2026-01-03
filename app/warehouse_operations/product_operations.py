from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError
from app.warehouse_operations.product_services import get_current_amount, update_location, update_amount, insert_new_product, product_exist_on_location
from sqlalchemy.orm import Session
from fastapi import HTTPException, Depends, status
from app.database.database import get_db
from sqlalchemy.exc import IntegrityError, SQLAlchemyError


class ProductService:

    def __init__(self, db: Session):
        self.db = db
        result = self.db.execute(text("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'")).fetchall()
        self.white_list = {row[0] for row in result}

    def add_product_to_product_details(self, product_name, code, ean, unit_weight, purchase_price):
        try:
            result = self.db.execute(text("""INSERT INTO product_details (product_name, code, ean, unit_weight, purchase_price)
                            VALUES (:product_name, :code, :ean, :unit_weight, :purchase_price)"""), {'product_name': product_name, 'code': code, 
                                                                    'ean': ean, 'unit_weight': unit_weight, 'purchase_price': purchase_price})
            self.db.commit()
            return True
        except IntegrityError:
            self.db.rollback()
            raise HTTPException (status_code= status.HTTP_400_BAD_REQUEST, detail=f"Product with EAN {ean} already exists.")
        except SQLAlchemyError as e:
            self.db.rollback()
            raise HTTPException(status_code= status.HTTP_500_INTERNAL_SERVER_ERROR, detail= f'Database error: {e}')
        

    def find_product_by_ean(self, ean: str):
        query = text(
            f"SELECT code, product_name, amount, date, jednostka, location FROM products WHERE ean = :ean")
        result = self.db.execute(query, {'ean': ean}).fetchall()
        if not result:
            raise HTTPException(status_code= 404, detail= 'Product not found')
        products = [dict(row._mapping) for row in result]
        return products 
    
    def dict_to_where(self, params: dict, operator):
        conditions = []
        for key in params:
            conditions.append(f'{key} = :{key}')
        where_clause = f' {operator} '.join(conditions)
        return where_clause
    
    def fetch_scalar(self, arg: str, param: dict, table: str, operator = 'AND'):
        where = self.dict_to_where(param, operator)
        if table not in self.white_list:
            raise HTTPException(status_code=404, detail= 'Invalid table')
        query = self.db.execute(text(f'SELECT {arg} FROM {table} WHERE {where}'), param).scalar()
        return query
    
    def fetch_one(self, param:dict, table:str, operator = 'AND', arg = '*'):
        where = self.dict_to_where(param, operator)
        if table not in self.white_list:
            raise HTTPException(status_code=404, detail= 'Invalid table')
        query = self.db.execute(text(f'SELECT {arg} FROM {table} WHERE {where}'), param).fetchone()
        return query
    
    def fetch_all(self, param: dict, table:str, operator = 'AND', arg = None):
        if operator not in ('AND', 'OR'):
            raise ValueError('Invalid operator')
        where = self.dict_to_where(param, operator)
        if table not in self.white_list:
            raise HTTPException(status_code=404, detail= 'Invalid table')
        if arg:
            query = self.db.execute(text(f'SELECT {arg} FROM {table} WHERE {where}'), param).fetchall()
        else:
            query = self.db.execute(text(f'SELECT * FROM {table} WHERE {where}'), param).fetchall()
        return query
    
    def get_current_amount(self, ean: str, location: str, date = None):
        if date:
            query = text('SELECT amount FROM products WHERE location = :location AND ean= :ean AND date= :date')
            result = self.db.execute(query, {'location': location, 'ean': ean, 'date': date}).scalar()
        elif not date:
            query = text('SELECT amount FROM products WHERE location = :location AND ean= :ean')
            result = self.db.execute(query, {'location': location, 'ean': ean}).scalar()
        return result
    
    def update_location(self, old_location, ean, new_location):
        query = text('UPDATE products SET location = :new_location WHERE ean = :ean AND location = :old_location')
        self.db.execute(query, {'new_location': new_location, 'ean': ean, 'old_location': old_location})
        self.db.commit()
        print("Product location updated successfully.")

    def update_amount(self, ean, location, amount, operation):
        current = self.get_current_amount(ean, location)
        if operation not in ('sum', 'reduce'):
            raise HTTPException(status_code= 400, detail= 'Invalid operation')
        if current is None:
            raise HTTPException(status_code= 404, detail= 'Product not found')
        if operation == 'sum':
            new_amount = current + amount
        elif operation == 'reduce':
            if amount> current:
                raise HTTPException(status_code= 404, detail= f'Only {current} amount of product are available')
            new_amount = current - amount
        query = text('UPDATE products SET amount = :new_amount WHERE ean = :ean AND location = :location')
        self.db.execute(query, {'new_amount': new_amount, 'ean': ean, 'location': location})
        self.db.commit()

    

    def product_exist_on_location(self, new_location, ean, location_choice, date):
        check_query = text("""SELECT 1 FROM products WHERE location = :new_location AND ean = :ean AND date = :date""")
        exist = self.db.execute(check_query, {
                            'new_location': new_location, 'ean': ean, 'date': date}).fetchone()
        return bool(exist)
    
    def insert_new_product(self, amount, new_location, ean, location_choice, date):
        query = text("""
            INSERT INTO products (code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount) 
            SELECT code, product_name, ean, :amount, jednostka, unit_weight, :new_location, :date, :reserved_amount, :amount
            FROM products
            WHERE ean = :ean AND location = :location_choice AND date = :date
            ORDER BY date DESC
            LIMIT 1
        """)
        result = self.db.execute(query, {
                                    'amount': amount, 'new_location': new_location, 'ean': ean, 'location_choice': location_choice, 'date': date, 'reserved_amount': 0})
        print(result)
        self.db.commit()


def changing_product_location_by_ean(self, ean):
    try:
        product_service = ProductService(self.db)
        product_service.find_product_by_ean(ean)
        location_choice = input('Choose location to change: ')
        amount_to_change = int(input('Enter number to relocate: '))
        new_location = input('Enter new location: ')
        row = get_current_amount(ean, location_choice)

        if row is None:
            return print("No product found at the specified location.")
        amount_on_location = row

        if amount_to_change == amount_on_location:
            update_location(location_choice, ean, new_location)

        elif amount_to_change < amount_on_location:
            update_amount(ean, location_choice, amount_to_change, 'reduce')
            print(
                f'Amount has been reduced to {amount_on_location - amount_to_change}')
            exist = product_exist_on_location(
                new_location, ean, location_choice)

            if exist:
                print(
                    "Produkt istnieje na nowej lokalizacji w tej samej dacie, aktualizuję ilość.")
                update_amount(ean, new_location, amount_to_change, 'sum')
            else:
                insert_new_product(
                    amount_to_change, new_location, ean, location_choice)
                print("Product partially relocated successfully.")
        else:
            print("Amount to relocate exceeds available stock at the specified location.")

    except SQLAlchemyError as e:
        self.db.rollback()
        print("An error occurred:", e)
