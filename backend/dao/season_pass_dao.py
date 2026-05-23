from config import get_connection


def has_active_pass(plate_number: str) -> bool:
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT COUNT(*) AS cnt "
                "FROM SeasonPass sp "
                "JOIN DeptEmployee de ON de.employee_id = sp.employee_id "
                "WHERE de.plate_number = %s AND sp.is_active = TRUE",
                (plate_number,),
            )
            row = cur.fetchone()
    finally:
        conn.close()
    return (row["cnt"] > 0) if row else False
