from app.database.database import db
from sqlalchemy import text
from flask import Blueprint, jsonify, request
from app.utils import token_required
from webargs.flaskparser import use_args
from app.common_schema import DeliverCreateSupplier, DeliverCreateDetails, EanSchema, AmountSchema, LocationSchema, DateSchema, DeliverProductsListSchema
from app.warehouse_operations.deliver_services import create_supplier_deliver, create_deliver_details, supplier_exist, change_ean_status, update_products, check_status
from datetime import datetime, date

delivery_bp = Blueprint('delivery', __name__, url_prefix= '/delivery')

@delivery_bp.route('/create_supplier_delivery', methods= ['POST'])
@token_required
@use_args(DeliverCreateSupplier, location= 'json')
def create_supplier_delivery_document(user_id, args):
    supplier = args['supplier']
    deliver_external_number = args['deliver_external_number']
    delivery_date = args['delivery_date']
    exist = supplier_exist(supplier)
    if not exist:
        return jsonify({
            'message': 'There is no such supplier in database. Add supplier to database'
        }), 400
    create = create_supplier_deliver(supplier, deliver_external_number, delivery_date)
    return jsonify({
            'message': f'Delivery add to database with number {create}'
        }), 200


@delivery_bp.route('/create_delivery/<path:deliver_id>', methods= ['POST'])
@token_required
@use_args(DeliverProductsListSchema, location= 'json')
def create_delivery_details_document(user_id, args, deliver_id):
    products = args['products']
    for product in products:
        product_name = product['product_name']
        ean = product['ean']
        expected_amount = product['expected_amount']
        create = create_deliver_details(deliver_id, product_name, ean, expected_amount)
    return jsonify({
            'message': f'Products add to deliver_order number {deliver_id}'
        }), 200


@delivery_bp.route('/check_supplier_deliver', methods= ['GET'])
@token_required
def check_supplier_delivery(user_id):
    delivery = db.session.execute(text("SELECT supplier FROM delivery_order WHERE status = 'undone' OR status = 'pending'")).fetchall()
    if not delivery:
        return jsonify({'message': 'No products found for execute delivery'}), 404
    return jsonify({
        'Supplier': [
            {'Supplier': row.supplier}
        for row in delivery]
    }), 200

@delivery_bp.route('/check_delivery/<path:deliver_id>', methods= ['GET'])
@token_required
def check_delivery(user_id, deliver_id):
    delivery_query = text("SELECT product_name, expected_amount, ean FROM deliver_details WHERE deliver_id = :deliver_id AND status NOT IN ('done', 'pending')")
    delivery = db.session.execute(delivery_query, {'deliver_id': deliver_id}).fetchall()
    if not delivery:
        return jsonify({'message': 'No products found for given delivery ID'}), 404
    return jsonify({
        'Products': [
            {'Product name': row.product_name,
            'Expected Amount': row.expected_amount,
            'EAN': row.ean}
        for row in delivery]
    }), 200

@delivery_bp.route('/enter_ean_delivery/<path:deliver_id>', methods= ['POST'])
@token_required
@use_args(EanSchema, location= 'json')
def enter_ean_delivery(user_id, args, deliver_id):
    ean = args['ean']
    is_ean_on_list = db.session.execute(text("SELECT ean FROM deliver_details WHERE ean = :ean AND deliver_id = :deliver_id"), {'ean':ean, 'deliver_id': deliver_id}).fetchone()
    expected_amount = db.session.execute(text("SELECT expected_amount FROM deliver_details WHERE ean = :ean AND deliver_id = :deliver_id"), {'ean':ean, 'deliver_id': deliver_id}).scalar()
    if is_ean_on_list:
        ean_location = db.session.execute(text('SELECT product_name, amount, location, date FROM products WHERE ean = :ean'), {'ean': ean}).fetchall()
        change_ean_status(ean, deliver_id)
        return jsonify({
            'Expected Amount': expected_amount,
            'Products': [{
                'Product name': row.product_name,
                'Amount': row.amount,
                'Location': row.location,
                'Date': row.date
            } for row in ean_location],
            'message' : 'Enter product date expired'
        }), 200
    return jsonify({
        'message': 'There is no such ean on deliver list'
    }), 404


@delivery_bp.route('/enter_date/<path:deliver_id>/<path:ean>', methods= ['POST'])
@token_required
@use_args(DateSchema, location= 'json')
def enter_date(user_id, args, deliver_id, ean):
    is_ean_on_list = db.session.execute(text("SELECT ean FROM deliver_details WHERE ean = :ean AND deliver_id = :deliver_id"), {'ean':ean, 'deliver_id': deliver_id}).fetchone()
    if not is_ean_on_list:
        return jsonify({
            'message': 'There is no such ean on deliver list'
        }), 404
    status = check_status(ean, deliver_id)
    if status != 'ean confirmed':
        return jsonify({
            'message': 'Confirm ean'
        })
    expiration_date =  args['date']
    update_query = text("UPDATE deliver_details SET date = :date, status = 'date confirmed' WHERE deliver_id = :deliver_id AND ean = :ean AND target_location IS NULL")
    db.session.execute(update_query, {'date': expiration_date, 'deliver_id': deliver_id, 'ean': ean})
    db.session.commit()
    return jsonify({
        'message': "Enter amount of that product. If there is bigger number than expected amount, add to args 'force': true "
    }), 200


