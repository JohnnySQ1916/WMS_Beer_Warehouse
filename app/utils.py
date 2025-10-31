from functools import wraps
import jwt
from flask import request, current_app, url_for, abort, g


def token_required(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        token= None
        auth = request.headers.get('Authorization')
        if auth:
            token = auth.split(' ')[1]
            print(token)
        if token is None:
            abort(401, description = 'Missing token. Please log or register')
        try:
            payload = jwt.decode(token, current_app.config.get('SECRET_KEY'), algorithms=['HS256'])
        except jwt.ExpiredSignatureError:
            abort(401, description = 'Expired token. Please log to get new token')
        except jwt.InvalidTokenError:
            abort(401, description = 'Invalid token. Please log or register')
        
        # g.user_id = payload['user_id']  
        # return func(*args, **kwargs)
        user_id = payload["user_id"]
        return func(user_id, *args, **kwargs)
    return wrapper