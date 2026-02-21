from enum import Enum


class Pallet(str, Enum):
    EURO = 'euro'
    EPN = 'epn'
    INDUSTRIAL = 'industrial'
    PLASTIC = 'plastic'
    HALF = 'half-pallet'