@delivery_bp.route('/enter_amount_delivery/<path:deliver_id>/<path:ean>', methods= ['POST'])
@token_required
@use_args(AmountSchema, location= 'json')
def enter_amount_delivery(user_id, args, deliver_id, ean):
    is_ean_on_list = db.session.execute(text("SELECT ean FROM deliver_details WHERE ean = :ean AND deliver_id = :deliver_id"), {'ean':ean, 'deliver_id': deliver_id}).fetchone()
    if not is_ean_on_list:
        return jsonify({
            'message': 'There is no such ean on deliver list'
        }), 404
    status = check_status(ean, deliver_id)
    if status != 'date confirmed':
        return jsonify({
            'message': 'Confirm date'
        })
    amount = args['amount']
    total_amount = db.session.execute(text("SELECT SUM(amount) FROM deliver_details WHERE ean = :ean AND deliver_id = :deliver_id"), 
                                         {'ean':ean, 'deliver_id': deliver_id}).scalar() or 0
    force = args.get('force', False)
    print(force)
    expected_amount = db.session.execute(text("SELECT expected_amount FROM deliver_details WHERE ean = :ean AND deliver_id = :deliver_id"), {'ean':ean, 'deliver_id': deliver_id}).scalar()
    if amount + total_amount > expected_amount:
        if not force:
            return jsonify({
                'message': "Entered amount is bigger than expected amount. If you want to confirm that amount, add to args 'force': true"
            }),400
        else:
            db.session.execute(text("UPDATE deliver_details SET amount = :amount, status = 'amount confirmed' WHERE deliver_id = :deliver_id AND ean = :ean AND target_location IS NULL"),
                        {'amount': amount, 'deliver_id': deliver_id, 'ean': ean})
            db.session.commit()
            return jsonify({
            'message': 'Enter target location'
            }), 200
    elif amount < expected_amount:
        db.session.execute(text("UPDATE deliver_details SET amount = :amount, status = 'amount confirmed' WHERE deliver_id = :deliver_id AND ean = :ean AND target_location IS NULL"),
                        {'amount': amount, 'deliver_id': deliver_id, 'ean': ean})
        db.session.commit()
        return jsonify({
        'message': 'Enter target location'
        }), 200
    db.session.execute(text("UPDATE deliver_details SET amount = :amount, status = 'amount confirmed' WHERE deliver_id = :deliver_id AND ean = :ean"),
                        {'amount': amount, 'deliver_id': deliver_id, 'ean': ean})
    db.session.commit()
    return jsonify({
        'message': 'Enter target location'
    }), 200


@delivery_bp.route('/enter_location_delivery/<path:deliver_id>/<path:ean>', methods= ['POST'])
@token_required
@use_args(LocationSchema, location= 'json')
def enter_location_delivery(user_id, args, deliver_id, ean):
    target_location = args['location']
    status = check_status(ean, deliver_id)
    if status != 'amount confirmed':
        return jsonify({
            'message': 'Confirm amount'
        }), 404
    expected_amount = db.session.execute(text("SELECT expected_amount FROM deliver_details WHERE ean = :ean AND deliver_id = :deliver_id"), 
                                         {'ean':ean, 'deliver_id': deliver_id}).scalar()
    total_amount = db.session.execute(text("SELECT SUM(amount) FROM deliver_details WHERE ean = :ean AND deliver_id = :deliver_id"), 
                                         {'ean':ean, 'deliver_id': deliver_id}).scalar() or 0
    if total_amount == expected_amount:
        status = 'done'
    else:
        status = 'pending'
    update_deliver_query = text("""UPDATE deliver_details SET user_id = :user_id, target_location = :target_location, deliver_time = :deliver_time, status = :status,
                                deliver_date = :deliver_date WHERE ean = :ean AND deliver_id = :deliver_id AND target_location IS NULL""")
    db.session.execute(update_deliver_query, {'user_id': user_id, 'target_location': target_location, 'ean': ean, 'deliver_id': deliver_id, 
                                            'deliver_time': datetime.now().strftime('%H:%M'), 'status': status, 'deliver_date': date.today()})
    if total_amount < expected_amount:
        product_query = text('SELECT * FROM deliver_details WHERE deliver_id = :deliver_id AND ean = :ean ORDER BY id DESC LIMIT 1')
        product = db.session.execute(product_query, {'deliver_id': deliver_id, 'ean': ean}).fetchone()
        insert_query = text("""INSERT INTO deliver_details (deliver_id, user_id, product_name, ean, expected_amount, status)
                            VALUES (:deliver_id, :user_id, :product_name, :ean, :expected_amount, :status)""")
        insert = db.session.execute(insert_query, {'deliver_id': deliver_id, 'user_id': user_id, 
                                                'product_name': product.product_name, 'ean': ean, 'expected_amount': product.expected_amount - total_amount, 'status': 'undone'})

    if_done = db.session.execute(text("SELECT * FROM deliver_details WHERE deliver_id = :deliver_id AND status = 'undone' LIMIT 1"), {'deliver_id': deliver_id}).fetchone()
    if not if_done:
        deliver = db.session.execute(text("UPDATE delivery_order SET status = 'done' WHERE deliver_id = :deliver_id"), {'deliver_id': deliver_id})
    db.session.commit()
    update = update_products(target_location, ean, deliver_id)
    if update == True:
        return jsonify({
            'message': 'Product accepted on location'
        }), 200
    else:
        return jsonify({
            'message': 'error appeared'
        })
