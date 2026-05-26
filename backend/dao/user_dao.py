from __future__ import annotations
from config import get_connection


def find_by_credentials(user_id: str, plain_password: str) -> dict | None:
    # 비밀번호 해싱은 MySQL에서 처리 (SHA2)
    conn = get_connection(role="user")
    try:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT user_id, role FROM AppUser "
                "WHERE user_id = %s AND pwd_hash = SHA2(%s, 256)",
                (user_id, plain_password),
            )
            return cur.fetchone()
    finally:
        conn.close()
