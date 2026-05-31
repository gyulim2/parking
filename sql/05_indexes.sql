USE parking_db;

-- 이중입차 트리거·번호판 조회 공용: WHERE plate_number = ? AND exit_time IS NULL
CREATE INDEX idx_pr_plate_exit ON ParkingRecord (plate_number, exit_time);
-- 날짜/시간대별 혼잡도 집계용
CREATE INDEX idx_pr_entry_time ON ParkingRecord (entry_time);
-- v_current_parked 뷰: exit_time IS NULL 전체 스캔
CREATE INDEX idx_pr_exit_null ON ParkingRecord (exit_time);

-- 빈 자리 조회: lot_id + spot_type + is_occupied 묶어서
CREATE INDEX idx_ps_lot_occupied ON ParkingSpot (lot_id, spot_type, is_occupied);
CREATE INDEX idx_ps_lot_floor_zone ON ParkingSpot (lot_id, floor, zone);

-- sp_park_exit에서 직원 정기권 확인할 때
CREATE INDEX idx_sp_employee_active ON SeasonPass (employee_id, is_active);

-- 입차 트리거에서 세대 미납 확인할 때
CREATE INDEX idx_amp_unit_paid ON AptMonthlyPayment (unit_id, is_paid);

CREATE INDEX idx_pay_method ON Payment (method);
