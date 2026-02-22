import logging

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.exc import IntegrityError, SQLAlchemyError
from sqlalchemy.orm import Session

from app.common_schema import AddCustomer, AddSupplier, ProductSchema
from app.database.database import get_db
from app.models import ApiResponse
from app.utils import get_current_user
from app.warehouse_operations.add_service import AddService
from app.warehouse_operations.product_operations import ProductService

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/add_to_base", tags=["Add_to_Base"])


@router.post("/add_product", response_model=ApiResponse)
def add_product(
    body: ProductSchema,
    current_user=Depends(get_current_user),
    db: Session = Depends(get_db),
):
    product_service = ProductService(db)
    add_service = AddService(db)
    exist = add_service.check_if_product_exist(body.ean)
    if exist:
        raise HTTPException(status_code=400, detail="Product already exist")
    try:
        product_service.add_product_to_product_details(
            body.product_name,
            body.code,
            body.ean,
            body.unit_weight,
            body.purchase_price,
        )
    except SQLAlchemyError:
        raise HTTPException(status_code=400, detail="Product not added to database")
    return ApiResponse(message="Product added to base")


@router.post("/add_customer", response_model=ApiResponse)
def add_customer(
    body: AddCustomer,
    current_user=Depends(get_current_user),
    db: Session = Depends(get_db),
):
    add_service = AddService(db)
    exist = add_service.check_if_customer_exist(body.company_name)
    if exist:
        raise HTTPException(status_code=409, detail="Customer already exist")
    try:
        add_service.insert_new_customer(body)
    except IntegrityError:
        raise HTTPException(status_code=400, detail="Customer not added to database")
    return ApiResponse(message="Customer added to database")


@router.post("/add_supplier", response_model=ApiResponse)
def add_supplier(
    body: AddSupplier,
    current_user=Depends(get_current_user),
    db: Session = Depends(get_db),
):
    add_service = AddService(db)
    exist = add_service.check_if_customer_exist(body.company_name)
    if exist:
        raise HTTPException(status_code=400, detail="Supplier already exist")
    result = add_service.insert_new_supplier(body)
    if not result:
        raise HTTPException(status_code=400, detail="Supplier not added to database")
    return ApiResponse(message="Supplier added to database")
