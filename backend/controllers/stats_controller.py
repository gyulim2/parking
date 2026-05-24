from flask import Blueprint, request, jsonify, session

from auth import admin_required
from dao import user_dao
from services import stats_service

bp = Blueprint("admin", __name__, url_prefix="/api")


def ok(data):
    return jsonify({"ok": True, "data": data})


def err(msg, status=400):
    return jsonify({"ok": False, "error": msg}), status


# ── 인증 ──────────────────────────────────────────────────────────────────────

@bp.route("/admin/login", methods=["POST"])
def login():
    data     = request.get_json(silent=True) or {}
    username = data.get("username", "").strip()
    password = data.get("password", "")

    if not username or not password:
        return err("아이디와 비밀번호를 입력해주세요.", 400)

    user = user_dao.find_by_credentials(username, password)
    if user is None:
        return err("아이디 또는 비밀번호가 일치하지 않습니다.", 401)

    session["admin_id"] = user["user_id"]
    session["username"] = user["user_id"]
    session["role"]     = user["role"]
    return ok({"user_id": user["user_id"], "role": user["role"]})


@bp.route("/admin/logout", methods=["POST"])
@admin_required
def logout():
    session.clear()
    return ok(None)


@bp.route("/admin/me")
@admin_required
def me():
    return ok({"admin_id": session["admin_id"], "username": session["username"]})


# ── 통계 ──────────────────────────────────────────────────────────────────────

@bp.route("/stats/revenue/today")
@admin_required
def revenue_today():
    lot_id = request.args.get("lot_id", type=int)
    return ok(stats_service.get_revenue_today(lot_id))


@bp.route("/stats/revenue/week")
@admin_required
def revenue_week():
    lot_id = request.args.get("lot_id", type=int)
    return ok(stats_service.get_revenue_week(lot_id))


@bp.route("/stats/revenue/month")
@admin_required
def revenue_month():
    lot_id = request.args.get("lot_id", type=int)
    return ok(stats_service.get_revenue_month(lot_id))


@bp.route("/stats/revenue/compare")
@admin_required
def revenue_compare():
    return ok(stats_service.get_revenue_compare())


@bp.route("/stats/congestion")
@admin_required
def congestion():
    lot_id = request.args.get("lot_id", type=int)
    if lot_id is None:
        return err("lot_id는 필수입니다.")
    return ok(stats_service.get_congestion(lot_id))


@bp.route("/stats/revenue/by-reason")
@admin_required
def revenue_by_reason():
    lot_id = request.args.get("lot_id", type=int)
    return ok(stats_service.get_revenue_by_reason(lot_id))


# ── 정산 이력 ─────────────────────────────────────────────────────────────────

@bp.route("/records")
@admin_required
def records():
    lot_id = request.args.get("lot_id", type=int)
    status = request.args.get("status")  # active | exited | None
    return ok(stats_service.get_records(lot_id, status))


@bp.route("/payments")
@admin_required
def payments():
    lot_id = request.args.get("lot_id", type=int)
    date   = request.args.get("date")
    return ok(stats_service.get_payments(lot_id, date))
