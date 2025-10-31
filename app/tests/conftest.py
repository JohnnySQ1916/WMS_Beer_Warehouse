import pytest
from app import create_app, db
from sqlalchemy import text

@pytest.fixture
def app():
    app = create_app('testing')

    with app.app_context():
        db.drop_all()
        db.create_all()
        yield app
        db.session.remove()
        db.drop_all()

    
@pytest.fixture
def client(app):
    return app.test_client()

@pytest.fixture
def db_session(app):
    with app.app_context():
        yield db.session
        db.session.rollback()


@pytest.fixture
def user(client):
    user = {'user_id': 'ks', 'user_name':'test_user', 'password':'test'}
    client.post('/authentication/register', json = user)
    return user


@pytest.fixture
def token(client, user):
    response = client.post('/authentication/login', json= {'user_id': user['user_id'], 'password': user['password']})
    return response.get_json()['token']