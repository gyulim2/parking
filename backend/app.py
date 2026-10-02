import os
from flask import Flask, send_from_directory
from dotenv import load_dotenv

load_dotenv()

from controllers.parking_controller import bp as parking_bp
from controllers.stats_controller   import bp as admin_bp

FRONTEND_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "frontend")

app = Flask(__name__, static_folder=FRONTEND_DIR, static_url_path="")


def _load_secret_key() -> str:
    """세션 서명 키. 코드에 기본값을 두면 누구나 관리자 세션을 위조할 수 있으므로
    운영에서는 반드시 환경변수로 받는다. 로컬 개발만 APP_ENV=development 로 우회."""
    key = os.getenv("FLASK_SECRET_KEY")
    if key:
        return key
    if os.getenv("APP_ENV") == "development":
        return "dev-only-secret"
    raise RuntimeError("FLASK_SECRET_KEY 환경변수가 필요합니다. (로컬 개발은 APP_ENV=development)")


app.secret_key = _load_secret_key()
app.config.update(
    SESSION_COOKIE_HTTPONLY=True,
    SESSION_COOKIE_SAMESITE="Lax",
    SESSION_COOKIE_SECURE=os.getenv("APP_ENV") != "development",  # HTTPS(Railway)에서만 쿠키 전송
)

app.register_blueprint(parking_bp)
app.register_blueprint(admin_bp)


@app.route("/")
def index():
    return app.send_static_file("index.html")


@app.route("/<path:path>")
def static_files(path):
    return send_from_directory(FRONTEND_DIR, path)


if __name__ == "__main__":
    port = int(os.getenv("PORT", 5001))
    app.run(host="0.0.0.0", port=port, debug=False)
