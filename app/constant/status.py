from enum import Enum


class OrderStatus(str, Enum):
    UNCONFIRMED = "unconfirmed"
    UNDONE = "undone"
    DONE = "done"
    CANCELLED = "cancelled"
    PENDING = "pending"


class PickingStatus(str, Enum):
    UNDONE = "undone"
    EAN = "ean_confirmed"
    DATE = "date_confirmed"
    LOCATION = "location_confirmed"
    AMOUNT = "amount_confirmed"
    DONE = "done"
    PART = "part"
    CANCELLED = "cancelled"


class DeliverStatus(str, Enum):
    UNDONE = "undone"
    EAN = "ean_confirmed"
    DATE = "date_confirmed"
    LOCATION = "location_confirmed"
    AMOUNT = "amount_confirmed"
    DONE = "done"
    PENDING = "pending"
