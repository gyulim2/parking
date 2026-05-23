from dataclasses import dataclass
from datetime import datetime
from typing import Optional


@dataclass
class ParkEnterRequest:
    plate_number:  str
    spot_id:       int
    user_type:     str 
    visit_unit_id: Optional[int] = None


@dataclass
class ParkExitRequest:
    record_id: int
    method:    str


@dataclass
class ParkingRecordDTO:
    record_id:     int
    plate_number:  str
    spot_id:       int
    user_type:     str
    entry_time:    datetime
    exit_time:     Optional[datetime] = None
    visit_unit_id: Optional[int]      = None


@dataclass
class ParkingSpotDTO:
    spot_id:    int
    lot_id:     int
    floor:      int
    zone:       str
    spot_type:  str
    is_occupied: bool
