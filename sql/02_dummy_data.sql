-- ============================================================
-- parking_db 더미 데이터 (구버전 — 스키마 변경 전)
--
-- ★ 주의: 이 파일은 스키마 리팩토링 이전 버전이다.
--          현재 스키마(01_schema.sql)와 구조가 다른 부분이 있어
--          그대로 실행하면 오류가 발생한다.
--
--  구버전과 현재의 주요 차이점:
--    ① SeasonPass 에 lot_id 컬럼이 있었음 → 현재는 제거됨 (3NF 정규화)
--    ② AptResident 에 lot_id, unit_number 컬럼이 직접 있었음
--       → 현재는 AptUnit 테이블을 별도로 분리하고 unit_id(FK)로 연결
--    ③ ParkingRecord 에 resident_id 컬럼이 있었음 → 현재는 제거됨
--    ④ is_occupied 수동 UPDATE 가 있었음
--       → 현재는 트리거(trg_spot_occupied_on_enter)가 자동 처리
--    ⑤ Payment 에 discount_reason 컬럼이 없었음 → 현재는 추가됨
--
--  현재 사용 중인 더미 데이터는 06_dummy_data.sql 을 참조.
-- ============================================================

USE parking_db;

-- ============================================================
-- 1. ParkingLot  (주차장 2개)
-- ============================================================
INSERT INTO ParkingLot (lot_id, name, lot_type) VALUES
    (1, 'A 백화점 주차장', 'department'),
    (2, 'B 아파트 주차장', 'apartment');

-- ============================================================
-- 2. ParkingSpot  (각 주차장 15개, 총 30개)
--    ▶ spot_id 는 AUTO_INCREMENT 로 1~30 이 자동 부여됨
--    ▶ is_occupied 초기값 FALSE (트리거 없이 수동 UPDATE 로 관리했던 시절)
-- ============================================================
-- A 백화점 (lot_id=1): B1(-1)·B2(-2)층, A·B·C 구역
INSERT INTO ParkingSpot (lot_id, floor, zone, spot_type, is_occupied) VALUES
    -- B1층 A구역
    (1, -1, 'A', 'general',  FALSE),  -- spot_id 1
    (1, -1, 'A', 'general',  FALSE),  -- 2
    (1, -1, 'A', 'general',  FALSE),  -- 3
    (1, -1, 'A', 'disabled', FALSE),  -- 4
    (1, -1, 'A', 'ev',       FALSE),  -- 5
    -- B1층 B구역
    (1, -1, 'B', 'general',  FALSE),  -- 6
    (1, -1, 'B', 'general',  FALSE),  -- 7
    (1, -1, 'B', 'disabled', FALSE),  -- 8
    -- B2층 C구역
    (1, -2, 'C', 'general',  FALSE),  -- 9
    (1, -2, 'C', 'general',  FALSE),  -- 10
    (1, -2, 'C', 'general',  FALSE),  -- 11
    (1, -2, 'C', 'ev',       FALSE),  -- 12
    (1, -2, 'C', 'ev',       FALSE),  -- 13
    (1, -2, 'C', 'disabled', FALSE),  -- 14
    (1, -2, 'C', 'general',  FALSE),  -- 15

-- B 아파트 (lot_id=2): 1·2층, P·Q 구역
    (2,  1, 'P', 'general',  FALSE),  -- 16
    (2,  1, 'P', 'general',  FALSE),  -- 17
    (2,  1, 'P', 'general',  FALSE),  -- 18
    (2,  1, 'P', 'disabled', FALSE),  -- 19
    (2,  1, 'P', 'ev',       FALSE),  -- 20
    (2,  1, 'Q', 'general',  FALSE),  -- 21
    (2,  1, 'Q', 'general',  FALSE),  -- 22
    (2,  1, 'Q', 'general',  FALSE),  -- 23
    (2,  1, 'Q', 'disabled', FALSE),  -- 24
    (2,  2, 'P', 'general',  FALSE),  -- 25
    (2,  2, 'P', 'general',  FALSE),  -- 26
    (2,  2, 'P', 'ev',       FALSE),  -- 27
    (2,  2, 'Q', 'general',  FALSE),  -- 28
    (2,  2, 'Q', 'general',  FALSE),  -- 29
    (2,  2, 'Q', 'ev',       FALSE);  -- 30

-- ============================================================
-- 3. Vehicle  (차량 10개)
-- ============================================================
INSERT INTO Vehicle (plate_number, is_disabled, is_ev) VALUES
    ('12가3456', FALSE, FALSE),
    ('34나5678', FALSE, FALSE),
    ('56다7890', FALSE, TRUE),
    ('78라1234', FALSE, FALSE),
    ('90마5678', FALSE, TRUE),
    ('11바9012', TRUE,  FALSE),
    ('22사3456', FALSE, FALSE),
    ('33아7890', FALSE, FALSE),
    ('44자1234', TRUE,  FALSE),
    ('55차5678', FALSE, TRUE);

-- ============================================================
-- 4. DeptEmployee  (백화점 직원 3명)
-- ============================================================
INSERT INTO DeptEmployee (employee_id, plate_number, lot_id) VALUES
    (1, '12가3456', 1),
    (2, '34나5678', 1),
    (3, '56다7890', 1);

