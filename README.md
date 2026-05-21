# WMS Project
Warehouse Management System – Mini-Application in Python + FastAPI + PostgreSQL

## Description
This project is a mini Warehouse Management System (WMS) inspired by a real system used in a beer wholesale warehouse.

The application focuses on backend logic and API-driven workflows that reflect daily warehouse operations.  
It is designed as a terminal/API-first system, similar to real WMS solutions used by warehouse workers.

The system supports key warehouse processes, including:

- Receiving goods into the database  
- Searching for products by EAN code or warehouse location  
- Relocating goods between warehouse locations  
- Creating and fulfilling customer orders  
- Managing customers, suppliers, and products  
- Monitoring warehouse movements and stock changes  

Warehouse locations are based on a real warehouse layout.  
During order fulfillment, the system is designed to support efficient and ergonomic picking workflows.


## Technologies
- Python 3.11  
- FastAPI  
- SQLAlchemy (Core / raw SQL)  
- PostgreSQL  
- Uvicorn  
- JWT authentication  
- Docker / Docker Compose
- CI (GitHub Actions: pytest + Ruff)

## Run with Docker

### 1. Clone the repository:
```bash
git clone https://github.com/JohnnySQ1916/wms.git
cd wms
```
### 2. Start containers
```bash
docker compose up --build
```
### 3. Import database dump
```bash
docker compose exec -T db psql -U postgres -d wms_db < database/wms_dump.sql
```
## API Documentation

Swagger UI:
http://localhost:8000/docs

## Postman Documentation
You can view the full API documentation here:  
[WMS API Docs](https://documenter.getpostman.com/view/38894958/2sB3WsQzuL)

## How to use
1. Import the Postman Collection from the `WMS.postman_collection.json` file.  
2. Follow the documentation to test endpoints and workflows.

## Authentication
1. Log in via:
POST /auth/login
2. Copy the access token from the response
3. In Postman:
- Go to Authorization tab
- Select: Bearer Token
- Paste the token

## Test Access (Development Mode)

For easier testing, the system includes a preconfigured test login.

This allows quick access to the API without the need for user registration.

- Username: `KS`
- Password: `1`
- Purpose: test user for development and API verification only

This approach is intended to simplify local testing and demo workflows.

## Project Features
- warehouse stock management
- order lifecycle handling
- location-based inventory system
- JWT-secured API
- Dockerized environment
- CI pipeline with testing and linting