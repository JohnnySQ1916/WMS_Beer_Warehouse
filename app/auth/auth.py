from werkzeug.security import generate_password_hash, check_password_hash
from sqlalchemy import text
from app.database.database import get_db
from app.common_schema import AuthRegisterSchema, AuthLoginSchema
from app.models import Users
from fastapi import FastAPI, Depends, HTTPException, APIRouter
from sqlalchemy.orm import Session
from app.common_schema import AuthRegisterSchema, AuthLoginSchema


router = APIRouter(prefix= '/authentication', tags= ['Authentication'])

def validate_password_login(db:Session, user_id, password):
        result = db.execute(text('SELECT password FROM users WHERE user_id = :user_id'), {'user_id': user_id}).scalar()
        if not result or not check_password_hash(result, password):
            raise HTTPException(status_code= 401, detail='Wrong password')
        return True
    
@router.post('/register')
def add_user(body: AuthRegisterSchema, db: Session = Depends(get_db)):
    user_id = body.user_id
    user_name = body.user_name
    result = db.execute(text('SELECT 1 FROM users WHERE user_id = :user_id'), {'user_id': user_id}).scalar()
    if result:
        raise HTTPException(status_code= 409, detail= f'User with id {user_id} is already exist')
    password = generate_password_hash(body.password)
    user = Users(user_id= user_id, user_name = user_name, password = password)
    db.add(user)
    db.commit()
    token = user.generate_jwt()
    return {
        'success': True,
        'token': token
    }


@router.post('/login')
def log_user(body: AuthLoginSchema, db: Session = Depends(get_db)):
    user_id = body.user_id
    password = body.password
    user = db.query(Users).filter(Users.user_id == user_id).first()
    if not user:
        raise HTTPException(409, f'Invalid credencial')
    if not validate_password_login(db, user_id, password):
       raise HTTPException(status_code= 401, detail= f'Invalid credencial')
    token = user.generate_jwt()
    return {
        'success': True,
        'token': token
    }