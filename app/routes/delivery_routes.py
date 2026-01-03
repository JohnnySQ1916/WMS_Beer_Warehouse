from app.database.database import get_db
from sqlalchemy import text
from app.common_schema import DeliverCreateSupplier, DeliverCreateDetails, EanSchema, AmountSchema, LocationSchema, DateSchema, DeliverProductsListSchema
from app.warehouse_operations.deliver_services import  DeliveryService
from datetime import datetime, date
from fastapi import FastAPI, HTTPException, Depends, APIRouter
from sqlalchemy.orm import Session
from app.warehouse_operations.product_operations import ProductService
from app.warehouse_operations.location_operations import LocationService
from app.utils import get_current_user

router = APIRouter(prefix= '/delivery', tags = ['Delivery'])


@router.post('/create_supplier_delivery')
def create_supplier_delivery_document(body : DeliverCreateSupplier ,current_user= Depends(get_current_user), db: Session = Depends(get_db)):
    deliver_service = DeliveryService(db)
    supplier = body.supplier
    deliver_external_number = body.deliver_external_number
    delivery_date = body.delivery_date
    exist = deliver_service.supplier_exist(supplier)
    if not exist:
        raise HTTPException(status_code= 404, detail= 'There is no such supplier in database. Add supplier to database')
    create = deliver_service.create_supplier_deliver(supplier, deliver_external_number, delivery_date)
    return{
            'message': f'Delivery add to database with number {create}'
     }


@router.post('/create_delivery/{deliver_id}')
def create_delivery_details_document(deliver_id :str, body : DeliverProductsListSchema ,current_user= Depends(get_current_user), db: Session = Depends(get_db)):
    deliver_service = DeliveryService(db)
    products = body.products
    for product in products:
        product_name = product.product_name
        ean = product.ean
        expected_amount = product.expected_amount
        deliver_service.create_deliver_details(deliver_id, product_name, ean, expected_amount)
    return {
            'message': f'Products add to deliver_order number {deliver_id}'
        }



@router.get('/check_supplier_deliver')
def check_supplier_delivery(current_user= Depends(get_current_user), db: Session = Depends(get_db)):
    deliver_service = DeliveryService(db)
    delivery = deliver_service.check_deliver_to_do()
    if not delivery:
        raise HTTPException(status_code=404, detail= 'No products found for execute delivery')
    return {
        'Supplier': [
            {'Supplier': row.supplier}
        for row in delivery]
    }


@router.get('/check_delivery/{deliver_id}')
def check_delivery(deliver_id : str, current_user= Depends(get_current_user), db: Session = Depends(get_db)):
    deliver_service = DeliveryService(db)
    delivery = deliver_service.check_undone_deliver(deliver_id)
    if not delivery:
        raise HTTPException(status_code=404, detail= 'No products found for given delivery ID')
    return {
        'Products': [
            {'Product_name': row.product_name,
            'Expected_Amount': row.expected_amount,
            'EAN': row.ean}
        for row in delivery]}


@router.post('/enter_ean_delivery/{deliver_id}')
def enter_ean_delivery(deliver_id : str, body: EanSchema, current_user= Depends(get_current_user), db: Session = Depends(get_db)):
    ean = body.ean
    product_service = ProductService(db)
    deliver_service = DeliveryService(db)
    is_ean_on_list = product_service.fetch_one({'ean':ean, 'deliver_id': deliver_id}, 'deliver_details', arg= 'ean')
    if not is_ean_on_list:
        raise HTTPException(status_code= 404, detail= 'There is no such ean on deliver list')
    expected_amount = product_service.fetch_scalar('expected_amount', {'ean':ean, 'deliver_id': deliver_id}, 'deliver_details')
    if is_ean_on_list:
        ean_location = product_service.fetch_all({'ean': ean}, 'products')
        deliver_service.change_ean_status(ean, deliver_id)
        return {
            'Expected Amount': expected_amount,
            'Products': [{
                'Product name': row.product_name,
                'Amount': row.amount,
                'Location': row.location,
                'Date': row.date
            } for row in ean_location],
            'message' : 'Enter product date expired'
        }
        

