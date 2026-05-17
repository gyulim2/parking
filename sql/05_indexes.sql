-- ============================================================
-- parking_db 인덱스 (Index)
--
-- ▶ 인덱스란?
--    책의 "색인(찾아보기)"과 같다.
--    인덱스가 없으면 DB 는 조건에 맞는 행을 찾기 위해
--    테이블 전체를 처음부터 끝까지 읽는다 (풀 스캔, Full Table Scan).
--    인덱스가 있으면 특정 컬럼 값들을 미리 정렬해두어서
--    훨씬 빠르게 원하는 행을 찾을 수 있다.
--
-- ▶ 언제 인덱스가 효과적인가?
--    - WHERE 절에 자주 등장하는 컬럼
--    - JOIN 할 때 연결 조건으로 쓰이는 컬럼
--    - ORDER BY / GROUP BY 에 자주 쓰이는 컬럼
--
-- ▶ 인덱스의 단점
--    - INSERT / UPDATE / DELETE 할 때 인덱스도 같이 갱신되므로 약간 느려짐
--    - 인덱스 자체가 디스크 공간을 차지함
--    → 남용하면 오히려 성능이 나빠질 수 있으므로 필요한 것만 만든다.
--
-- ▶ 복합 인덱스 (컬럼 여러 개를 묶은 인덱스)
--    CREATE INDEX idx ON T(a, b, c) 처럼 컬럼 여러 개를 지정하면
--    WHERE a = ? AND b = ? AND c = ? 같은 조건에 효과적이다.
--    단, 순서가 중요: 왼쪽(a)부터 순서대로 조건이 있어야 인덱스가 사용됨.
-- ============================================================

USE parking_db;

-- ============================================================
-- 1. idx_pr_plate
--    ▶ 테이블: ParkingRecord / 컬럼: plate_number
--    ▶ 목적: 특정 차량의 입출차 이력을 조회할 때 빠르게 찾기 위해
--    ▶ 사용 쿼리 예시:
--       SELECT * FROM ParkingRecord WHERE plate_number = '12가3456';
-- ============================================================
CREATE INDEX idx_pr_plate       ON ParkingRecord (plate_number);

-- ============================================================
-- 2. idx_pr_entry_time
--    ▶ 테이블: ParkingRecord / 컬럼: entry_time
--    ▶ 목적: 날짜·시간대별 집계 쿼리 지원 (v_hourly_congestion 뷰에서 사용)
--    ▶ GROUP BY DATE(entry_time), HOUR(entry_time) 시 범위 스캔이 빨라짐
--    ▶ 사용 쿼리 예시:
--       SELECT * FROM ParkingRecord WHERE entry_time >= '2026-05-01';
-- ============================================================
CREATE INDEX idx_pr_entry_time  ON ParkingRecord (entry_time);

-- ============================================================
-- 3. idx_pr_exit_null
--    ▶ 테이블: ParkingRecord / 컬럼: exit_time
--    ▶ 목적: 현재 주차 중인 차량(exit_time IS NULL)만 빠르게 필터링
--    ▶ 사용 쿼리 예시:
--       SELECT * FROM ParkingRecord WHERE exit_time IS NULL;
--       → 지금 주차장에 있는 차량 목록 조회
-- ============================================================
CREATE INDEX idx_pr_exit_null   ON ParkingRecord (exit_time);

-- ============================================================
-- 4. idx_ps_lot_occupied
--    ▶ 테이블: ParkingSpot / 컬럼: lot_id, spot_type, is_occupied (복합)
--    ▶ 목적: "A 주차장의 일반 자리 중 비어있는 자리를 찾아라" 같은 쿼리를 빠르게 처리
--    ▶ 컬럼 순서 의미:
--       lot_id 로 주차장을 먼저 좁히고 → spot_type 으로 유형 필터 → is_occupied 확인
--    ▶ 사용 쿼리 예시:
--       SELECT * FROM ParkingSpot
--        WHERE lot_id = 1 AND spot_type = 'ev' AND is_occupied = FALSE;
--       → A 백화점의 비어있는 전기차 자리 조회
-- ============================================================
CREATE INDEX idx_ps_lot_occupied ON ParkingSpot (lot_id, spot_type, is_occupied);

-- ============================================================
-- 5. idx_ps_lot_floor_zone
--    ▶ 테이블: ParkingSpot / 컬럼: lot_id, floor, zone (복합)
--    ▶ 목적: 특정 주차장의 특정 층·구역 자리를 빠르게 조회
--    ▶ 사용 쿼리 예시:
--       SELECT * FROM ParkingSpot WHERE lot_id = 1 AND floor = -1 AND zone = 'A';
--       → A 백화점 지하 1층 A구역 자리 전체 조회
-- ============================================================
CREATE INDEX idx_ps_lot_floor_zone ON ParkingSpot (lot_id, floor, zone);

-- ============================================================
-- 6. idx_sp_employee_active
--    ▶ 테이블: SeasonPass / 컬럼: employee_id, is_active (복합)
--    ▶ 목적: 특정 직원의 유효한 정기권을 빠르게 찾기 위해
--             sp_park_exit 프로시저에서 출차 시 정기권 유무를 확인할 때 사용됨
--    ▶ 사용 쿼리 예시:
--       SELECT COUNT(*) FROM SeasonPass WHERE employee_id = 1 AND is_active = TRUE;
-- ============================================================
CREATE INDEX idx_sp_employee_active ON SeasonPass (employee_id, is_active);

-- ============================================================
-- 7. idx_amp_unit_paid
--    ▶ 테이블: AptMonthlyPayment / 컬럼: unit_id, is_paid (복합)
--    ▶ 목적: 특정 세대의 미납 여부를 빠르게 확인
--             트리거(trg_block_unpaid_resident)와 sp_park_enter 에서 매 입차마다 사용됨
--    ▶ 사용 쿼리 예시:
--       SELECT COUNT(*) FROM AptMonthlyPayment
--        WHERE unit_id = 3 AND is_paid = FALSE;
-- ============================================================
CREATE INDEX idx_amp_unit_paid ON AptMonthlyPayment (unit_id, is_paid);

-- ============================================================
-- 8. idx_pay_method
--    ▶ 테이블: Payment / 컬럼: method
--    ▶ 목적: 결제 수단별 통계 집계 쿼리를 빠르게 처리
--    ▶ 사용 쿼리 예시:
--       SELECT method, COUNT(*), SUM(final_fee) FROM Payment GROUP BY method;
--       → 결제 수단별 총 건수 및 매출 집계
-- ============================================================
CREATE INDEX idx_pay_method ON Payment (method);
