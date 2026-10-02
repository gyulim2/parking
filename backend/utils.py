import re
from flask import jsonify


def ok(data):
    return jsonify({"ok": True, "data": data})


def err(msg, status=400):
    return jsonify({"ok": False, "error": msg}), status


# 번호판: 숫자 2~3 + 한글 1 + 숫자 4 (예: 12가3456, 123가4567). DB의 CHAR_LENGTH 7~9 제약과 맞춘다.
_PLATE_RE = re.compile(r"^\d{2,3}[가-힣]\d{4}$")


def is_valid_plate(plate: str) -> bool:
    return bool(_PLATE_RE.fullmatch(plate or ""))
