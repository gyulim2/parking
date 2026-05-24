from __future__ import annotations
from config import get_connection


def find_by_credentials(user_id: str, plain_password: str) -> dict | None:
    """
    user_id + SHA2(plain_password, 256) 로 AppUser 조회.
    일치하는 행이 있으면 {'user_id': ..., 'role': ...} 반환, 없으면 None.
    비밀번호 해싱은 MySQL이 담당하므로 평문이 Python 메모리에만 머물고 DB에는 절대 안 들어감.
    """
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
