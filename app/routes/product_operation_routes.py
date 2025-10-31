from flask import Blueprint, jsonify, request
from app.warehouse_operations.product_operations import find_product_by_ean, changing_product_location_by_ean
from webargs.flaskparser import use_args
from app.utils import token_required


product_bp = Blueprint('products', __name__, url_prefix= '/products')

@token_required
@product_bp.route('/<string:ean>', methods = ['GET'])
def get_product_by_ean(ean):
    product = find_product_by_ean(ean)
    if product:
        return jsonify(product)
    return jsonify({'error': 'Product not found'}), 404