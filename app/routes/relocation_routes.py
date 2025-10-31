from flask import Blueprint, jsonify, request
from app.warehouse_operations.product_operations import find_product_by_ean, changing_product_location_by_ean
from app.warehouse_operations.relocate_operation import new_record_relocation, confirm_location, confirm_amount, confirm_target_location, relocate_in_products, new_record_relocation_by_location, confirm_ean
from app.warehouse_operations.location_operations import find_product_by_location
from marshmallow import Schema, fields
from webargs.flaskparser import use_args
from app.common_schema import EanSchema, LocationSchema, DateSchema, AmountSchema, ChooseProductSchema
from sqlalchemy import text
from app.database.database import db
from app.utils import token_required


relocation_bp = Blueprint('relocation', __name__, 'relocation')


@relocation_bp.route('/start/<string:ean>', methods=['GET'])
@token_required
def get_products_by_ean(user_id, ean):
    product = find_product_by_ean(ean)
    relocation_id = new_record_relocation(ean)
    print(relocation_id)
    if product:
        return jsonify({
            'product': product,
            'id': relocation_id,
            'message': 'Enter location'})
    return jsonify({'error': 'Product not found'}), 404


@relocation_bp.route('/enter_location/<int:id>', methods=['POST'])
@token_required
@use_args(LocationSchema(), location='json')
def enter_location(user_id, args, id):
    location = args['location']
    ean_query = text('SELECT ean FROM relocation WHERE id = :id')
    ean = db.session.execute(ean_query, {'id': id}).scalar()
    dooble_query = text(
        'SELECT id, product_name, date, amount FROM products WHERE ean= :ean AND location = :location')
    dooble = db.session.execute(
        dooble_query, {'ean': ean, 'location': location}).fetchall()
    if len(dooble) > 1:
        return jsonify({
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
        })
    elif len(dooble) == 1:
        date = dooble[0].date
        confirm_location(id, location, date, user_id)
        return jsonify({
            'message': 'Enter amount: '
        })
    else:
        return jsonify({
            'message': f'No product found with EAN {ean} on location {location}.'
        }), 400

@relocation_bp.route('confirm_date/<int:id>', methods=['POST'])
@token_required
@use_args(ChooseProductSchema(), location='json')
def choice_product_same_date(user_id, args, id):
    current = db.session.execute(text("SELECT status FROM relocation WHERE id = :id"),
        {'id': id}).scalar()
    if current != 'location_confirmed' or current != 'ean_confirmed':
        return jsonify({'error': 'Location or EAN not confirmed'})
    product_id = args['product_id']
    query = text('UPDATE relocation SET date = (SELECT date FROM products WHERE id = :product_id), status = :status WHERE id = :id')
    selected_date = db.session.execute(query, {'product_id': product_id, 'status': 'date_confirmed', 'id': id}).scalar()
    return jsonify({
        'message': 'Enter amount'
    })

@relocation_bp.route('confirm_amount/<int:id>', methods=['POST'])
@token_required
@use_args(AmountSchema(), location='json')
def enter_amount(user_id, args, id):
    current = db.session.execute(text("SELECT status FROM relocation WHERE id = :id"),
        {'id': id}).scalar()
    if current != 'date_confirmed':
        return jsonify({'error': 'Date not confirmed'})
    ean = db.session.execute(text('SELECT ean FROM relocation WHERE id = :id'), {'id': id}).scalar()
    location = db.session.execute(text('SELECT initial_location FROM relocation WHERE id = :id'), {'id': id}).scalar()
    date = db.session.execute(text('SELECT date FROM relocation WHERE id = :id'), {'id': id}).scalar()
    amount = args['amount']
    print(ean, location, date, amount)
    query = text('SELECT amount FROM products WHERE ean = :ean AND location= :location AND date = :date')
    amount_on_location = db.session.execute(query, {'ean':ean, 'location': location, 'date': date}).scalar()
    if amount > amount_on_location:
        return jsonify({'message': f'Too high number to relocate. On location it is only {amount_on_location}.'})
    else:
        confirm_amount(id, amount)
        return jsonify({'message': 'Enter target location'})
    

@relocation_bp.route('/confirm_target_location/<int:id>', methods=['POST'])
@token_required
@use_args(LocationSchema(), location='json')
def enter_target_location(user_id, args, id):
    current = db.session.execute(text("SELECT status FROM relocation WHERE id = :id"),
        {'id': id}).scalar()
    if current != 'amount_confirmed':
        return jsonify({'error': 'Amount not confirmed'})
    target_location = args['location']
    row = db.session.execute(text("""SELECT * FROM relocation WHERE id = :id"""), {'id': id}).fetchone()
    if row is None:
        return jsonify({'error': f'Relocation with id {id} not found'}), 404
    ean = row.ean
    location = row.initial_location
    date = row.date
    amount = row.amount
    try:
        confirm_target_location(id, target_location)
        result = relocate_in_products(ean, location, date, amount, target_location)
        return jsonify({
            'message': 'Relocate confirmed'
        })
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500
    

@relocation_bp.route('/relocate_by_location/<string:location>', methods=['GET'])
@token_required
def get_products_by_location(user_id, location):
    product = find_product_by_location(location)
    relocation_id = new_record_relocation_by_location(location, user_id)
    if product:
        return jsonify({
            'product': product,
            'id': relocation_id,
            'message': 'Enter ean'})
    return jsonify({'error': 'Product not found'}), 404

@relocation_bp.route('/enter_ean/<int:id>', methods=['POST'])
@token_required
@use_args(EanSchema(), location='json')
def enter_ean(user_id, args, id):
    # id = args['id']
    ean = args['ean']
    location_query = text('SELECT initial_location FROM relocation WHERE id = :id')
    location = db.session.execute(location_query, {'id': id}).scalar()
    product_name_query = text('SELECT product_name FROM products WHERE ean = :ean')
    product_name = db.session.execute(product_name_query, {'ean' : ean}).scalar()
    dooble_query = text(
        'SELECT id, product_name, date, amount FROM products WHERE ean= :ean AND location = :location')
    dooble = db.session.execute(
        dooble_query, {'ean': ean, 'location': location}).fetchall()
    if len(dooble) > 1:
        return jsonify({
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
        })
    elif len(dooble) == 1:
        date = dooble[0].date
        confirm_ean(id, product_name, ean, date)
        return jsonify({
            'message': 'Enter amount: '
        })
    else:
        return jsonify({
            'message': f'No product found with EAN {ean} on location {location}.'
        }), 400