-- ============================================================
-- 5. SeasonPass  (정기권 3개)
--    ★ 구버전: lot_id 컬럼이 존재했음
--       현재 스키마에서는 lot_id 가 없으므로 이 INSERT 는 실행 불가
-- ============================================================
INSERT INTO SeasonPass (employee_id, lot_id, start_date, end_date, is_active, monthly_fee) VALUES
    (1, 1, '2025-01-01', '2026-06-30', TRUE,  100000),  -- 유효
    (2, 1, '2025-03-01', '2026-05-31', TRUE,  100000),  -- 유효
    (3, 1, '2024-01-01', '2024-12-31', FALSE, 100000);  -- 만료

-- ============================================================
-- 6. AptResident  (아파트 입주민 3명)
--    ★ 구버전: lot_id, unit_number 컬럼이 AptResident 에 직접 있었음
--       현재 스키마에서는 AptUnit 을 별도 테이블로 분리하고 unit_id(FK) 를 사용
--       → 이 INSERT 는 현재 스키마에서 실행 불가
-- ============================================================
INSERT INTO AptResident (resident_id, plate_number, lot_id, unit_number) VALUES
    (1, '78라1234', 2, '101동 501호'),
    (2, '90마5678', 2, '102동 301호'),
    (3, '11바9012', 2, '103동 201호');

-- ============================================================
-- 7. ParkingRecord  (입출차 기록 10개)
--    ★ 구버전: resident_id 컬럼이 있었음 (입주민 대납 기능 지원)
--       현재 스키마에서는 resident_id 가 제거됨 → 이 INSERT 는 실행 불가
-- ============================================================
INSERT INTO ParkingRecord
    (record_id, plate_number, spot_id, resident_id, user_type, entry_time, exit_time)
VALUES
    -- 완료된 기록 (8개)
    (1,  '12가3456',  1, NULL, 'employee', '2026-05-12 09:00:00', '2026-05-12 18:00:00'),
    (2,  '34나5678',  2, NULL, 'employee', '2026-05-12 08:30:00', '2026-05-12 17:30:00'),
    (3,  '56다7890',  5, NULL, 'employee', '2026-05-12 09:15:00', '2026-05-12 18:15:00'),
    (4,  '78라1234', 16, NULL, 'resident', '2026-05-12 08:00:00', '2026-05-12 20:00:00'),
    (5,  '90마5678', 20, NULL, 'resident', '2026-05-12 07:50:00', '2026-05-12 21:00:00'),
    (6,  '11바9012', 19, NULL, 'resident', '2026-05-12 10:00:00', '2026-05-12 15:00:00'),
    (7,  '22사3456',  6, NULL, 'general',  '2026-05-12 11:00:00', '2026-05-12 13:30:00'),
    (8,  '44자1234',  8, NULL, 'general',  '2026-05-12 13:00:00', '2026-05-12 14:00:00'),

    -- 주차 중 (2개, exit_time = NULL)
    (9,  '33아7890',  7, NULL, 'general',  '2026-05-13 09:00:00', NULL),
    (10, '55차5678', 13,    1, 'visitor',  '2026-05-13 10:30:00', NULL);

-- ★ 구버전: is_occupied 를 수동으로 UPDATE 했음
--    현재 스키마에서는 트리거(trg_spot_occupied_on_enter)가 자동 처리
UPDATE ParkingSpot SET is_occupied = TRUE WHERE spot_id IN (7, 13);

-- ============================================================
-- 8. Payment  (정산 내역 8건)
--    ★ 구버전: discount_reason 컬럼이 없었고, discount_rate 만 있었음
--       현재 스키마에서는 discount_reason 이 NOT NULL 컬럼으로 추가됨
--       → 이 INSERT 는 현재 스키마에서 실행 불가
-- ============================================================
INSERT INTO Payment
    (payment_id, record_id, raw_fee, discount_rate, final_fee, method)
VALUES
    -- record 1: 직원1, 9시간 → 54000 → 정기권 무료
    (1, 1, 54000, 1.0,   0, 'season_pass'),
    -- record 2: 직원2, 9시간 → 정기권 무료
    (2, 2, 54000, 1.0,   0, 'season_pass'),
    -- record 3: 직원3, 9시간 → 구버전에서는 정기권으로 처리(현재와 다름, 현재는 만료로 정가)
    (3, 3, 54000, 1.0,   0, 'season_pass'),
    -- record 4: 입주민1, 12시간 → 무료
    (4, 4, 72000, 1.0,   0, 'resident_free'),
    -- record 5: 입주민2, 27단위 → 무료
    (5, 5, 81000, 1.0,   0, 'resident_free'),
    -- record 6: 입주민3, 5시간 → 무료
    (6, 6, 30000, 1.0,   0, 'resident_free'),
    -- record 7: 일반 방문객, 2.5시간 → 정가 15000
    (7, 7, 15000, 0.0, 15000, 'card'),
    -- record 8: 장애인 방문객, 1시간 → 50% 할인 → 3000
    (8, 8,  6000, 0.5,  3000, 'card');
