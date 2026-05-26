USE parking_db;

-- 현재 주차 중인 차량 현황
CREATE OR REPLACE VIEW v_current_parked AS
SELECT
    pr.record_id,
    pr.plate_number,
    pl.lot_id,
    pl.name AS lot_name,
    pr.spot_id,
    ps.floor,
    ps.zone,
    ps.spot_type,
    pr.user_type,
    pr.entry_time,
    TIMESTAMPDIFF(MINUTE, pr.entry_time, NOW()) AS parked_minutes
FROM ParkingRecord pr
JOIN ParkingSpot ps ON ps.spot_id = pr.spot_id
JOIN ParkingLot pl ON pl.lot_id = ps.lot_id
WHERE pr.exit_time IS NULL;


-- 날짜/시간대별 주차장 입차 건수 집계 (혼잡도 분석용)
CREATE OR REPLACE VIEW v_hourly_congestion AS
SELECT
    ps.lot_id,
    pl.name AS lot_name,
    DATE(pr.entry_time) AS entry_date,
    HOUR(pr.entry_time) AS entry_hour,
    COUNT(*) AS entry_count
FROM ParkingRecord pr
JOIN ParkingSpot ps ON ps.spot_id = pr.spot_id
JOIN ParkingLot pl ON pl.lot_id = ps.lot_id
GROUP BY
    ps.lot_id,
    pl.name,
    DATE(pr.entry_time),
    HOUR(pr.entry_time);
