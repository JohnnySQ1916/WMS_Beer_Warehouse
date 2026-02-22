from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.common_schema import AddCustomerToOrder, AddProductToOrder, CreateRandomOrder
from app.database.database import get_db
from app.models import ApiResponse
from app.utils import get_current_user
from app.warehouse_operations.create_order import CreateOrder

router = APIRouter(prefix="/create_order", tags=["Create_order"])


@router.post("/create_random_order", response_model=ApiResponse)
def create_random_order(
    body: CreateRandomOrder,
    current_user=Depends(get_current_user),
    db: Session = Depends(get_db),
):
    create = CreateOrder(db)
    amount = body.amount
    shipping_date = body.shipping_date
    order_id = create.create_random_order(amount, shipping_date)
    if not order_id:
        raise HTTPException(status_code=404, detail="Order not created")
    return ApiResponse(message="Order created", data={"Order_id": order_id})


@router.get("/generate_new_order_id", response_model=ApiResponse)
def generate_new_order_id(current_user=Depends(get_current_user), db: Session = Depends(get_db)):
    create_service = CreateOrder(db)
    order_id = create_service.OrderNOGenerate()
    return ApiResponse(data={"order_id": order_id})


@router.post("/make_order/{order_id}", response_model=ApiResponse)
def make_order(
    order_id: str, current_user=Depends(get_current_user), db: Session = Depends(get_db)
):
    create_service = CreateOrder(db)
    result = create_service.insert_into_orders(order_id)
    if not result:
        raise HTTPException(status_code=404, detail="Order not created")
    return ApiResponse(message=f"Order created {order_id}")


@router.post("/choose_customer_for_order/{order_id}", response_model=ApiResponse)
def choose_customer(
    order_id: str,
    body: AddCustomerToOrder,
    current_user=Depends(get_current_user),
    db: Session = Depends(get_db),
):
    create_service = CreateOrder(db)
    company_name = body.company_name
    try:
        create_service.add_customer_to_order(company_name, order_id)
    except ValueError:
        raise HTTPException(status_code=404, detail="Customer not added to order")
    return ApiResponse(message=f"Customer add to order {order_id}")


@router.post("/add_product/{order_id}", response_model=ApiResponse)
def add_product_to_order(
    order_id: str,
    body: AddProductToOrder,
    current_user=Depends(get_current_user),
    db: Session = Depends(get_db),
):
    create_service = CreateOrder(db)
    ean = body.ean
    amount = body.amount
    create_service.check_if_ean_exist(ean)
    create_service.check_if_is_enough_amount(ean, amount)
    create_service.check_if_order_open(order_id)
    try:
        create_service.insert_single_product_into_orders_details(ean, amount, order_id)
    except Exception:
        raise HTTPException(status_code=404, detail="Product not added to order")
    return ApiResponse(message=f"Product ean:{ean} added to order")


@router.get("/finish_order/{order_id}", response_model=ApiResponse)
def finish_order(
    order_id: str, current_user=Depends(get_current_user), db: Session = Depends(get_db)
):
    create_service = CreateOrder(db)
    result = create_service.finish_order(order_id)
    if not result:
        raise HTTPException(status_code=404, detail="Order not launched to execute")
    return ApiResponse(message="Order launched to execute")


@router.post("/cancel_order/{order_id}", response_model=ApiResponse)
def cancel_order(
    order_id: str, current_user=Depends(get_current_user), db: Session = Depends(get_db)
):
    create_service = CreateOrder(db)
    try:
        result = create_service.cancel_order(order_id)
    except Exception:
        raise HTTPException(status_code=500, detail="Database error")
    if not result:
        raise HTTPException(status_code=400, detail="Order cannot be cancelled")
    return ApiResponse(message="Order cancelled")
