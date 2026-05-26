from __future__ import annotations
from config import get_connection
from dto.parking_dto import ParkingSpotDTO


def find_available(lot_id: int, spot_type: str) -> ParkingSpotDTO | None:
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT * FROM ParkingSpot "
                "WHERE lot_id = %s AND spot_type = %s AND is_occupied = FALSE "
                "ORDER BY floor, zone, spot_id "
                "LIMIT 1",
                (lot_id, spot_type),
            )
            row = cur.fetchone()
    finally:
        conn.close()
    return ParkingSpotDTO(**row) if row else None


def find_by_id(spot_id: int) -> ParkingSpotDTO | None:
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT * FROM ParkingSpot WHERE spot_id = %s",
                (spot_id,),
            )
            row = cur.fetchone()
    finally:
        conn.close()
    return ParkingSpotDTO(**row) if row else None


def find_all_by_lot(lot_id: int) -> list[dict]:
    """프론트 평면도 렌더링용 — 특정 주차장의 전체 자리 반환"""
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT spot_id, lot_id, floor, zone, spot_type, is_occupied "
                "FROM ParkingSpot WHERE lot_id = %s ORDER BY floor, zone, spot_id",
                (lot_id,),
            )
            return cur.fetchall()
    finally:
        conn.close()
