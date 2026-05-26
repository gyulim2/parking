from flask import jsonify


def ok(data):
    return jsonify({"ok": True, "data": data})


def err(msg, status=400):
    return jsonify({"ok": False, "error": msg}), status
