import logging
from contextlib import contextmanager
from datetime import date, datetime, timezone

from sqlalchemy import text
from sqlalchemy.orm import Session

from app.constant.status import PickingStatus
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


class RelocationService:
    def __init__(self, db: Session):
        self.db = db

    def new_record_relocation(self, ean: str) -> int:
        with transaction(self.db):
            query = text("""INSERT INTO relocation (product_name, ean, status)
                        SELECT p.product_name, p.ean, :status
                        FROM products p
                        WHERE ean = :ean
                        RETURNING id""")
            new_record = self.db.execute(
                query, {"ean": ean, "status": PickingStatus.EAN.value}
            ).scalar()
            return new_record

    def confirm_location(self, relocation_id: int, location: str, date: date, user_id: str) -> None:
        with transaction(self.db):
            query = text(
                "UPDATE relocation SET initial_location= :location, date = :date, status = :status, user_id = :user_id WHERE id = :id"
            )
            self.db.execute(
                query,
                {
                    "location": location,
                    "date": date,
                    "status": PickingStatus.DATE.value,
                    "user_id": user_id,
                    "id": relocation_id,
                },
            )

    def update_date(self, product_id: int, relocation_id: int) -> None:
        with transaction(self.db):
            query = text(
                "UPDATE relocation SET date = (SELECT date FROM products WHERE id = :product_id), status = :status WHERE id = :id"
            )
            self.db.execute(
                query,
                {
                    "product_id": product_id,
                    "status": PickingStatus.DATE.value,
                    "id": relocation_id,
                },
            )

    def confirm_amount(self, relocation_id: int, amount: int) -> None:
        with transaction(self.db):
            amount_query = text(
                "UPDATE relocation SET amount = :amount, status = :status WHERE id = :id"
            )
            self.db.execute(
                amount_query,
                {
                    "amount": amount,
                    "status": PickingStatus.AMOUNT.value,
                    "id": relocation_id,
                },
            )

    def confirm_target_location(self, relocation_id: str, target_location: str) -> None:
        with transaction(self.db):
            query = text(
                "UPDATE relocation SET  target_location = :target_location, time = :time, status = :status WHERE id = :id"
            )
            self.db.execute(
                query,
                {
                    "target_location": target_location,
                    "time": datetime.now(timezone.utc).replace(microsecond=0),
                    "status": PickingStatus.DONE.value,
                    "id": relocation_id,
                },
            )

    def relocate_in_products(
        self, ean: str, location: str, date: date, amount: int, target_location: str
    ) -> None:
        with transaction(self.db):
            product_service = ProductService(self.db)
            amount_on_location = product_service.get_current_amount(ean, location, date)
            if amount == amount_on_location:
                product_service.update_location(location, ean, target_location)
            elif amount < amount_on_location:
                product_service.update_amount(ean, location, amount, "reduce")
                exist = product_service.product_exist_on_location(
                    target_location, ean, location, date
                )
                if exist:
                    product_service.update_amount(ean, target_location, amount, "sum")
                else:
                    product_service.insert_new_product(amount, target_location, ean, location, date)
            else:
                raise ValueError(f"Amount {amount} exceeds amount on location {amount_on_location}")

    def new_record_relocation_by_location(self, location: str, user_id: str) -> int:
        with transaction(self.db):
            query = text("""INSERT INTO relocation (initial_location, user_id, status)
                        VALUES (:location, :user_id, :status)
                        RETURNING id""")
            new_id = self.db.execute(
                query,
                {
                    "location": location,
                    "user_id": user_id,
                    "status": PickingStatus.LOCATION.value,
                },
            ).scalar()
            return new_id

    def confirm_ean(self, id: int, product_name: str, ean: str, date: date) -> None:
        with transaction(self.db):
            query = text(
                "UPDATE relocation SET product_name = :product_name , ean= :ean, date = :date, status = :status WHERE id = :id"
            )
            self.db.execute(
                query,
                {
                    "product_name": product_name,
                    "ean": ean,
                    "date": date,
                    "status": PickingStatus.DATE.value,
                    "id": id,
                },
            )
