from __future__ import annotations
from config import get_connection


def find_vehicle_info(plate_number: str) -> dict | None:
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT plate_number, is_disabled, is_ev FROM Vehicle WHERE plate_number = %s",
                (plate_number,),
            )
            vehicle = cur.fetchone()
            if vehicle is None:
                return None

            cur.execute("SELECT 1 FROM DeptEmployee WHERE plate_number = %s", (plate_number,))
            if cur.fetchone():
                user_type = "employee"
            else:
                cur.execute("SELECT 1 FROM AptResident WHERE plate_number = %s", (plate_number,))
                user_type = "resident" if cur.fetchone() else "general"
    finally:
        conn.close()

    return {
        "plate_number": vehicle["plate_number"],
        "user_type":    user_type,
        "is_disabled":  bool(vehicle["is_disabled"]),
        "is_ev":        bool(vehicle["is_ev"]),
    }


def find_units_by_lot(lot_id: int) -> list[dict]:
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT unit_id, unit_number FROM AptUnit WHERE lot_id = %s ORDER BY unit_number",
                (lot_id,),
            )
            return cur.fetchall()
    finally:
        conn.close()
