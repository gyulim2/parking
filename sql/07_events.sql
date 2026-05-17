-- ============================================================
-- parking_db 이벤트 스케줄러 (Event Scheduler)
--
-- ▶ 이벤트(Event)란?
--    MySQL 내장 스케줄러 기능. 지정한 시각 또는 주기에
--    자동으로 SQL 코드를 실행시킬 수 있다.
--    리눅스의 cron, 윈도우의 작업 스케줄러와 비슷한 개념.
--
-- ▶ 이벤트 스케줄러가 필요한 이유 (트리거와의 차이)
--    트리거 : 특정 테이블에 INSERT/UPDATE/DELETE 가 일어날 때만 실행됨.
--    이벤트 : 아무 변경이 없어도 "시간이 됐으니" 자동으로 실행됨.
--    → 정기권을 한 번 만들고 그 후 아무도 건드리지 않아도
--      매일 자정에 이벤트가 만료 여부를 일괄 점검한다.
--
-- ▶ 이 파일에 있는 이벤트 목록
--    1. ev_season_pass_daily_expire : 만료된 정기권 일괄 비활성화 (매일 자정)
-- ============================================================

USE parking_db;

-- 이벤트 스케줄러 전역 활성화
-- MySQL 서버 기본값은 OFF 이므로, 이벤트가 실행되려면 반드시 ON 으로 켜야 한다.
-- GLOBAL = MySQL 서버 전체에 적용 (재시작하면 OFF 로 돌아가므로
--          my.cnf 에 event_scheduler=ON 을 설정해두는 것이 일반적)
SET GLOBAL event_scheduler = ON;

DELIMITER $$

-- ============================================================
-- 1. ev_season_pass_daily_expire : 정기권 만료 일배치 작업
--
--    ▶ 목적
--       매일 자정에 만료일(end_date)이 지난 정기권을 일괄 비활성화.
--       트리거(trg_season_pass_expire_insert / trg_season_pass_expire_update)는
--       INSERT·UPDATE 가 발생할 때만 실행되므로,
--       한 번 등록하고 업데이트 없이 방치된 정기권은 자동 만료되지 않는다.
--       이 이벤트가 그 간극을 보완한다.
--
--    ▶ 실행 주기 설명
--       ON SCHEDULE EVERY 1 DAY           : 1일마다 반복
--       STARTS (CURRENT_DATE + INTERVAL 1 DAY) : 내일 자정(00:00:00)부터 시작
--       → 등록 당일은 건너뛰고 다음 날 자정부터 매일 실행됨
--
--    ▶ 실행 내용
--       SeasonPass 테이블에서 아래 두 조건을 모두 만족하는 행을 찾아
--       is_active = FALSE 로 변경:
--         ① end_date < CURDATE() : 만료일이 오늘보다 이전 (이미 지남)
--         ② is_active = TRUE     : 아직 활성 상태인 정기권
--
--    ▶ IF NOT EXISTS
--       같은 이름의 이벤트가 이미 있으면 오류 없이 건너뜀
--       (스크립트를 여러 번 실행해도 충돌하지 않음)
-- ============================================================
CREATE EVENT IF NOT EXISTS ev_season_pass_daily_expire
ON SCHEDULE EVERY 1 DAY
STARTS (CURRENT_DATE + INTERVAL 1 DAY)   -- 내일 자정(00:00:00)부터 매일 실행
DO
BEGIN
    -- end_date 가 오늘보다 이전이고 아직 is_active = TRUE 인 정기권을 일괄 비활성화
    -- 예) 오늘이 2026-05-17 이면 end_date <= 2026-05-16 인 활성 정기권을 모두 끔
    UPDATE SeasonPass
       SET is_active = FALSE
     WHERE end_date < CURDATE()   -- 만료일이 이미 지났고
       AND is_active = TRUE;      -- 아직 활성 상태인 것만 (이미 FALSE 인 것은 건너뜀)
END$$

DELIMITER ;
