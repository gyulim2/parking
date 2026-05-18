USE parking_db;

SET GLOBAL event_scheduler = ON;

DELIMITER $$

-- 만료된 정기권 일괄 비활성화 (매일 자정 실행)
-- 트리거는 INSERT/UPDATE 시에만 작동하므로 방치된 정기권을 이벤트로 처리
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
