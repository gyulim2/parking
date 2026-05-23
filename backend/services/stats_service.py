from __future__ import annotations
from config import get_connection

_DOW = {1: "일", 2: "월", 3: "화", 4: "수", 5: "목", 6: "금", 7: "토"}


def _lot_condition(lot_id):
    if lot_id is not None:
        return "AND ps.lot_id = %s", (lot_id,)
    return "", ()


def get_revenue_today(lot_id=None) -> dict:
    cond, params = _lot_condition(lot_id)
    sql = f"""
        SELECT COALESCE(SUM(p.final_fee), 0) AS total
        FROM Payment p
        JOIN ParkingRecord pr ON pr.record_id = p.record_id
        JOIN ParkingSpot   ps ON ps.spot_id   = pr.spot_id
        WHERE DATE(pr.exit_time) = CURDATE() {cond}
    """
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(sql, params)
            row = cur.fetchone()
    finally:
        conn.close()
    return {"lot_id": lot_id, "total": int(row["total"])}


def get_revenue_week(lot_id=None) -> list[dict]:
    cond, params = _lot_condition(lot_id)
    sql = f"""
        SELECT DAYOFWEEK(pr.exit_time) AS dow,
               COALESCE(SUM(p.final_fee), 0) AS total
        FROM Payment p
        JOIN ParkingRecord pr ON pr.record_id = p.record_id
        JOIN ParkingSpot   ps ON ps.spot_id   = pr.spot_id
        WHERE YEARWEEK(pr.exit_time, 1) = YEARWEEK(CURDATE(), 1) {cond}
        GROUP BY dow ORDER BY dow
    """
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(sql, params)
            rows = cur.fetchall()
    finally:
        conn.close()
    return [{"weekday": _DOW[r["dow"]], "total": int(r["total"])} for r in rows]


def get_revenue_month(lot_id=None) -> list[dict]:
    cond, params = _lot_condition(lot_id)
    sql = f"""
        SELECT WEEK(pr.exit_time) - WEEK(DATE_FORMAT(pr.exit_time, '%Y-%m-01')) + 1 AS week,
               COALESCE(SUM(p.final_fee), 0) AS total
        FROM Payment p
        JOIN ParkingRecord pr ON pr.record_id = p.record_id
        JOIN ParkingSpot   ps ON ps.spot_id   = pr.spot_id
        WHERE DATE_FORMAT(pr.exit_time, '%Y-%m') = DATE_FORMAT(CURDATE(), '%Y-%m') {cond}
        GROUP BY week ORDER BY week
    """
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(sql, params)
            rows = cur.fetchall()
    finally:
        conn.close()
    return [{"week": int(r["week"]), "total": int(r["total"])} for r in rows]


def get_revenue_compare() -> list[dict]:
    sql = """
        SELECT ps.lot_id, pl.name AS lot_name,
               COALESCE(SUM(p.final_fee), 0) AS total
        FROM Payment p
        JOIN ParkingRecord pr ON pr.record_id = p.record_id
        JOIN ParkingSpot   ps ON ps.spot_id   = pr.spot_id
        JOIN ParkingLot    pl ON pl.lot_id    = ps.lot_id
        GROUP BY ps.lot_id, pl.name ORDER BY ps.lot_id
    """
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(sql)
            rows = cur.fetchall()
    finally:
        conn.close()
    return [{"lot_id": r["lot_id"], "lot_name": r["lot_name"], "total": int(r["total"])} for r in rows]


def get_congestion(lot_id: int) -> list[dict]:
    """v_hourly_congestion 뷰에서 lot_id별 시간대 집계"""
    sql = """
        SELECT entry_hour AS hour, SUM(entry_count) AS entry_count
        FROM v_hourly_congestion
        WHERE lot_id = %s
        GROUP BY entry_hour ORDER BY entry_hour
    """
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(sql, (lot_id,))
            rows = cur.fetchall()
    finally:
        conn.close()
    return [{"hour": r["hour"], "entry_count": int(r["entry_count"])} for r in rows]


def get_revenue_by_reason(lot_id=None) -> list[dict]:
    cond, params = _lot_condition(lot_id)
    sql = f"""
        SELECT p.discount_reason AS reason,
               COUNT(*) AS count,
               COALESCE(SUM(p.raw_fee - p.final_fee), 0) AS total_saved,
               COALESCE(SUM(p.final_fee), 0) AS total
        FROM Payment p
        JOIN ParkingRecord pr ON pr.record_id = p.record_id
        JOIN ParkingSpot   ps ON ps.spot_id   = pr.spot_id
        WHERE 1=1 {cond}
        GROUP BY p.discount_reason
    """
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(sql, params)
            rows = cur.fetchall()
    finally:
        conn.close()
    return [
        {
            "reason":      r["reason"],
            "count":       int(r["count"]),
            "total_saved": int(r["total_saved"]),
            "total":       int(r["total"]),
        }
        for r in rows
    ]


def get_records(lot_id=None, status=None) -> list[dict]:
    conditions = ["1=1"]
    params = []
    if lot_id is not None:
        conditions.append("ps.lot_id = %s")
        params.append(lot_id)
    if status == "active":
        conditions.append("pr.exit_time IS NULL")
    elif status == "exited":
        conditions.append("pr.exit_time IS NOT NULL")

    sql = f"""
        SELECT pr.record_id, pr.plate_number,
               pl.name AS lot_name, pr.spot_id, pr.user_type,
               pr.entry_time, pr.exit_time,
               TIMESTAMPDIFF(MINUTE, pr.entry_time, pr.exit_time) AS parking_minutes
        FROM ParkingRecord pr
        JOIN ParkingSpot ps ON ps.spot_id = pr.spot_id
        JOIN ParkingLot  pl ON pl.lot_id  = ps.lot_id
        WHERE {" AND ".join(conditions)}
        ORDER BY pr.record_id DESC
        LIMIT 200
    """
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(sql, params)
            rows = cur.fetchall()
    finally:
        conn.close()

    for r in rows:
        if r["entry_time"]:
            r["entry_time"] = r["entry_time"].strftime("%Y-%m-%d %H:%M:%S")
        if r["exit_time"]:
            r["exit_time"] = r["exit_time"].strftime("%Y-%m-%d %H:%M:%S")
    return rows


def get_payments(lot_id=None, date=None) -> list[dict]:
    conditions = ["1=1"]
    params = []
    if lot_id is not None:
        conditions.append("ps.lot_id = %s")
        params.append(lot_id)
    if date is not None:
        conditions.append("DATE(pr.exit_time) = %s")
        params.append(date)

    sql = f"""
        SELECT p.payment_id, p.record_id, pr.plate_number,
               pr.entry_time, pr.exit_time,
               p.raw_fee, p.discount_rate, p.discount_reason, p.final_fee, p.method
        FROM Payment p
        JOIN ParkingRecord pr ON pr.record_id = p.record_id
        JOIN ParkingSpot   ps ON ps.spot_id   = pr.spot_id
        WHERE {" AND ".join(conditions)}
        ORDER BY p.payment_id DESC
    """
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(sql, params)
            rows = cur.fetchall()
    finally:
        conn.close()

    for r in rows:
        if r["entry_time"]:
            r["entry_time"] = r["entry_time"].strftime("%Y-%m-%d %H:%M:%S")
        if r["exit_time"]:
            r["exit_time"] = r["exit_time"].strftime("%Y-%m-%d %H:%M:%S")
        r["discount_rate"] = float(r["discount_rate"])
    return rows
