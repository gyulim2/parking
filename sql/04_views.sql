-- ============================================================
-- parking_db 뷰
-- ============================================================

USE parking_db;

-- ============================================================
-- v_hourly_congestion : 시간대별 주차장 혼잡도 분석
--    입차 시각을 1시간 단위로 집계
--    각 시간대에 입차한 차량 수를 주차장별로 확인
-- ============================================================
CREATE OR REPLACE VIEW v_hourly_congestion AS
SELECT
    ps.lot_id,
    pl.name                                       AS lot_name,
    DATE(pr.entry_time)                           AS entry_date,
    HOUR(pr.entry_time)                           AS entry_hour,
    COUNT(*)                                      AS entry_count
FROM ParkingRecord pr
JOIN ParkingSpot   ps ON ps.spot_id = pr.spot_id
JOIN ParkingLot    pl ON pl.lot_id  = ps.lot_id
GROUP BY
    ps.lot_id,
    pl.name,
    DATE(pr.entry_time),
    HOUR(pr.entry_time);
