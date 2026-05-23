from __future__ import annotations
from config import get_connection
from dto.parking_dto import ParkingRecordDTO


def call_enter(plate_number: str, spot_id: int, visit_unit_id, user_type: str) -> None:
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.callproc("sp_park_enter", [plate_number, spot_id, visit_unit_id, user_type])
        conn.commit()
    finally:
        conn.close()


def call_exit(record_id: int, method: str) -> None:
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.callproc("sp_park_exit", [record_id, method])
        conn.commit()
    finally:
        conn.close()


def find_active_by_plate(plate_number: str) -> ParkingRecordDTO | None:
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT * FROM ParkingRecord "
                "WHERE plate_number = %s AND exit_time IS NULL "
                "LIMIT 1",
                (plate_number,),
            )
            row = cur.fetchone()
    finally:
        conn.close()
    return ParkingRecordDTO(**row) if row else None


def find_by_id(record_id: int) -> ParkingRecordDTO | None:
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT * FROM ParkingRecord WHERE record_id = %s",
                (record_id,),
            )
            row = cur.fetchone()
    finally:
        conn.close()
    return ParkingRecordDTO(**row) if row else None
