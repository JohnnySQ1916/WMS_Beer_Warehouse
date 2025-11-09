# WMS Project
Warehouse Management System – Mini-Application in Python + Flask + PostgreSQL

## Description
This is a mini Warehouse Management System (WMS) application, based on a real system used in a beer wholesale warehouse.

The application covers basic tasks performed by a warehouse worker, whose main tool is a terminal. The WMS supports the most important warehouse operations, such as:

- Receiving goods into the database  
- Searching for products by EAN code or warehouse location  
- Relocating goods from one location to another  
- Order fulfillment  
- Monitoring warehouse movements in real time  

Locations are based on the actual warehouse layout.  
During order fulfillment, the application defines the most efficient workflow, taking into account solutions that are both **ergonomic for the warehouse worker** and fastest in execution.

## Technologies & Requirements
- Python 3.11.4  
- Flask 2.3 (verify your version)  
- SQLAlchemy 2.0  
- PostgreSQL  
- pip

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