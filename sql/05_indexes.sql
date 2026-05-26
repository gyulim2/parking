USE parking_db;

-- 차량 번호로 입출차 이력 찾을 때
CREATE INDEX idx_pr_plate ON ParkingRecord (plate_number);
-- 날짜/시간대별 혼잡도 집계용
CREATE INDEX idx_pr_entry_time ON ParkingRecord (entry_time);
-- 현재 주차 중인 차량 조회 (exit_time IS NULL)
CREATE INDEX idx_pr_exit_null ON ParkingRecord (exit_time);

-- 빈 자리 조회: lot_id + spot_type + is_occupied 묶어서
CREATE INDEX idx_ps_lot_occupied ON ParkingSpot (lot_id, spot_type, is_occupied);
CREATE INDEX idx_ps_lot_floor_zone ON ParkingSpot (lot_id, floor, zone);

-- sp_park_exit에서 직원 정기권 확인할 때
CREATE INDEX idx_sp_employee_active ON SeasonPass (employee_id, is_active);

-- 입차 트리거에서 세대 미납 확인할 때
CREATE INDEX idx_amp_unit_paid ON AptMonthlyPayment (unit_id, is_paid);

CREATE INDEX idx_pay_method ON Payment (method);
