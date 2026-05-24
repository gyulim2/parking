import os
import pymysql
from dotenv import load_dotenv

load_dotenv()


def get_connection(role: str = "user"):
    """
    role='admin' → parking_admin 계정 (전체 권한)
    role='user'  → parking_user  계정 (SELECT + EXECUTE)
    """
    if role == "admin":
        user     = os.getenv("DB_ADMIN_USER", "parking_admin")
        password = os.getenv("DB_ADMIN_PASSWORD", "")
    else:
        user     = os.getenv("DB_USER", "parking_user")
        password = os.getenv("DB_PASSWORD", "")

    unix_socket = os.getenv("DB_SOCKET", "")
    kwargs = dict(
        user=user,
        password=password,
        database=os.getenv("DB_NAME", "parking_db"),
        charset="utf8mb4",
        cursorclass=pymysql.cursors.DictCursor,
    )
    if unix_socket:
        kwargs["unix_socket"] = unix_socket
    else:
        kwargs["host"] = os.getenv("DB_HOST", "localhost")
        kwargs["port"] = int(os.getenv("DB_PORT", 3306))
    return pymysql.connect(**kwargs)
