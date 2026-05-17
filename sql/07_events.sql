-- ============================================================
-- parking_db 이벤트 스케줄러
-- ============================================================

USE parking_db;

-- 이벤트 스케줄러 활성화 (서버 단위 설정)
SET GLOBAL event_scheduler = ON;

DELIMITER $$

-- ============================================================
-- ev_season_pass_daily_expire : 정기권 만료 일배치
--    매일 자정 end_date 가 지난 활성 정기권을 일괄 비활성화
--    트리거(trg_season_pass_expire_*) 가 잡지 못하는 케이스 보완
--    (UPDATE 한 번도 일어나지 않은 정기권의 자동 만료 처리)
-- ============================================================
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