@router.post('/enter_date/{deliver_id}/{ean}')
def enter_date(deliver_id :str, ean : str, body: DateSchema, current_user= Depends(get_current_user), db: Session = Depends(get_db)):
    product_service = ProductService(db)
    deliver_service = DeliveryService(db)
    is_ean_on_list = product_service.fetch_one({'ean':ean, 'deliver_id': deliver_id}, 'deliver_details', arg= 'ean')
    # is_ean_on_list = db.execute(text("SELECT ean FROM deliver_details WHERE ean = :ean AND deliver_id = :deliver_id"), {'ean':ean, 'deliver_id': deliver_id}).fetchone()
    if not is_ean_on_list:
        raise HTTPException(status_code= 404, detail= 'There is no such ean on deliver list')
    status = deliver_service.check_status(ean, deliver_id)
    if status != 'ean confirmed':
        raise HTTPException(status_code= 400, detail= 'Confirm ean')
    expiration_date =  body.date
    deliver_service.update_date(deliver_id, expiration_date, ean)
    return {
        'message': "Enter amount of that product. If there is bigger number than expected amount, add to args 'force': true "}


@router.post('/enter_amount_delivery/{deliver_id}/{ean}')
def enter_amount_delivery(deliver_id :str, ean : str, body: AmountSchema, current_user= Depends(get_current_user), db: Session = Depends(get_db)):
    product_service = ProductService(db)
    deliver_service = DeliveryService(db)
    is_ean_on_list = product_service.fetch_one({'ean':ean, 'deliver_id': deliver_id}, 'deliver_details', arg= 'ean')
    if not is_ean_on_list:
        raise HTTPException(404, 'There is no such ean on deliver list')
    status = deliver_service.check_status(ean, deliver_id)
    if status != 'date confirmed':
        raise HTTPException(400, 'Confirm date')
    amount = body.amount
    total_amount = product_service.fetch_scalar('SUM(amount)', {'ean':ean, 'deliver_id': deliver_id}, 'deliver_details') or 0
    force = body.force
    expected_amount = product_service.fetch_scalar('expected_amount', {'ean':ean, 'deliver_id': deliver_id}, 'deliver_details')
    if amount + total_amount > expected_amount:
        if not force:
            raise HTTPException(400, "Entered amount is bigger than expected amount. If you want to confirm that amount, add to args 'force': true")
        else:
            deliver_service.update_amount_when_not_expected_amount(deliver_id, amount, ean)
            return {'message': 'Enter target location'}
    elif amount < expected_amount:
        deliver_service.update_amount_when_not_expected_amount(deliver_id, amount, ean)
        return {
        'message': 'Enter target location'
        }
    deliver_service.update_amount_with_expected_amount(deliver_id, amount, ean)
    return {
        'message': 'Enter target location'
    }


@router.post('/enter_location_delivery/{deliver_id}/{ean}')
def enter_location_delivery(deliver_id :str, ean : str, body: LocationSchema, current_user= Depends(get_current_user), db: Session = Depends(get_db)):
    deliver_service = DeliveryService(db)
    product_service = ProductService(db)
    target_location = body.location
    location_service = LocationService(db)
    location_exist = location_service.check_is_location_in_base(target_location)
    if not location_exist:
        raise HTTPException(status_code = 404, detail='There is no such location in warehouse')
    user_id = current_user['user_id']
    status = deliver_service.check_status(ean, deliver_id)
    if status != 'amount confirmed':
        raise HTTPException(400, 'Confirm amount')
    expected_amount= product_service.fetch_scalar('expected_amount', {'ean':ean , 'deliver_id': deliver_id}, 'deliver_details')
    total_amount = product_service.fetch_scalar('SUM(amount)', {'ean':ean, 'deliver_id': deliver_id}, 'deliver_details') or 0
    if total_amount == expected_amount:
        status = 'done'
    else:
        status = 'pending'
    deliver_service.update_target_location(target_location, user_id, ean, deliver_id, status)
    if total_amount < expected_amount:
        deliver_service.insert_new_row_into_table(deliver_id, ean, user_id, total_amount)
    is_order_still_open = deliver_service.check_if_done(deliver_id)
    if not is_order_still_open:
        deliver_service.update_deliver_order(deliver_id)
    update = deliver_service.update_products(target_location, ean, deliver_id)
    if update == True:
        return {
            'message': 'Product accepted on location'
        }
    else:
        raise HTTPException(400, 'error appeared')
