import os
import pymysql
from dotenv import load_dotenv

load_dotenv()


def get_connection(role: str = "user"):
    # 로컬: DB_ADMIN_USER / DB_USER 환경변수 사용
    # Railway: MYSQLUSER / MYSQLPASSWORD / MYSQLHOST 등 자동 제공 → 없으면 fallback
    if role == "admin":
        user     = os.getenv("DB_ADMIN_USER") or os.getenv("MYSQLUSER", "parking_admin")
        password = os.getenv("DB_ADMIN_PASSWORD") or os.getenv("MYSQLPASSWORD", "")
    else:
        user     = os.getenv("DB_USER") or os.getenv("MYSQLUSER", "parking_user")
        password = os.getenv("DB_PASSWORD") or os.getenv("MYSQLPASSWORD", "")

    kwargs = dict(
        user         = user,
        password     = password,
        database     = os.getenv("DB_NAME") or os.getenv("MYSQLDATABASE", "parking_db"),
        charset      = "utf8mb4",
        cursorclass  = pymysql.cursors.DictCursor,
        init_command = "SET time_zone = '+09:00'",
    )

    unix_socket = os.getenv("DB_SOCKET", "")
    if unix_socket:
        kwargs["unix_socket"] = unix_socket
    else:
        kwargs["host"] = os.getenv("DB_HOST") or os.getenv("MYSQLHOST", "localhost")
        kwargs["port"] = int(os.getenv("DB_PORT") or os.getenv("MYSQLPORT", 3306))

    return pymysql.connect(**kwargs)
