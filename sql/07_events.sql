USE parking_db;

-- 이벤트 스케줄러 활성화 (my.cnf 에 event_scheduler=ON 설정 권장)
SET GLOBAL event_scheduler = ON;

DELIMITER $$

-- 매일 자정, 만료된 정기권 일괄 비활성화
-- 트리거는 INSERT/UPDATE 시에만 동작하므로 방치된 정기권은 이 이벤트가 처리
CREATE EVENT IF NOT EXISTS ev_season_pass_daily_expire
ON SCHEDULE EVERY 1 DAY
STARTS (CURRENT_DATE + INTERVAL 1 DAY)
DO
BEGIN
    UPDATE SeasonPass
       SET is_active = FALSE
     WHERE end_date < CURDATE()
       AND is_active = TRUE;
END$$

DELIMITER ;
