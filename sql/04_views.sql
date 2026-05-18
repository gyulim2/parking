USE parking_db;

-- 주차장별 날짜·시간대별 입차 건수 집계
-- ParkingRecord 에 lot_id 가 없어 ParkingSpot 을 경유해 조인
CREATE OR REPLACE VIEW v_hourly_congestion AS
SELECT
    ps.lot_id,
    pl.name              AS lot_name,
    DATE(pr.entry_time)  AS entry_date,
    HOUR(pr.entry_time)  AS entry_hour,
    COUNT(*)             AS entry_count
FROM ParkingRecord pr
JOIN ParkingSpot   ps ON ps.spot_id = pr.spot_id
JOIN ParkingLot    pl ON pl.lot_id  = ps.lot_id
GROUP BY ps.lot_id, pl.name, DATE(pr.entry_time), HOUR(pr.entry_time);
