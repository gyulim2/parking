USE parking_db;

-- 특정 차량 입출차 이력 조회
CREATE INDEX idx_pr_plate        ON ParkingRecord (plate_number);
-- 날짜·시간대별 집계 (v_hourly_congestion)
CREATE INDEX idx_pr_entry_time   ON ParkingRecord (entry_time);
-- 현재 주차 중인 차량 조회 (exit_time IS NULL)
CREATE INDEX idx_pr_exit_null    ON ParkingRecord (exit_time);

-- 빈 자리 조회: 주차장 + 자리유형 + 점유여부
CREATE INDEX idx_ps_lot_occupied   ON ParkingSpot (lot_id, spot_type, is_occupied);
-- 층·구역별 자리 조회
CREATE INDEX idx_ps_lot_floor_zone ON ParkingSpot (lot_id, floor, zone);

-- 직원 유효 정기권 조회 (sp_park_exit에서 사용)
CREATE INDEX idx_sp_employee_active ON SeasonPass (employee_id, is_active);

-- 세대 미납 여부 확인 (입차 트리거에서 사용)
CREATE INDEX idx_amp_unit_paid ON AptMonthlyPayment (unit_id, is_paid);

-- 결제 수단별 통계
CREATE INDEX idx_pay_method ON Payment (method);
