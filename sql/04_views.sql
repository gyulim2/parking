-- ============================================================
-- parking_db 뷰 (View)
--
-- ▶ 뷰란?
--    복잡한 SELECT 쿼리에 이름을 붙여 저장해둔 것.
--    실제 데이터를 복사해서 가지고 있지 않고,
--    호출할 때마다 원본 테이블에서 실시간으로 데이터를 가져온다.
--    마치 테이블처럼 SELECT * FROM 뷰이름 으로 조회할 수 있다.
--
-- ▶ CREATE OR REPLACE VIEW
--    이미 같은 이름의 뷰가 있으면 덮어쓰고, 없으면 새로 만든다.
--    개발 중 뷰를 수정할 때 DROP 없이 바로 재정의할 수 있어 편리하다.
--
-- ▶ 이 파일에 있는 뷰 목록
--    1. v_hourly_congestion : 시간대별 주차장 혼잡도 분석
-- ============================================================

USE parking_db;

-- ============================================================
-- 1. v_hourly_congestion : 시간대별 주차장 혼잡도 분석
--
--    ▶ 목적
--       각 주차장에서 날짜·시간대별로 입차한 차량 수를 집계한다.
--       "몇 시에 차가 가장 많이 들어오는가?" 를 파악하는 용도.
--       예를 들어 오후 2시~3시에 입차가 몰린다면 그 시간대 전에 직원을 더 배치할 수 있다.
--
--    ▶ 조회 예시
--       SELECT * FROM v_hourly_congestion
--        WHERE lot_id = 1
--          AND entry_date = '2026-05-12'
--        ORDER BY entry_hour;
--
--    ▶ 결과 컬럼 설명
--       lot_id       : 주차장 번호
--       lot_name     : 주차장 이름 (예: 'A 백화점 주차장')
--       entry_date   : 입차 날짜 (예: 2026-05-12)
--       entry_hour   : 입차 시각의 '시' 부분 (0~23)
--       entry_count  : 해당 날짜·시간대에 입차한 총 차량 수
--
--    ▶ 테이블 연결(JOIN) 구조
--       ParkingRecord → ParkingSpot → ParkingLot
--       ParkingRecord 에는 spot_id 만 있고 lot_id 가 없으므로
--       ParkingSpot 을 거쳐 lot_id 를 얻는다.
-- ============================================================
CREATE OR REPLACE VIEW v_hourly_congestion AS
SELECT
    ps.lot_id,                        -- ParkingSpot 을 통해 얻은 주차장 번호

    pl.name                AS lot_name,    -- 주차장 이름 (ParkingLot 에서 가져옴)

    -- DATE(pr.entry_time) : DATETIME 에서 날짜 부분만 추출
    --   예) '2026-05-12 09:30:00' → '2026-05-12'
    DATE(pr.entry_time)    AS entry_date,

    -- HOUR(pr.entry_time) : DATETIME 에서 시(hour) 부분만 추출 (0~23)
    --   예) '2026-05-12 09:30:00' → 9
    HOUR(pr.entry_time)    AS entry_hour,

    -- COUNT(*) : GROUP BY 기준으로 묶인 그룹 안의 행 수 = 해당 시간대 입차 건수
    COUNT(*)               AS entry_count

FROM ParkingRecord pr

-- ParkingRecord.spot_id = ParkingSpot.spot_id 연결
-- → 어느 주차장(lot_id)의 자리인지 알기 위해
JOIN ParkingSpot   ps ON ps.spot_id = pr.spot_id

-- ParkingSpot.lot_id = ParkingLot.lot_id 연결
-- → 주차장 이름(name)을 가져오기 위해
JOIN ParkingLot    pl ON pl.lot_id  = ps.lot_id

-- GROUP BY: 주차장 + 날짜 + 시간대 조합이 같은 행끼리 묶어서 COUNT
-- 이 네 컬럼의 조합이 같으면 같은 그룹 → entry_count 로 집계됨
GROUP BY
    ps.lot_id,
    pl.name,
    DATE(pr.entry_time),
    HOUR(pr.entry_time);
