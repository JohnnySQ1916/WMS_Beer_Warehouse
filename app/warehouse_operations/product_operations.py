from app.database.database import db
from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError
from app.warehouse_operations.product_services import get_current_amount, update_location, update_amount, insert_new_product, product_exist_on_location


def find_product_by_ean(ean):
    query = text(
        f"SELECT code, product_name, amount, date, jednostka, location FROM products WHERE ean = :ean")
    result = db.session.execute(query, {'ean': ean}).fetchall()
    products = [dict(row._mapping) for row in result]
    if result:
        return products 
    return None
    


def changing_product_location_by_ean(ean):
    try:
        find_product_by_ean(ean)
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
        db.session.rollback()
        print("An error occurred:", e)
