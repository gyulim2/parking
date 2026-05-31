from __future__ import annotations
from config import get_connection


def find_all_by_lot(lot_id: int) -> list[dict]:
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
