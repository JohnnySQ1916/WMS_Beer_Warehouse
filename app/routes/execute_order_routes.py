from app.database.database import db
from sqlalchemy import text
from flask import Blueprint, jsonify, request
from app.utils import token_required
from webargs.flaskparser import use_args
from app.warehouse_operations.execute_order import Queue_To_Execute_Order, take_product_out_of_base, reservation_of_location, get_done_products, reverse_picked_product_out_of_base
from app.common_schema import EanSchema, LocationSchema, DateSchema, AmountSchema, ChooseProductSchema

#WPROWADZIC DO WSZYSTKICH CONFIRM ROUTE SPRAWDZANIE STATUSU ORDERS_DETAILS DLA DANEGO EANU CZY POPRZEDNIA CZYNNOSC ZOSTALA ZREALIZOWANA. ŻEBY POTWIERDZANIE AMOUNT NIE MOGLO BYC PRZED POTWIERDZENIEM EANU ALBO LOKALIZACJI

execute_order_bp = Blueprint('execute_order', __name__, '/execute_order')


@execute_order_bp.route('/order_choice', methods=['GET'])
@token_required
def execute_order_choice(user_id):
    orders_query = text("""SELECT o.order_id, c.company_name, o.amount, o.total_weight 
                        FROM orders o
                        JOIN customers c ON o.customer_id = c.customer_id
                        WHERE o.status = 'Undone'""")
    orders = db.session.execute(orders_query).fetchall()
    if orders:
        return jsonify({
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
        })
    return jsonify({'message': 'Orders not found'}), 404


@execute_order_bp.route('/check_order/<path:order_id>', methods=['GET'])
@token_required
def check_products_on_order(user_id, order_id):
    products_query = text(
        'SELECT product_name, amount FROM orders_details WHERE order_id = :order_id')
    products = db.session.execute(
        products_query, {'order_id': order_id}).fetchall()
    if products:
        return jsonify({
            'Products': [{
                'Product name': row.product_name,
                'Amount': row.amount
            }
                for row in products]})
    return jsonify({'message': 'Order not found'}), 404


@execute_order_bp.route('/start_order/<path:order_id>', methods=['GET'])
@token_required
def start_order(user_id, order_id):
    order = Queue_To_Execute_Order(order_id)
    reservation_of_location(order_id)
    if not order:
        return jsonify({'message': 'No position to execute'}), 404
    first = order[0]
    amount_available_query = text(
        'SELECT amount FROM products WHERE ean = :ean AND location = :location AND date = :date')
    amount = db.session.execute(amount_available_query, {
                                          'ean': first.ean, 'location': first.location, 'date': first.date}).scalar()
    return jsonify({
        'product_name': first.product_name,
        'amount to collect/amount available': f'{first.amount}/{amount}',
        'Location': first.location,
        'message': f'Confirm location {first.location}'
    })


@execute_order_bp.route('/confirm_location/<path:order_id>', methods=['POST'])
@token_required
@use_args(LocationSchema, location='json')
def confirm_location(user_id, args, order_id):
    location = args['location']
    order = Queue_To_Execute_Order(order_id)
    if not order:
        return jsonify({'message': f'Brak elementów do zebrania dla zamówienia {order_id}'}), 404
    first = order[0]
    if location == first.location:
        return jsonify({
            'message': f'Enter ean: {first.ean}'
        }), 200
    else:
        return jsonify({
            'message': 'Wrong location. Try again'
        })


@execute_order_bp.route('/confirm_ean/<path:order_id>', methods=['POST'])
@token_required
@use_args(EanSchema, location='json')
def confirm_ean(user_id, args, order_id):
    ean = args['ean']
    order = Queue_To_Execute_Order(order_id)
    if not order:
        return jsonify({'message': f'Brak elementów do zebrania dla zamówienia {order_id}'}), 404
    first = order[0]
    if ean == first.ean:
        return jsonify({
            'message': 'Enter amount: '
        })
    else:
        return jsonify({
            'message': 'Wrong ean. Try again'
        })


@execute_order_bp.route('/confirm_amount/<path:order_id>', methods=['POST'])
@token_required
@use_args(AmountSchema, location='json')
def confirm_amount(user_id, args, order_id):
    amount = args['amount']
    order = Queue_To_Execute_Order(order_id)
    if not order:
        return jsonify({'message': f'Brak elementów do zebrania dla zamówienia {order_id}'}), 404
    first = order[0]
    collected_query = text(
        'SELECT collected_amount FROM orders_details WHERE ean = :ean AND order_id = :order_id')
    collected = db.session.execute(
        collected_query, {'ean': first.ean, 'order_id': order_id}).scalar()
    amount_on_location_query = text('SELECT amount FROM products WHERE ean = :ean AND location = :location AND date = :date')
    amount_on_location = db.session.execute(amount_on_location_query, {'ean': first.ean, 'location': first.location, 'date': first.date}).scalar()
    if amount_on_location - (amount + collected) < 0:
        return jsonify({
                'message': f'It is only {amount_on_location} amount on location. Try again'
            })
    if amount + collected > first.amount:
        return jsonify({
            'message': 'Too big number to take. Try again'
        })
    take_product_out_of_base(order_id, first, amount, collected, user_id)

    if amount + collected == first.amount:   
        return jsonify({
            'message': 'Product fully completed. Get next product'
        }), 200
    if amount + collected < first.amount:
        return jsonify({
            'message': f'You took already {amount + collected} units.'
        })
    

@execute_order_bp.route('/get_next_product/<path:order_id>', methods=['GET'])
@token_required
def get_next_product(user_id, order_id):
    order = Queue_To_Execute_Order(order_id)
    if not order:
        done = get_done_products(order_id)
        db.session.execute(text('UPDATE orders SET status = :status WHERE order_id = :order_id'), {'status': 'done', 'order_id': order_id})
        db.session.commit()
        return jsonify({
            'message': 'Order executed. No product to pick',
            'Picked products': [{
                'Product name': row.product_name,
                'Amount': row.picked_amount
            }for row in done]})
    first = order[0]
    amount_available_query = text(
        'SELECT amount FROM products WHERE ean = :ean AND location = :location AND date = :date')
    amount_available = db.session.execute(amount_available_query, {
                                          'ean': first.ean, 'location': first.location, 'date': first.date}).scalar()
    return jsonify({
        'product_name': first.product_name,
        'amount to collect/amount available': f'{first.amount}/{amount_available}',
        'Location': first.location,
        'message': f'Confirm location {first.location}'
    }), 200

@execute_order_bp.route('/show_done_products/<path:order_id>', methods=['GET'])
@token_required
def show_done_products(user_id, order_id):
    done_products = get_done_products(order_id)
    return jsonify({
            'Done products': [{
                'Product name': row.product_name,
                'Amount': row.picked_amount,
                'Product ID': row.product_id
            }
                for row in done_products]})


@execute_order_bp.route('/reverse_product/<path:order_id>', methods=['POST'])
@use_args(ChooseProductSchema, location='json')
@token_required
def reverse_product(user_id, args, order_id):
    try:
        product_id = args['product_id']
        product_id_query = text('SELECT * FROM order_picking_details WHERE order_id= :order_id AND product_id = :product_id')
        product = db.session.execute(product_id_query, {'order_id': order_id, 'product_id': product_id}).fetchone()
        if not product:
            return jsonify({'message': f'Product with id {product_id} not found for order {order_id}'}), 404
        reverse= reverse_picked_product_out_of_base(order_id, product)
        return jsonify({
            'message': 'Picked product has been reverse'
        })
    except Exception as e:
        return jsonify({'error': f'Error while reverse product {e}'}), 500