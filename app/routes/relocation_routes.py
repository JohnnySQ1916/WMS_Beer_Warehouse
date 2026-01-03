from app.warehouse_operations.product_operations import ProductService
from app.warehouse_operations.relocate_operation import  RelocationService
from app.warehouse_operations.location_operations import LocationService
from marshmallow import Schema, fields
from app.common_schema import EanSchema, LocationSchema, DateSchema, AmountSchema, ChooseProductSchema
from sqlalchemy import text
from app.database.database import get_db
from app.utils import verify_token, get_current_user
from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session


router = APIRouter(prefix = '/relocation', tags = ['Relocation'])

@router.get('/start/{ean}')
def get_products_by_ean(ean: str, current_user= Depends(get_current_user), db: Session = Depends(get_db)):
    service = ProductService(db)
    relocation_service = RelocationService(db)
    product = service.find_product_by_ean(ean)
    if not product:
        raise HTTPException(status_code = 404, detail= 'Product not found')
    relocation_id = relocation_service.new_record_relocation(ean)
    print(relocation_id)
    return {'product': product,
            'relocation_id': relocation_id,
            'message': 'Enter location'}


@router.post('/enter_location/{relocation_id}')
def enter_location(relocation_id: int, body: LocationSchema, current_user= Depends(get_current_user), db: Session = Depends(get_db)):
    user_id = current_user['user_id']
    location = body.location
    location_service = LocationService(db)
    location_exist = location_service.check_is_location_in_base(location)
    if not location_exist:
        raise HTTPException(status_code = 404, detail='There is no such location in warehouse')
    product_service = ProductService(db)
    relocation_service = RelocationService(db)
    ean = product_service.fetch_scalar('ean', {'id': relocation_id}, 'relocation')
    if not ean:
        raise HTTPException(status_code = 404, detail = 'Product not found')
    dooble = product_service.fetch_all({'ean': ean, 'location': location}, 'products')
    if len(dooble) > 1:
        return {
            'message': 'Choose product to relocate',
            'data': [
                {
                    'id': row.id,
                    'product_name': row.product_name,
                    'date': row.date.strftime('%Y-%m-%d'),
                    'amount': row.amount
                }
                for row in dooble
            ]
        }
    elif len(dooble) == 1:
        date = dooble[0].date
        relocation_service.confirm_location(relocation_id, location, date, user_id)
        return {'message': 'Enter amount: '}
    else:
        raise HTTPException(status_code= 404, detail='No product on this location')


@router.post('/confirm_date/{relocation_id}')
def confirm_date_choice(relocation_id: int, body : ChooseProductSchema, current_user= Depends(get_current_user), db: Session = Depends(get_db)):
    product_service = ProductService(db)
    relocation_service = RelocationService(db)
    current = product_service.fetch_scalar('status', {'id': relocation_id}, 'relocation')
    if current not in ('location_confirmed', 'ean_confirmed'):
        raise HTTPException(status_code= 409, detail= 'Location or EAN not confirmed')
    product_id = body.product_id
    relocation_service.update_date(product_id, relocation_id) 
    return {'message': 'Enter amount'}


@router.post('/confirm_amount/{relocation_id}')
def enter_amount(relocation_id: int, body: AmountSchema, current_user= Depends(get_current_user), db: Session = Depends(get_db)):
    product_service = ProductService(db)
    relocate_service = RelocationService(db)
    current = product_service.fetch_scalar('status', {'id': relocation_id}, 'relocation')
    if current != 'date_confirmed':
        raise HTTPException(status_code = 409, detail= 'Date not confirmed')
    ean = product_service.fetch_scalar('ean', {'id': relocation_id}, 'relocation')
    location = product_service.fetch_scalar('initial_location', {'id': relocation_id}, 'relocation')
    date = product_service.fetch_scalar('date', {'id': relocation_id}, 'relocation')
    amount = body.amount
    amount_on_location = product_service.fetch_scalar('amount', {'ean': ean, 'location': location, 'date': date}, 'products')
    if amount > amount_on_location:
        return ({'message': f'Too high number to relocate. On location it is only {amount_on_location}.'})
    else:
        relocate_service.confirm_amount(relocation_id, amount)
        return ({'message': 'Enter target location'})


@router.post('/confirm_target_location/{relocation_id}')
def enter_target_location(relocation_id: int, body: LocationSchema, current_user= Depends(get_current_user), db: Session = Depends(get_db)):
    relocation_service = RelocationService(db)
    product_service = ProductService(db)
    current = product_service.fetch_scalar('status', {'id': relocation_id}, 'relocation')
    if current != 'amount_confirmed':
        raise HTTPException(status_code= 409, detail= 'Amount not confirmed')
    target_location = body.location
    location_service = LocationService(db)
    location_exist = location_service.check_is_location_in_base(target_location)
    if not location_exist:
        raise HTTPException(status_code = 404, detail='There is no such location in warehouse')
    row = product_service.fetch_one({'id': relocation_id}, 'relocation')
    if row is None:
        raise HTTPException(status_code= 404, detail= f'Relocation with id {relocation_id} not found')
    ean = row.ean
    location = row.initial_location
    date = row.date
    amount = row.amount
    try:
        relocation_service.confirm_target_location(relocation_id, target_location)
        result = relocation_service.relocate_in_products(ean, location, date, amount, target_location)
        return {
            'message': 'Relocate confirmed'
        }
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code = 500,  detail= str(e))


@router.get('/relocate_by_location/{location:path}')
def get_products_by_location(location: str, current_user= Depends(get_current_user), db : Session = Depends(get_db)):
    location_service = LocationService(db)
    relocation_service = RelocationService(db)
    product = location_service.find_product_by_location(location)
    if not product:
        raise HTTPException(status_code=404, detail='No product found')
    try:
        user_id = current_user['user_id']
        relocation_id = relocation_service.new_record_relocation_by_location(location, user_id)
        if product:
            return {
                'product': product,
                'id': relocation_id,
                'message': 'Enter ean'}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code = 500,  detail= str(e))
    

@router.post('/enter_ean/{id}')
def enter_ean(id: int, body : EanSchema, current_user= Depends(get_current_user), db: Session = Depends(get_db)):
    relocation_service = RelocationService(db)
    ean = body.ean
    location_query = text('SELECT initial_location FROM relocation WHERE id = :id')
    location = db.execute(location_query, {'id': id}).scalar()
    product_name_query = text('SELECT product_name FROM products WHERE ean = :ean')
    product_name = db.execute(product_name_query, {'ean' : ean}).scalar()
    dooble_query = text(
        'SELECT id, product_name, date, amount FROM products WHERE ean= :ean AND location = :location')
    dooble = db.execute(
        dooble_query, {'ean': ean, 'location': location}).fetchall()
    if len(dooble) > 1:
        return{
            'message': 'Choose product to relocate',
            'data': [
                {
                    'id': row.id,
                    'product_name': row.product_name,
                    'date': row.date.strftime('%Y-%m-%d'),
                    'amount': row.amount
                }
                for row in dooble
            ]
        }
    elif len(dooble) == 1:
        date = dooble[0].date
        relocation_service.confirm_ean(id, product_name, ean, date)
        return {
            'message': 'Enter amount: '
        }
    else:
        raise HTTPException(status_code = 400, detail= f'No product found with EAN {ean} on location {location}.')
