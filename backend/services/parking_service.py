from __future__ import annotations
from config import get_connection
from dto.parking_dto import ParkEnterRequest, ParkExitRequest, ParkingRecordDTO
from dao import parking_record_dao, parking_spot_dao, payment_dao, season_pass_dao


def upsert_vehicle(plate_number: str, is_disabled: bool, is_ev: bool) -> None:
    # 미등록 차량이면 Vehicle에 추가, 이미 있으면 DB 값 그대로 유지
    conn = get_connection(role="admin")
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


def enter(req: ParkEnterRequest) -> None:
    active = parking_record_dao.find_active_by_plate(req.plate_number)
    if active is not None:
        raise ValueError(f"이미 입차된 차량입니다. (plate={req.plate_number})")
    parking_record_dao.call_enter(
        plate_number=req.plate_number,
        spot_id=req.spot_id,
        visit_unit_id=req.visit_unit_id,
        user_type=req.user_type,
    )


def exit_and_pay(req: ParkExitRequest) -> dict:
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


def _resolve_method(record: ParkingRecordDTO, preferred: str) -> str:
    # 입주민/정기권 직원은 결제 수단을 강제로 지정, 나머지는 프론트에서 받은 값 사용
    if record.user_type == "resident":
        return "resident_free"
    if record.user_type == "employee" and season_pass_dao.has_active_pass(record.plate_number):
        return "season_pass"
    return preferred
