from fastapi import APIRouter, HTTPException, Depends
from app.utils import get_current_user
from sqlalchemy.orm import Session
from app.database.database import get_db
from app.warehouse_operations.product_operations import ProductService
from app.common_schema import ProductSchema, AddCustomer, AddSupplier
from app.warehouse_operations.add_service import AddService

router = APIRouter(prefix= '/add_to_base', tags= ['Add_to_Base'])

@router.post('/add_product')
def add_product(body: ProductSchema, current_user= Depends(get_current_user), db: Session= Depends(get_db)):
    product_service = ProductService(db)
    add_service = AddService(db)
    exist = add_service.check_if_customer_exist(body.ean)
    if exist:
        raise HTTPException(status_code= 400, detail= 'Product already exist')
    result = product_service.add_product_to_product_details(body.product_name, body.code, body.ean, body.unit_weight, body.purchase_price)
    if not result: 
        raise HTTPException(status_code= 400, detail= 'Product not added to database')
    return {'message': 'Product added to base'}
    
@router.post('/add_customer')
def add_customer(body: AddCustomer, current_user= Depends(get_current_user), db: Session= Depends(get_db)):
    add_service = AddService(db)
    exist = add_service.check_if_customer_exist(body.company_name)
    if exist:
        raise HTTPException(status_code= 400, detail= 'Customer already exist')
    result = add_service.insert_new_customer(body)
    if not result:
        raise HTTPException(status_code= 400, detail= 'Customer not added to database')
    return {
        'message': 'Customer added to database'
    }

@router.post('/add_supplier')
def add_supplier(body: AddSupplier, current_user= Depends(get_current_user), db: Session= Depends(get_db)):
    add_service = AddService(db)
    exist = add_service.check_if_customer_exist(body.company_name)
    if exist:
        raise HTTPException(status_code= 400, detail= 'Supplier already exist')
    result = add_service.insert_new_supplier(body)
    if not result:
        raise HTTPException(status_code= 400, detail= 'Supplier not added to database')
    return {
        'message': 'Supplier added to database'
    }
