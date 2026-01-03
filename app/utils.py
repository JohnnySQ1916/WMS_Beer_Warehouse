from functools import wraps
import jwt
from fastapi import Header, HTTPException, Depends
from fastapi.security import OAuth2PasswordBearer
import os
from datetime import datetime, timedelta


def verify_token(authorization: str = Header(None)):
    if not authorization or authorization != "TwójSekretnyToken":
        raise HTTPException(status_code=401, detail="Unauthorized")
    return True

SECRET_KEY = os.getenv("JWT_SECRET", "defaultsecret")
EXPIRE_MINUTES = int(os.getenv("JWT_EXPIRED_MINUTES", 60))

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/login")  # ścieżka do loginu

def create_jwt_token(user_id: str):
    payload = {
        "user_id": user_id,
        "exp": datetime.utcnow() + timedelta(minutes=EXPIRE_MINUTES)
    }
    token = jwt.encode(payload, SECRET_KEY, algorithm="HS256")
    return token

def get_current_user(token: str = Depends(oauth2_scheme)):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
        user_id = payload.get("user_id")
        if user_id is None:
            raise HTTPException(status_code=401, detail="Invalid token")
        return {"user_id": user_id}
    except jwt.ExpiredSignatureError:
        raise HTTPException(status_code=401, detail="Token expired")
    except jwt.InvalidTokenError:
        raise HTTPException(status_code=401, detail="Invalid token")

# def token_required(func):
#     @wraps(func)
#     def wrapper(*args, **kwargs):
#         token= None
#         auth = request.headers.get('Authorization')
#         if auth:
#             token = auth.split(' ')[1]
#             print(token)
#         if token is None:
#             abort(401, description = 'Missing token. Please log or register')
#         try:
#             payload = jwt.decode(token, current_app.config.get('SECRET_KEY'), algorithms=['HS256'])
#         except jwt.ExpiredSignatureError:
#             abort(401, description = 'Expired token. Please log to get new token')
#         except jwt.InvalidTokenError:
#             abort(401, description = 'Invalid token. Please log or register')
        
#         # g.user_id = payload['user_id']  
#         # return func(*args, **kwargs)
#         user_id = payload["user_id"]
#         return func(user_id, *args, **kwargs)
#     return wrapper