from __future__ import annotations
from config import get_connection
from dto.parking_dto import ParkEnterRequest, ParkExitRequest, ParkingRecordDTO
from dao import parking_record_dao, parking_spot_dao, payment_dao, season_pass_dao


# ── 차량 등록 (upsert) ────────────────────────────────────────────────────────

def upsert_vehicle(plate_number: str, is_disabled: bool, is_ev: bool) -> None:
    """미등록 차량이면 INSERT, 등록 차량이면 DB 값 그대로 유지 (자가신고 위조 방지)"""
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT 1 FROM Vehicle WHERE plate_number = %s", (plate_number,)
            )
            if cur.fetchone() is None:
                cur.execute(
                    "INSERT INTO Vehicle (plate_number, is_disabled, is_ev) VALUES (%s, %s, %s)",
                    (plate_number, is_disabled, is_ev),
                )
        conn.commit()
    finally:
        conn.close()


# ── 입차 ──────────────────────────────────────────────────────────────────────

def enter(req: ParkEnterRequest) -> None:
    parking_record_dao.call_enter(
        plate_number=req.plate_number,
        spot_id=req.spot_id,
        visit_unit_id=req.visit_unit_id,
        user_type=req.user_type,
    )


# ── 출차 / 정산 ───────────────────────────────────────────────────────────────

def exit_and_pay(req: ParkExitRequest) -> dict:
    """출차 + 정산. 명세서 7-4 에 따라 시간 정보까지 포함한 dict 반환."""
    record = parking_record_dao.find_by_id(req.record_id)
    if record is None:
        raise ValueError(f"주차 기록을 찾을 수 없습니다. (record_id={req.record_id})")
    if record.exit_time is not None:
        raise ValueError("이미 출차된 차량입니다.")

    method = _resolve_method(record, preferred=req.method)
    parking_record_dao.call_exit(record_id=req.record_id, method=method)

    updated = parking_record_dao.find_by_id(req.record_id)
    payment = payment_dao.find_by_record_id(req.record_id)
    if payment is None:
        raise RuntimeError("정산 결과를 찾을 수 없습니다.")

    minutes = int((updated.exit_time - record.entry_time).total_seconds() / 60)

    return {
        "entry_time":      record.entry_time.strftime("%Y-%m-%d %H:%M:%S"),
        "exit_time":       updated.exit_time.strftime("%Y-%m-%d %H:%M:%S"),
        "parking_minutes": minutes,
        "raw_fee":         payment.raw_fee,
        "discount_rate":   float(payment.discount_rate),
        "discount_reason": payment.discount_reason,
        "final_fee":       payment.final_fee,
    }


def find_active_record(plate_number: str) -> ParkingRecordDTO | None:
    return parking_record_dao.find_active_by_plate(plate_number)


# ── 내부 헬퍼 ─────────────────────────────────────────────────────────────────

def _resolve_method(record: ParkingRecordDTO, preferred: str) -> str:
    if record.user_type == "resident":
        return "resident_free"
    if record.user_type == "employee" and season_pass_dao.has_active_pass(record.plate_number):
        return "season_pass"
    return preferred
