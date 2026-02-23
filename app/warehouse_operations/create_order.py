import datetime
import logging
import random
from contextlib import contextmanager
from datetime import date
from decimal import Decimal
from typing import Dict, List

from fastapi import HTTPException
from sqlalchemy import insert
from sqlalchemy.engine import Row
from sqlalchemy.orm import Session
from sqlalchemy.sql import text

from app.constant.status import OrderStatus
from app.models import OrdersDetails
from app.warehouse_operations.product_operations import ProductService

logger = logging.getLogger(__name__)


@contextmanager
def transaction(db: Session):
    try:
        yield db
        db.commit()
    except Exception as e:
        db.rollback()
        logger.exception(f"Bład w transakcji: {e}")
        raise


class CreateOrder:
    def __init__(self, db: Session):
        self.db = db

    def OrderNOGenerate(self) -> str:
        data = datetime.datetime.now()
        year = data.year
        month = data.month
        if self.db.get_bind().dialect.name == "postgresql":
            query = text("""SELECT COUNT (*) FROM orders WHERE EXTRACT(MONTH FROM create_date) = :month
                        AND EXTRACT(YEAR FROM create_date) = :year""")
            AmountOfOrder = self.db.execute(query, {"month": month, "year": year}).scalar()
        elif self.db.get_bind().dialect.name == "sqlite":
            query = text("""SELECT COUNT(*) FROM orders WHERE strftime('%m', create_date) = :month
                            AND strftime('%Y', create_date) = :year""")
            AmountOfOrder = self.db.execute(query, {"month": f'{month:02}', "year": (year)}).scalar()
        orderNO = AmountOfOrder + 1
        order_id = f"ZO-{orderNO:03}-{month:02}-{year}"
        checking_query = text("SELECT order_id FROM orders WHERE order_id = :order_id")
        checking = self.db.execute(checking_query, {"order_id": order_id}).fetchone()
        if checking:
            raise ValueError(
                f"Wygenerowany numer zamówienia {order_id} już istnieje w bazie danych."
            )
        return order_id

    def making_reservation(self, order_id: str) -> str:
        with transaction(self.db):
            query = text("SELECT * FROM orders_details WHERE order_id = :order_id")
            order = self.db.execute(query, {"order_number": order_id})
            for product in order:
                result_query = text(
                    """SELECT amount, reserved_amount, available_amount FROM reservation WHERE product_name = :product_name AND ean = :ean"""
                )
                result = self.db.execute(
                    result_query,
                    {"product_name": product.product_name, "ean": product.ean},
                ).fetchone()
                if not result:
                    logger.warning(f"There is no {product.product_name} in stock")
                    continue
                if product.amount > result.available_amount:
                    logger.warning(f"Too less product {product.product_name} in stock")
                    continue
                reservation_query = text("""UPDATE reservation SET reserved_amount = reserved_amount + :reserved_amount, available_amount = amount - :product_amount 
                                        WHERE product_name = :product_name AND ean = :ean""")
                self.db.execute(
                    reservation_query,
                    {
                        "reserved_amount": product.amount,
                        "product_amount": product.amount,
                        "product_name": product.product_name,
                        "ean": product.ean,
                    },
                )
            return f"Rezerwacja dla zamówienia {order_id} wykonana"

    def insert_into_orders(self, order_id: str) -> bool:
        with transaction(self.db):
            insert_query = text(
                "INSERT INTO orders (order_id, create_date, status) VALUES (:order_id, :create_date, :status)"
            )
            self.db.execute(
                insert_query,
                {
                    "order_id": order_id,
                    "create_date": datetime.date.today(),
                    "status": OrderStatus.UNCONFIRMED.value,
                },
            )
            return True

    def fetch_available_products(self) -> List[Row]:
        query = text("""SELECT pd.product_name, pd.code, pd.ean, pd.purchase_price, pd.unit_weight, p.amount 
                        FROM product_details AS pd JOIN products AS p  ON pd.ean = p.ean WHERE p.amount > 0""")
        products = self.db.execute(query).fetchall()
        return products

    # sub-function
    def select_random_products_and_amount(
        self, selected_products: List[Row], order_id: str
    ) -> List[Dict]:
        order_products = []
        for product in selected_products:
            max_amount = min(15, product.amount)
            if max_amount < 5:
                quantity = product.amount
            else:
                quantity = random.randint(5, max_amount)
            # Hurtownia nakłada 30% marży na wszystkie produkty
            price_netto = product.purchase_price * Decimal("1.3")
            price_brutto = price_netto * Decimal("1.23").quantize(Decimal("0.01"))
            order_products.append(
                {
                    "order_id": order_id,
                    "product_name": product.product_name,
                    "code": product.code,
                    "amount": quantity,
                    "ean": product.ean,
                    "price_netto": price_netto,
                    "price_brutto": price_brutto,
                    "product_weight": product.unit_weight,
                    "total_price": quantity * price_brutto,
                }
            )
        return order_products

    # sub-function
    def insert_products_into_orders_details(self, order_products: str) -> None:
        self.db.execute(insert(OrdersDetails), order_products)


    # sub-function
    def make_reservation_for_order(self, order_id: str) -> None:
        products = (
            self.db.execute(
                text("SELECT * FROM orders_details WHERE order_id = :order_id"),
                {"order_id": order_id},
            )
            .mappings()
            .all()
        )
        for i in products:
            reservation_query = text(
                """UPDATE reservation SET reserved_amount = reserved_amount + :amount, available_amount = available_amount - :amount WHERE ean = :i_ean"""
            )
            self.db.execute(reservation_query, {"amount": i["amount"], "i_ean": i["ean"]})

    # sub-function
    def update_status_orders(self, order_id: str) -> None:
        self.db.execute(
            text("UPDATE orders_details SET status = :status WHERE order_id = :order_id"),
            {"status": OrderStatus.UNCONFIRMED.value, "order_id": order_id},
        )

    # sub-function
    def update_orders_with_details(
        self,
        customer_id: str,
        amount: int,
        price: float,
        weight: float,
        order_id: str,
        shipping_date: date,
    ) -> None:
        insert_query2 = text("""UPDATE orders SET customer_id = :customer_id, amount = :amount, create_date = :create_date, 
                                status = :status, price= :price, total_weight= :total_weight, shipping_date = :shipping_date WHERE order_id = :order_id""")
        self.db.execute(
            insert_query2,
            {
                "customer_id": customer_id,
                "amount": amount,
                "create_date": datetime.date.today(),
                "status": OrderStatus.UNDONE.value,
                "price": price,
                "total_weight": weight,
                "order_id": order_id,
                "shipping_date": shipping_date,
            },
        )

    # Funkcja create_order tworzy losowe zamówienie na podstawie ilości różnych produktów zgłoszonych do zamówienia.
    # Klient, produkty oraz ich ilości są losowo przyporządkowane. Funkcja została stworzona, gdyż normalne tworzenia zamówienia,
    # tak jak to sie odbywa w zakładach pracy, zajmuje za dużo czasu :) Właściwa funkcja zostanie stworzona.
    def create_random_order(self, item_amount: int, shipping_date: date) -> str:
        product_service = ProductService(self.db)
        with transaction(self.db):
            order_id = self.OrderNOGenerate()
            self.insert_into_orders(order_id)
            if not order_id:
                raise HTTPException(status_code=404, detail="There is no order_id")
            products = self.fetch_available_products()
            selected_products = random.sample(products, item_amount)
            order_products = self.select_random_products_and_amount(selected_products, order_id)
            self.insert_products_into_orders_details(order_products)
            self.db.flush()
            self.make_reservation_for_order(order_id)
            self.db.flush()
            customer_query = self.db.execute(text("SELECT customer_id FROM customers")).fetchall()
            customer = random.choice(customer_query)
            customer_id = customer[0]
            amount = product_service.fetch_scalar(
                "SUM(amount)", {"order_id": order_id}, "orders_details"
            )
            price = product_service.fetch_scalar(
                "SUM(total_price)", {"order_id": order_id}, "orders_details"
            )
            weight = product_service.fetch_scalar(
                "SUM(product_weight * amount)", {"order_id": order_id}, "orders_details"
            )
            self.update_orders_with_details(
                customer_id, amount, price, weight, order_id, shipping_date
            )
            return order_id

    def insert_single_product_into_orders_details(
        self, ean: str, amount: int, order_id: str
    ) -> None:
        try:
            with transaction(self.db):
                product = self.db.execute(
                    text("SELECT * FROM product_details WHERE ean = :ean"), {"ean": ean}
                ).fetchone()
                self.db.execute(
                    text("""INSERT INTO orders_details (order_id, product_name, code, amount,ean, price_netto, price_brutto, product_weight, total_price, status)
                                    VALUES (:order_id, :product_name, :code, :amount, :ean, :price_netto, :price_brutto, :product_weight, :total_price, :status)"""),
                    {
                        "order_id": order_id,
                        "product_name": product.product_name,
                        "code": product.code,
                        "amount": amount,
                        "ean": ean,
                        "price_netto": product.purchase_price * Decimal(1.3),
                        "price_brutto": (product.purchase_price * Decimal(1.3))
                        * Decimal(1.23).quantize(Decimal("0.01")),
                        "product_weight": product.unit_weight,
                        "total_price": amount
                        * (product.purchase_price * Decimal(1.3))
                        * Decimal(1.23).quantize(Decimal("0.01")),
                        "status": OrderStatus.UNCONFIRMED.value,
                    },
                )
        except Exception as e:
            logger.exception(f"Errol while ading product to order {order_id}. Error:", e)
            raise

    def add_customer_to_order(self, company_name: str, order_id: str) -> None:
        with transaction(self.db):
            customer_id = self.db.execute(
                text("SELECT customer_id FROM customers WHERE company_name = :company_name"),
                {"company_name": company_name},
            ).scalar()
            if customer_id is None:
                raise ValueError("Customer not found")
            self.db.execute(
                text("UPDATE orders SET customer_id= :customer_id WHERE order_id = :order_id"),
                {"customer_id": customer_id, "order_id": order_id},
            )

    def check_if_ean_exist(self, ean: str) -> bool:
        result = self.db.execute(
            text("SELECT 1 FROM product_details WHERE ean= :ean"), {"ean": ean}
        ).scalar()
        if not result:
            raise HTTPException(status_code=404, detail="There is no such ean in database")
        return True

    def check_if_is_enough_amount(self, ean: str, amount: int) -> bool:
        available_amount = self.db.execute(
            text("SELECT SUM(available_amount) FROM products WHERE ean= :ean"),
            {"ean": ean},
        ).scalar()
        if available_amount < amount:
            raise HTTPException(status_code=404, detail="There is not enough amount on warehouse")
        return True

    def check_if_order_open(self, order_id: str) -> bool:
        product_service = ProductService(self.db)
        result = product_service.fetch_scalar("status", {"order_id": order_id}, "orders")
        if result != OrderStatus.UNCONFIRMED:
            raise HTTPException(status_code=404, detail="Order is closed")
        return True

    def finish_order(self, order_id: str) -> bool:
        with transaction(self.db):
            product_service = ProductService(self.db)
            self.make_reservation_for_order(order_id)
            self.update_status_orders(order_id)
            customer_id = product_service.fetch_scalar(
                "customer_id", {"order_id": order_id}, "orders"
            )
            shipping_date = product_service.fetch_scalar(
                "shipping_date", {"order_id": order_id}, "orders"
            )
            amount = product_service.fetch_scalar(
                "SUM(amount)", {"order_id": order_id}, "orders_details"
            )
            price = product_service.fetch_scalar(
                "SUM(total_price)", {"order_id": order_id}, "orders_details"
            )
            weight = product_service.fetch_scalar(
                "SUM(product_weight * amount)", {"order_id": order_id}, "orders_details"
            )
            self.update_orders_with_details(
                customer_id, amount, price, weight, order_id, shipping_date
            )
            return True

    def cancel_order(self, order_id: str) -> bool:
        with transaction(self.db):
            self.db.execute(
                text("DELETE FROM orders_details WHERE order_id =:order_id"),
                {"order_id": order_id},
            )
            self.db.execute(
                text("UPDATE orders SET status = :status WHERE order_id= :order_id"),
                {"status": "cancelled", "order_id": order_id},
            )
            return True
