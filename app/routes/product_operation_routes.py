from app.warehouse_operations.product_operations import  ProductService
from app.utils import get_current_user
from fastapi import APIRouter, Depends, HTTPException
from app.database.database import get_db
from sqlalchemy.orm import Session


router = APIRouter(prefix= '/products', tags = ['Products'])


@router.get('/{ean}')
def get_product_by_ean(ean: str, db: Session = Depends(get_db), current_user= Depends(get_current_user)):
    service = ProductService(db)
    product = service.find_product_by_ean(ean)
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    return product
