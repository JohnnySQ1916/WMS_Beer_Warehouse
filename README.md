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


## Installation & Run
1. Clone the repository:
```bash
git clone https://github.com/JohnnySQ1916/wms.git
cd wms

## Postman Documentation
You can view the full API documentation here:  
[WMS API Docs](https://documenter.getpostman.com/view/38894958/2sB3WsQzuL)

## How to use
1. Import the Postman Collection from the `WMS.postman_collection.json` file.  
2. Follow the documentation to test endpoints and workflows.

