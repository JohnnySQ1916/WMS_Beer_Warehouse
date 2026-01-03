from app.database.database import get_db
from sqlalchemy import text
from app.utils import get_current_user
from app.warehouse_operations.product_operations import ProductService
from app.warehouse_operations.execute_order import ExecuteOrder
from app.common_schema import EanSchema, LocationSchema, DateSchema, AmountSchema, ChooseProductSchema
from fastapi import FastAPI, HTTPException, Depends, APIRouter
from sqlalchemy.orm import Session
from app.warehouse_operations.location_operations import LocationService

#WPROWADZIC DO WSZYSTKICH CONFIRM ROUTE SPRAWDZANIE STATUSU ORDERS_DETAILS DLA DANEGO EANU CZY POPRZEDNIA CZYNNOSC ZOSTALA ZREALIZOWANA. ŻEBY POTWIERDZANIE AMOUNT NIE MOGLO BYC PRZED POTWIERDZENIEM EANU ALBO LOKALIZACJI

router = APIRouter(prefix= '/execute_order', tags = ['Execute_order'])


@router.get('/order_choice')
def execute_order_choice(current_user= Depends(get_current_user), db: Session= Depends(get_db)):
    orders_query = text("""SELECT o.order_id, c.company_name, o.amount, o.total_weight 
                        FROM orders o
                        JOIN customers c ON o.customer_id = c.customer_id
                        WHERE o.status = 'undone'""")
    orders = db.execute(orders_query).fetchall()
    if not orders:
        raise HTTPException(status_code=404, detail= 'Orders not found')
    return {
        'Check order': 'If you want to check products on order, enter Check order and put order number to the link',
        'Order execute': 'If you want execute order, enter into  Start Order and put order number to the link',
        'orders': [{
            'order_id': row.order_id,
            'company name': row.company_name,
            'amount': row.amount,
            'total_weight': row.total_weight
        }
            for row in orders
        ]
    }
    

@router.get('/check_order/{order_id}')
def check_products_on_order(order_id: str, current_user= Depends(get_current_user), db: Session= Depends(get_db)):
    products_query = text(
        'SELECT product_name, amount FROM orders_details WHERE order_id = :order_id')
    products = db.execute(
        products_query, {'order_id': order_id}).fetchall()
    if not products:
        raise HTTPException(status_code=404, detail= 'Order not found')
    return {
        'Products': [{
            'Product name': row.product_name,
            'Amount': row.amount
        }
            for row in products]}


@router.get('/start_order/{order_id}')
def start_order(order_id: str, current_user= Depends(get_current_user), db: Session= Depends(get_db)):
    execute = ExecuteOrder(db)
    order = execute.Queue_To_Execute_Order(order_id)
    execute.reservation_of_location(order_id)
    if not order:
        raise HTTPException(status_code= 404, detail= 'No position to execute')
    first = order[0]
    amount_available_query = text(
        'SELECT amount FROM products WHERE ean = :ean AND location = :location AND date = :date')
    amount = db.execute(amount_available_query, {
                                          'ean': first.ean, 'location': first.location, 'date': first.date}).scalar()
    return {
        'product_name': first.product_name,
        'amount to collect/amount available': f'{first.amount}/{amount}',
        'Location': first.location,
        'message': f'Confirm location {first.location}'
    }


@router.post('/confirm_location/{order_id}')
def confirm_location(order_id: str, body: LocationSchema, current_user= Depends(get_current_user), db: Session= Depends(get_db)):
    execute = ExecuteOrder(db)
    location = body.location
    location_service = LocationService(db)
    location_exist = location_service.check_is_location_in_base(location)
    if not location_exist:
        raise HTTPException(status_code = 404, detail='There is no such location in warehouse')
    order = execute.Queue_To_Execute_Order(order_id)
    if not order:
        raise HTTPException(status_code = 404, detail= f'Brak elementów do zebrania dla zamówienia {order_id}')
    first = order[0]
    if location != first.location:
        raise HTTPException(status_code= 400, detail= 'Wrong location. Try again')
    return {
        'message': f'Enter ean: {first.ean}'
    }
    

