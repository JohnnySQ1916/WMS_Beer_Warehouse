from app.database.database import db
from flask import Blueprint, jsonify, request
from webargs.flaskparser import use_args
from marshmallow import Schema, fields
from app.routes.product_operation_routes import get_product_by_ean
from app.utils import token_required

confirm_bp = Blueprint('confirm', __name__, url_prefix= '/confirm')

class ConfirmEanSchema(Schema):
    location = fields.Str(required=True)
    scanned_location = fields.Str(required=True)

@confirm_bp('/location', methods= ['POST'])
@token_required
@use_args(ConfirmEanSchema, location = "json")
def confirm_location(args):
    location = args['location']
    return jsonify

def confirm_ean():
    pass


