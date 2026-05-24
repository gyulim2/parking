from flask import Blueprint, request, jsonify
import pymysql

from dto.parking_dto import ParkEnterRequest, ParkExitRequest
from dao import resident_dao, parking_spot_dao
from services import parking_service

bp = Blueprint("parking", __name__, url_prefix="/api")


def ok(data):
    return jsonify({"ok": True, "data": data})


def err(msg, status=400):
    return jsonify({"ok": False, "error": msg}), status


# ── GET /api/spots?lot_id=1 ───────────────────────────────────────────────────

@bp.route("/spots")
def get_spots():
    lot_id = request.args.get("lot_id", type=int)
    if lot_id is None:
        return err("lot_id는 필수입니다.")
    spots = parking_spot_dao.find_all_by_lot(lot_id)
    for s in spots:
        s["is_occupied"] = bool(s["is_occupied"])
    return ok(spots)


# ── GET /api/vehicle?plate=12가3456 ──────────────────────────────────────────

@bp.route("/vehicle")
def get_vehicle():
    plate = request.args.get("plate", "").strip()
    if not plate:
        return err("plate는 필수입니다.")
    info = resident_dao.find_vehicle_info(plate)
    return ok(info)


# ── GET /api/units?lot_id=2 ───────────────────────────────────────────────────

@bp.route("/units")
def get_units():
    lot_id = request.args.get("lot_id", type=int)
    if lot_id is None:
        return err("lot_id는 필수입니다.")
    units = resident_dao.find_units_by_lot(lot_id)
    return ok(units)


# ── POST /api/park/enter ──────────────────────────────────────────────────────

@bp.route("/park/enter", methods=["POST"])
def enter():
    data         = request.get_json(silent=True) or {}
    plate_number = data.get("plate_number", "").strip()
    spot_id      = data.get("spot_id")
    user_type    = data.get("user_type")
    is_disabled  = bool(data.get("is_disabled", False))
    is_ev        = bool(data.get("is_ev", False))
    visit_unit_id = data.get("visit_unit_id")

    if not plate_number or spot_id is None or not user_type:
        return err("plate_number, spot_id, user_type은 필수입니다.")

    try:
        # 미등록 차량이면 자가신고로 INSERT, 등록 차량이면 DB 값 유지
        parking_service.upsert_vehicle(plate_number, is_disabled, is_ev)

        req = ParkEnterRequest(
            plate_number=plate_number,
            spot_id=int(spot_id),
            user_type=user_type,
            visit_unit_id=visit_unit_id,
        )
        parking_service.enter(req)

        # 방금 생성된 record_id 조회
        record = parking_service.find_active_record(plate_number)
        return ok({"record_id": record.record_id if record else None})

    except ValueError as e:
        return err(str(e))
    except pymysql.err.OperationalError as e:
        return err(e.args[1], 400)


# ── POST /api/park/exit ───────────────────────────────────────────────────────

@bp.route("/park/exit", methods=["POST"])
def exit_and_pay():
    data      = request.get_json(silent=True) or {}
    record_id = data.get("record_id")
    method    = data.get("method", "card")

    if record_id is None:
        return err("record_id는 필수입니다.")

    try:
        req    = ParkExitRequest(record_id=int(record_id), method=method)
        result = parking_service.exit_and_pay(req)
        return ok(result)

    except ValueError as e:
        return err(str(e))
    except pymysql.err.OperationalError as e:
        return err(e.args[1], 400)


# ── GET /api/records/active?plate_number=12가3456 ────────────────────────────

@bp.route("/records/active")
def get_active():
    plate = request.args.get("plate_number", "").strip()
    if not plate:
        return err("plate_number는 필수입니다.")

    record = parking_service.find_active_record(plate)
    if record is None:
        return err("현재 주차 중인 차량이 아닙니다.", 404)

    return ok({
        "record_id":  record.record_id,
        "spot_id":    record.spot_id,
        "user_type":  record.user_type,
        "entry_time": record.entry_time.strftime("%Y-%m-%d %H:%M:%S"),
    })