@router.post('/confirm_ean/{order_id}')
def confirm_ean(order_id: str, body: EanSchema, current_user= Depends(get_current_user), db: Session= Depends(get_db)):
    execute = ExecuteOrder(db)
    ean = body.ean
    order = execute.Queue_To_Execute_Order(order_id)
    if not order:
        raise HTTPException(status_code= 404, detail= f'Brak elementów do zebrania dla zamówienia {order_id}')
    first = order[0]
    if ean != first.ean:
        raise HTTPException(status_code= 400, detail= f'Wrong ean. Expected: {first.ean}')
    return {
        'message': 'Enter amount: '
    }
    

@router.post('/confirm_amount/{order_id}')
def confirm_amount(order_id: str, body: AmountSchema, current_user= Depends(get_current_user), db: Session= Depends(get_db)):
    execute = ExecuteOrder(db)
    product_service = ProductService(db)
    amount = body.amount
    user_id = current_user['user_id']
    order = execute.Queue_To_Execute_Order(order_id)
    if not order:
        raise HTTPException(status_code= 404, detail= f'Brak elementów do zebrania dla zamówienia {order_id}')
    first = order[0]
    collected = product_service.fetch_scalar('collected_amount', {'ean': first.ean, 'order_id': order_id}, 'orders_details')
    # collected_query = text(
    #     'SELECT collected_amount FROM orders_details WHERE ean = :ean AND order_id = :order_id')
    # collected = db.execute(collected_query, {'ean': first.ean, 'order_id': order_id}).scalar()
    amount_on_location = product_service.fetch_scalar('amount', {'ean': first.ean, 'location': first.location, 'date': first.date}, 'products')
    # amount_on_location_query = text('SELECT amount FROM products WHERE ean = :ean AND location = :location AND date = :date')
    # amount_on_location = db.execute(amount_on_location_query, {'ean': first.ean, 'location': first.location, 'date': first.date}).scalar()
    if amount_on_location - (amount + collected) < 0:
        return {
                'message': f'It is only {amount_on_location} amount on location. Try again'
            }
    if amount + collected > first.amount:
        return {
            'message': 'Too big number to take. Try again'
        }
    execute.take_product_out_of_base(order_id, first, amount, collected, user_id)
    if amount + collected == first.amount:   
        return {
            'message': 'Product fully completed. Get next product'
        }
    if amount + collected < first.amount:
        return {
            'message': f'You took already {amount + collected} units.'
        }


@router.get('/get_next_product/{order_id}')
def get_next_product(order_id: str, current_user= Depends(get_current_user), db: Session= Depends(get_db)):
    product_service = ProductService(db)
    execute = ExecuteOrder(db)
    order = execute.Queue_To_Execute_Order(order_id)
    if not order:
        done = execute.get_done_products(order_id)
        return {
            'message': 'Order executed. No product to pick',
            'Picked products': [{
                'Product name': row.product_name,
                'Amount': row.picked_amount
            }for row in done]}
    first = order[0]
    amount_available = product_service.fetch_scalar('amount', {'ean': first.ean, 'location': first.location, 'date': first.date}, 'products')
    return {
        'product_name': first.product_name,
        'amount to collect/amount available': f'{first.amount}/{amount_available}',
        'Location': first.location,
        'message': f'Confirm location {first.location}'
    }
    

@router.get('/show_done_products/{order_id}')
def show_done_products(order_id: str, current_user= Depends(get_current_user), db: Session= Depends(get_db)):
    execute = ExecuteOrder(db)
    done_products = execute.get_done_products(order_id)
    return {
            'Done products': [{
                'Product name': row.product_name,
                'Amount': row.picked_amount,
                'Product ID': row.product_id
            }
                for row in done_products]}


@router.post('/reverse_product/{order_id}')
def reverse_product(order_id: str, body: ChooseProductSchema, current_user= Depends(get_current_user), db: Session= Depends(get_db)):
    execute = ExecuteOrder(db)
    product_service = ProductService(db)
    product_id = body.product_id
    product = product_service.fetch_one({'order_id': order_id, 'product_id': product_id}, 'order_picking_details')
    if not product:
        raise HTTPException(status_code= 404, detail= f'Product with id {product_id} not found for order {order_id}')
    try:
        reverse= execute.reverse_picked_product_out_of_base(order_id, product)
        return {
            'message': 'Picked product has been reverse'
        }
    except Exception as e:
        raise HTTPException(status_code= 500, detail= f'Error while reverse product {e}')
