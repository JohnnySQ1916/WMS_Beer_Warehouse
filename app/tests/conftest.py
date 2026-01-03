import pytest
from app.database.database import get_db
from sqlalchemy import text
from fastapi.testclient import TestClient
from app.main import app as fastapi_app
from app.database.database import TestSessionLocal, test_engine
from app.database.base import Base

# Tworzenie struktury tabel dla testów
@pytest.fixture(scope="function", autouse= True)
def test_db_setup():
    Base.metadata.create_all(bind=test_engine)
    yield
    Base.metadata.drop_all(bind=test_engine)

# Sesja DB — taka sama jak w projekcie
@pytest.fixture(scope="function")
def db_session():
    connection = test_engine.connect()
    transaction = connection.begin()
    session = TestSessionLocal(bind=connection)
    try:
        yield session
    finally:
        session.close()
        transaction.rollback()
        connection.close()

# Testowy klient FastAPI
@pytest.fixture(scope="function")
def client(db_session):
    def override_get_db():
        try:
            yield db_session
        finally:
            pass
    fastapi_app.dependency_overrides[get_db] = override_get_db
    with TestClient(fastapi_app) as c:
        yield c

    fastapi_app.dependency_overrides.clear()

# Tworzenie użytkownika
@pytest.fixture(scope="function")
def user(client):
    user_data = {
        "user_id": "ks",
        "user_name": "test_user",
        "password": "test"
    }
    response = client.post("/authentication/register", json=user_data)
    assert response.status_code in (200, 201)
    return user_data

# Pobranie tokena dla testów
@pytest.fixture(scope="function")
def token(client, user):
    response = client.post(
        "/authentication/login",
        json={"user_id": user["user_id"], "password": user["password"]}
    )
    assert response.status_code == 200
    data = response.json()
    assert "token" in data
    return data["token"]