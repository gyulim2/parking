import os
from flask import Flask, send_from_directory
from dotenv import load_dotenv

load_dotenv()

from controllers.parking_controller import bp as parking_bp
from controllers.stats_controller   import bp as admin_bp

FRONTEND_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "frontend")

app = Flask(__name__, static_folder=FRONTEND_DIR, static_url_path="")
app.secret_key = os.getenv("FLASK_SECRET_KEY", "dev-secret")

app.register_blueprint(parking_bp)
app.register_blueprint(admin_bp)


@app.route("/")
def index():
    return app.send_static_file("index.html")


@app.route("/<path:path>")
def static_files(path):
    return send_from_directory(FRONTEND_DIR, path)


if __name__ == "__main__":
    app.run(debug=True, port=5000)
