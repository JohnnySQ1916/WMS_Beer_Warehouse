import logging
from contextlib import contextmanager
from datetime import date, datetime, timezone
from typing import List

from sqlalchemy.engine import Row
from sqlalchemy.orm import Session
from sqlalchemy.sql import text

from app.constant.status import DeliverStatus
from app.models import DeliveryDetail

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


class DeliveryService:
    def __init__(self, db: Session):
        self.db = db

    def DeliverIDGenerate(self):
        data = datetime.now()
        year = data.year
        month = data.month
        pattern = f"PZ-%-{month:02}-{year}"
        query = text("""
        SELECT MAX(deliver_id)
        FROM delivery_order
        WHERE deliver_id LIKE :pattern
        """)
        last_id = self.db.execute(query, {"pattern": pattern}).scalar()
        if last_id:
            last_number = int(last_id.split("-")[1])
            next_number = last_number + 1
        else:
            next_number = 1
        deliver_number = f"PZ-{next_number:03}-{month:02}-{year}"
        return deliver_number


    def check_deliver_to_do(self):
        result = self.db.execute(
            text("SELECT * FROM delivery_order WHERE status = :undone OR status = :pending"),
            {
                "undone": DeliverStatus.UNDONE.value,
                "pending": DeliverStatus.PENDING.value,
            },
        ).fetchall()
        return result

    def supplier_exist(self, supplier: str) -> bool:
        result = self.db.execute(
            text("SELECT company_name FROM suppliers WHERE company_name = :name"),
            {"name": supplier},
        ).scalar()
        return bool(result)

    def create_supplier_deliver(
        self, supplier: str, deliver_external_number: str, delivery_date: date
    ) -> str:
        with transaction(self.db):
            deliver_id = self.DeliverIDGenerate()
            delivery_order_query = text("""INSERT INTO delivery_order (deliver_id, supplier, delivery_date, deliver_external_number, create_date, status)
                                        VALUES(:deliver_id, :supplier, :delivery_date, :deliver_external_number, :create_date, :status)""")
            self.db.execute(
                delivery_order_query,
                {
                    "deliver_id": deliver_id,
                    "supplier": supplier,
                    "delivery_date": delivery_date,
                    "deliver_external_number": deliver_external_number,
                    "create_date": date.today(),
                    "status": DeliverStatus.UNDONE.value,
                },
            )
            logger.info(deliver_id)
            return deliver_id

    def create_deliver_details(
        self, deliver_id: str, product_name: str, ean: str, expected_amount: int
    ) -> str:
        with transaction(self.db):
            new_item = DeliveryDetail(
                deliver_id=deliver_id,
                product_name=product_name,
                ean=ean,
                expected_amount=expected_amount,
            )
            self.db.add(new_item)
            return deliver_id

    def check_undone_deliver(self, deliver_id: str) -> List[Row]:
        delivery_query = text(
            "SELECT product_name, expected_amount, ean FROM deliver_details WHERE deliver_id = :deliver_id AND status NOT IN (:done, :pending)"
        )
        delivery = self.db.execute(
            delivery_query,
            {
                "deliver_id": deliver_id,
                "done": DeliverStatus.DONE.value,
                "pending": DeliverStatus.PENDING.value,
            },
        ).fetchall()
        return delivery

    def check_status(self, ean: str, deliver_id: str) -> str:
        result = self.db.execute(
            text(
                "SELECT status FROM deliver_details WHERE ean = :ean AND deliver_id = :deliver_id AND target_location IS NULL"
            ),
            {"ean": ean, "deliver_id": deliver_id},
        ).scalar()
        if not result:
            return None
        return result

    def update_date(self, deliver_id: str, expiration_date: date, ean: str) -> None:
        with transaction(self.db):
            update_query = text(
                "UPDATE deliver_details SET date = :date, status = :status WHERE deliver_id = :deliver_id AND ean = :ean AND target_location IS NULL"
            )
            self.db.execute(
                update_query,
                {
                    "date": expiration_date,
                    "status": DeliverStatus.DATE.value,
                    "deliver_id": deliver_id,
                    "ean": ean,
                },
            )

    def update_amount_when_not_expected_amount(
        self, deliver_id: str, amount: int, ean: str
    ) -> None:
        with transaction(self.db):
            self.db.execute(
                text(
                    "UPDATE deliver_details SET amount = :amount, status = :status WHERE deliver_id = :deliver_id AND ean = :ean AND target_location IS NULL"
                ),
                {
                    "amount": amount,
                    "status": DeliverStatus.AMOUNT.value,
                    "deliver_id": deliver_id,
                    "ean": ean,
                },
            )

    def update_amount_with_expected_amount(self, deliver_id: str, amount: int, ean: str) -> None:
        with transaction(self.db):
            self.db.execute(
                text(
                    "UPDATE deliver_details SET amount = :amount, status = :status WHERE deliver_id = :deliver_id AND ean = :ean"
                ),
                {
                    "amount": amount,
                    "status": DeliverStatus.AMOUNT.value,
                    "deliver_id": deliver_id,
                    "ean": ean,
                },
            )

    def update_target_location(
        self, target_location: str, user_id: str, ean: str, deliver_id: str, status: str
    ) -> None:
        with transaction(self.db):
            update_deliver_query = text("""UPDATE deliver_details SET user_id = :user_id, target_location = :target_location, deliver_time = :deliver_time, status = :status,
                                    deliver_date = :deliver_date WHERE ean = :ean AND deliver_id = :deliver_id AND target_location IS NULL""")
            self.db.execute(
                update_deliver_query,
                {
                    "user_id": user_id,
                    "target_location": target_location,
                    "ean": ean,
                    "deliver_id": deliver_id,
                    "deliver_time": datetime.now(timezone.utc),
                    "status": status,
                    "deliver_date": date.today(),
                },
            )

    def change_ean_status(self, ean: str, deliver_id: str) -> None:
        with transaction(self.db):
            update_query = text(
                "UPDATE deliver_details SET status = :status WHERE deliver_id = :deliver_id AND ean = :ean AND target_location IS NULL"
            )
            self.db.execute(
                update_query,
                {
                    "status": DeliverStatus.EAN.value,
                    "deliver_id": deliver_id,
                    "ean": ean,
                },
            )

    def insert_new_row_into_table(self, deliver_id: str, ean: str, user_id: str, total_amount: int):
        with transaction(self.db):
            product_query = text(
                "SELECT * FROM deliver_details WHERE deliver_id = :deliver_id AND ean = :ean ORDER BY id DESC LIMIT 1"
            )
            product = self.db.execute(
                product_query, {"deliver_id": deliver_id, "ean": ean}
            ).fetchone()
            insert_query = text("""INSERT INTO deliver_details (deliver_id, user_id, product_name, ean, expected_amount, status)
                                VALUES (:deliver_id, :user_id, :product_name, :ean, :expected_amount, :status)""")
            self.db.execute(
                insert_query,
                {
                    "deliver_id": deliver_id,
                    "user_id": user_id,
                    "product_name": product.product_name,
                    "ean": ean,
                    "expected_amount": product.expected_amount - total_amount,
                    "status": DeliverStatus.UNDONE.value,
                },
            )

    def check_if_done(self, deliver_id: str) -> Row:
        if_done = self.db.execute(
            text(
                "SELECT * FROM deliver_details WHERE deliver_id = :deliver_id AND status = 'undone' LIMIT 1"
            ),
            {"deliver_id": deliver_id},
        ).fetchone()
        return if_done

    def update_deliver_order(self, deliver_id: str) -> None:
        with transaction(self.db):
            self.db.execute(
                text("UPDATE delivery_order SET status = 'done' WHERE deliver_id = :deliver_id"),
                {"deliver_id": deliver_id},
            )

    def update_products(self, target_location: str, ean: str, deliver_id: str) -> bool:
        with transaction(self.db):
            deliver_product = self.db.execute(
                text("""SELECT * FROM deliver_details WHERE deliver_id = :deliver_id AND ean = :ean  
                                                    AND status IN (:pending, :done) ORDER BY id DESC LIMIT 1"""),
                {
                    "deliver_id": deliver_id,
                    "ean": ean,
                    "pending": DeliverStatus.PENDING.value,
                    "done": DeliverStatus.DONE.value,
                },
            ).fetchone()
            product = self.db.execute(
                text("SELECT * FROM product_details WHERE ean = :ean"), {"ean": ean}
            ).fetchone()
            if not deliver_product or not product:
                logger.warning("No data in database!")
                return False
            is_exist_query = text(
                "SELECT 1 FROM products WHERE ean = :ean AND location = :location AND date = :date LIMIT 1"
            )
            is_exist = self.db.execute(
                is_exist_query,
                {"ean": ean, "location": target_location, "date": deliver_product.date},
            ).fetchone()
            if not is_exist:
                insert_query = text("""INSERT INTO products (code, product_name, ean, amount, jednostka, unit_weight, location, date, reserved_amount, available_amount)
                                    VALUES (:code, :product_name, :ean, :amount, :jednostka, :unit_weight, :location, :date, :reserved_amount, :available_amount)""")
                self.db.execute(
                    insert_query,
                    {
                        "code": product.code,
                        "product_name": product.product_name,
                        "ean": ean,
                        "amount": deliver_product.amount,
                        "jednostka": "szt",
                        "unit_weight": product.unit_weight,
                        "location": target_location,
                        "date": deliver_product.date,
                        "reserved_amount": 0,
                        "available_amount": deliver_product.amount,
                    },
                )
            else:
                update_query = text("""UPDATE products SET amount = amount + :new_amount, available_amount = available_amount + :new_amount
                                    WHERE ean = :ean AND location = :location AND date = :date""")
                self.db.execute(
                    update_query,
                    {
                        "new_amount": deliver_product.amount,
                        "ean": ean,
                        "location": target_location,
                        "date": deliver_product.date,
                    },
                )
            return True
