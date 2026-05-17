-- ============================================================
-- parking_db 인덱스
-- ============================================================

USE parking_db;

-- ParkingRecord: 차량별 입출차 이력 조회
CREATE INDEX idx_pr_plate       ON ParkingRecord (plate_number);

-- ParkingRecord: 시간대별 집계 (v_hourly_congestion 뷰 지원)
CREATE INDEX idx_pr_entry_time  ON ParkingRecord (entry_time);

-- ParkingRecord: 현재 주차 중인 차량 조회 (exit_time IS NULL 필터)
CREATE INDEX idx_pr_exit_null   ON ParkingRecord (exit_time);

-- ParkingSpot: 주차장별 종류별 빈 자리 조회
CREATE INDEX idx_ps_lot_occupied ON ParkingSpot (lot_id, spot_type, is_occupied);

-- ParkingSpot: 주차장 + 층 + 구역 조합 조회
CREATE INDEX idx_ps_lot_floor_zone ON ParkingSpot (lot_id, floor, zone);

-- SeasonPass: 직원별 유효 정기권 빠른 조회
CREATE INDEX idx_sp_employee_active ON SeasonPass (employee_id, is_active);

-- AptMonthlyPayment: 세대별 납부 현황 조회
CREATE INDEX idx_amp_unit_paid ON AptMonthlyPayment (unit_id, is_paid);

-- Payment: 정산 수단별 집계
CREATE INDEX idx_pay_method ON Payment (method);
