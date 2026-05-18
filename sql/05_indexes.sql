USE parking_db;

-- 차량별 입출차 이력 조회
CREATE INDEX idx_pr_plate          ON ParkingRecord (plate_number);
-- 날짜·시간대 집계 (v_hourly_congestion)
CREATE INDEX idx_pr_entry_time     ON ParkingRecord (entry_time);
-- 현재 주차 중인 차량 필터 (exit_time IS NULL)
CREATE INDEX idx_pr_exit_null      ON ParkingRecord (exit_time);

-- 주차장·유형별 빈 자리 조회
CREATE INDEX idx_ps_lot_occupied   ON ParkingSpot (lot_id, spot_type, is_occupied);
-- 특정 층·구역 자리 조회
CREATE INDEX idx_ps_lot_floor_zone ON ParkingSpot (lot_id, floor, zone);

-- 출차 시 직원 정기권 유효 여부 확인 (sp_park_exit)
CREATE INDEX idx_sp_employee_active ON SeasonPass (employee_id, is_active);

-- 입차 시 세대 미납 여부 확인 (트리거·sp_park_enter)
CREATE INDEX idx_amp_unit_paid     ON AptMonthlyPayment (unit_id, is_paid);

-- 결제 수단별 통계
CREATE INDEX idx_pay_method        ON Payment (method);
