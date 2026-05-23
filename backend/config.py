import os
import pymysql
from dotenv import load_dotenv

load_dotenv()


def get_connection():
    unix_socket = os.getenv("DB_SOCKET", "")
    kwargs = dict(
        user=os.getenv("DB_USER", "root"),
        password=os.getenv("DB_PASSWORD", ""),
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
