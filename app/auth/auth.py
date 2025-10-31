from flask import Blueprint, abort, jsonify, request
from werkzeug.security import generate_password_hash, check_password_hash
from sqlalchemy import text
from app.database.database import db
from webargs.flaskparser import use_args
from app.common_schema import AuthRegisterSchema, AuthLoginSchema
from app.models import Users

auth_bp = Blueprint('auth', __name__, url_prefix='/authentication')

@auth_bp.route('/register', methods = ['POST'])
def add_user():
    args = request.get_json()
    print("Received args:", args)
    user_id = args['user_id']
    user_name = args['user_name']
    if db.session.execute(text('SELECT user_id FROM users WHERE user_id = :user_id'), {'user_id': user_id}).scalar():
        abort(409, description= f'User with id {user_id} is already exist')
    password = generate_password_hash(args['password'])
    user = Users(user_id= user_id, user_name = user_name, password = password)
    db.session.add(user)
    db.session.commit()
    token = user.generate_jwt()
    
    return jsonify({
        'success': True,
        'token': token
    }), 201


@auth_bp.route('/login', methods = ['POST'])
@use_args(AuthLoginSchema(), location='json')
def log_user(args):
    user = Users.query.filter(Users.user_id == args['user_id']).first()
    if not user:
        abort(401, description = f'Invalid credencial')
    if not user.is_password_valid(args['password']):
        abort(401, description = f'Invalid credencial')
    print(request.get_json())
    token = user.generate_jwt()

    return jsonify({
        'success': True,
        'token': token
    })

