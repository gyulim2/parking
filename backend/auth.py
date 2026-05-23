from functools import wraps
from flask import session, jsonify


def admin_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if "admin_id" not in session:
            return jsonify({"ok": False, "error": "로그인이 필요합니다."}), 401
        return f(*args, **kwargs)
    return decorated
