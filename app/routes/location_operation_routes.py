from flask import Blueprint, jsonify, request
from app.warehouse_operations.location_operations import find_product_by_location
from app.utils import token_required

location_bp = Blueprint('location', __name__, url_prefix='/location')

@token_required
@location_bp.route('/<string:location>', methods = ['GET'])
def get_products_on_location(location):
    locat = find_product_by_location(location)
    if locat:
        return jsonify(locat)
    return jsonify({'error': 'Location not found'}), 404