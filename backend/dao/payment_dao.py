from __future__ import annotations
from config import get_connection
from dto.payment_dto import PaymentDTO


def find_by_record_id(record_id: int) -> PaymentDTO | None:
    """출차 후 생성된 정산 정보 조회"""
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT * FROM Payment WHERE record_id = %s",
                (record_id,),
            )
            row = cur.fetchone()
    finally:
        conn.close()
    return PaymentDTO(**row) if row else None
