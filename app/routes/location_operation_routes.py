from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.database.database import get_db
from app.models import ApiResponse
from app.utils import get_current_user
from app.warehouse_operations.location_operations import LocationService

router = APIRouter(prefix="/location", tags=["Location"])


@router.get("/{location}", response_model=ApiResponse)
def get_products_on_location(
    location: str, db: Session = Depends(get_db), current_user=Depends(get_current_user)
):
    service = LocationService(db)
    locat = service.find_product_by_location(location)
    return ApiResponse(data=locat)
