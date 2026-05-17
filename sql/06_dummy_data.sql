-- ============================================================
-- parking_db 더미 데이터
-- ============================================================

USE parking_db;

-- ============================================================
-- 1. ParkingLot  (2개)
-- ============================================================
INSERT INTO ParkingLot (lot_id, name, lot_type) VALUES
    (1, 'A 백화점 주차장', 'department'),
    (2, 'B 아파트 주차장', 'apartment');

-- ============================================================
-- 2. ParkingSpot  (각 주차장 15개, 총 30개)
-- ============================================================
-- A 백화점 (lot_id=1): B1·B2층, A·B·C 구역
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
-- 3. Vehicle  (10개)
-- ============================================================
INSERT INTO Vehicle (plate_number, is_disabled, is_ev) VALUES
    ('12가3456', FALSE, FALSE),  -- 일반 (백화점 직원)
    ('34나5678', FALSE, FALSE),  -- 일반 (백화점 직원)
    ('56다7890', FALSE, TRUE),   -- 전기차 (백화점 직원)
    ('78라1234', FALSE, FALSE),  -- 일반 (아파트 입주민)
    ('90마5678', FALSE, TRUE),   -- 전기차 (아파트 입주민)
    ('11바9012', TRUE,  FALSE),  -- 장애인 (아파트 입주민)
    ('22사3456', FALSE, FALSE),  -- 일반 (일반 방문객)
    ('33아7890', FALSE, FALSE),  -- 일반 (일반 방문객)
    ('44자1234', TRUE,  FALSE),  -- 장애인 (일반 방문객)
    ('55차5678', FALSE, TRUE);   -- 전기차 (일반 방문객)

-- ============================================================
-- 4. DeptEmployee  (3명)
-- ============================================================
INSERT INTO DeptEmployee (employee_id, plate_number, lot_id) VALUES
    (1, '12가3456', 1),
    (2, '34나5678', 1),
    (3, '56다7890', 1);

-- ============================================================
-- 5. SeasonPass  (3개: active 2, expired 1)
--    lot_id 컬럼 제거됨
-- ============================================================
INSERT INTO SeasonPass (employee_id, start_date, end_date, is_active, monthly_fee) VALUES
    (1, '2025-01-01', '2026-06-30', TRUE,  100000),  -- 유효
    (2, '2025-03-01', '2026-05-31', TRUE,  100000),  -- 유효
    (3, '2024-01-01', '2024-12-31', FALSE, 100000);  -- 만료

-- ============================================================
-- 6. AptUnit  (세대 3개)
-- ============================================================
INSERT INTO AptUnit (unit_id, lot_id, unit_number) VALUES
    (1, 2, '101동 501호'),
    (2, 2, '102동 301호'),
    (3, 2, '103동 201호');

-- ============================================================
-- 7. AptResident  (3명)
--    unit_number(자유문자) → unit_id(FK)
-- ============================================================
INSERT INTO AptResident (resident_id, plate_number, unit_id) VALUES
    (1, '78라1234', 1),
    (2, '90마5678', 2),
    (3, '11바9012', 3);

-- ============================================================
-- 8. AptMonthlyPayment  (3세대 × 2개월)
-- ============================================================
INSERT INTO AptMonthlyPayment (unit_id, billing_month, is_paid) VALUES
    (1, '2026-04-01', TRUE),
    (1, '2026-05-01', TRUE),
    (2, '2026-04-01', TRUE),
    (2, '2026-05-01', TRUE),
    (3, '2026-04-01', TRUE),
    (3, '2026-05-01', FALSE);  -- 미납 세대 예시

-- ============================================================
-- 9. ParkingRecord  (10개: 완료 8, 주차 중 2)
--    resident_id 제거, visit_unit_id 추가
--    is_occupied 동기화는 트리거가 처리하므로 수동 UPDATE 없음
-- ============================================================
INSERT INTO ParkingRecord
    (record_id, plate_number, spot_id, visit_unit_id, user_type, entry_time, exit_time)
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
    -- 트리거(trg_spot_occupied_on_enter)가 is_occupied = TRUE 처리
    (9,  '33아7890',  7, NULL, 'general',  '2026-05-13 09:00:00', NULL),
    (10, '55차5678', 13,    1, 'visitor',  '2026-05-13 10:30:00', NULL);

-- ============================================================
-- 10. Payment  (완료된 8개 기록에 대해)
-- ============================================================
-- 요금 기준: 30분당 3,000원, 올림 적용
-- 우선순위: season_pass > resident_free > disabled > none

INSERT INTO Payment
    (payment_id, record_id, raw_fee, discount_rate, discount_reason, final_fee, method)
VALUES
    -- record 1: employee 12가3456, 9시간 → 18단위 × 3000 = 54000 → 정기권 무료
    (1, 1, 54000, 1.00, 'season_pass',   0, 'season_pass'),
    -- record 2: employee 34나5678, 9시간
    (2, 2, 54000, 1.00, 'season_pass',   0, 'season_pass'),
    -- record 3: employee 56다7890, 9시간 → 정기권 만료(2024-12-31)이므로 정가 정산
    (3, 3, 54000, 0.00, 'none',      54000, 'card'),
    -- record 4: resident 78라1234, 12시간 → 무료
    (4, 4, 72000, 1.00, 'resident_free', 0, 'resident_free'),
    -- record 5: resident 90마5678, 13.17시간 ≈ 27단위 × 3000 = 81000 → 무료
    (5, 5, 81000, 1.00, 'resident_free', 0, 'resident_free'),
    -- record 6: resident 11바9012 (장애인 입주민), 5시간 → resident_free 우선
    (6, 6, 30000, 1.00, 'resident_free', 0, 'resident_free'),
    -- record 7: general 22사3456, 2.5시간 → 5단위 × 3000 = 15000 → 정가
    (7, 7, 15000, 0.00, 'none',      15000, 'card'),
    -- record 8: general 44자1234 (장애인), 1시간 → 2단위 × 3000 = 6000 → 50% 할인
    (8, 8,  6000, 0.50, 'disabled',   3000, 'card');
