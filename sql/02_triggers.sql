-- ============================================================
-- parking_db 트리거 (Trigger)
--
-- ▶ 트리거란?
--    특정 테이블에 INSERT / UPDATE / DELETE 가 일어나는 순간
--    자동으로 실행되는 SQL 코드 블록.
--    프로시저를 통하지 않고 직접 SQL 을 날려도 항상 실행되므로
--    "DB 단의 마지막 방어선" 역할을 한다.
--
-- ▶ BEFORE vs AFTER
--    BEFORE : 실제 변경이 DB 에 저장되기 전 실행.
--             NEW.컬럼 을 수정하면 저장될 값을 바꿀 수 있다.
--             SIGNAL 로 오류를 던지면 변경 자체가 취소된다.
--    AFTER  : 변경이 DB 에 저장된 후 실행.
--             다른 테이블을 UPDATE/INSERT 하는 용도로 주로 쓴다.
--
-- ▶ NEW / OLD
--    NEW : 새로 들어오거나 바뀔 행의 값 (INSERT·UPDATE 에서 사용)
--    OLD : 변경되기 전 행의 값 (UPDATE·DELETE 에서 사용)
--
-- ▶ 이 파일에 있는 트리거 목록
--    1. trg_season_pass_expire_insert   : 정기권 INSERT 시 만료 자동 처리
--    2. trg_season_pass_expire_update   : 정기권 UPDATE 시 만료 자동 처리
--    3. trg_spot_occupied_on_enter      : 입차 시 주차 자리 점유 표시
--    4. trg_spot_released_on_exit       : 출차 시 주차 자리 해제
--    5. trg_block_unpaid_resident       : 관리비 미납 입주민 입차 차단
--    6. trg_payment_consistency         : 정산 데이터 일관성 검증
-- ============================================================

USE parking_db;

-- DELIMITER 란?
-- MySQL 은 기본적으로 세미콜론(;)을 문장의 끝으로 인식한다.
-- 트리거·프로시저 안에도 ;이 있어서 충돌이 생기므로,
-- 여기서는 $$ 를 문장 끝으로 바꿔서 혼동을 막는다.
-- 트리거/프로시저를 모두 정의한 뒤 DELIMITER ; 로 원래대로 되돌린다.
DELIMITER $$

-- ============================================================
-- 1. trg_season_pass_expire_insert
--    ▶ SeasonPass 에 새 정기권을 INSERT 할 때 동작
--    ▶ 목적: 이미 만료된 날짜로 정기권을 등록하면 즉시 is_active = FALSE 로 저장
--    ▶ 예시: end_date = '2024-01-01' 이고 오늘이 2026-05-17 이면
--             자동으로 is_active 가 FALSE 가 되어 저장됨
--    ▶ BEFORE INSERT 이므로: SIGNAL 없이 NEW.is_active 를 직접 수정 → 저장값이 바뀜
-- ============================================================
CREATE TRIGGER trg_season_pass_expire_insert
BEFORE INSERT ON SeasonPass   -- SeasonPass 에 INSERT 가 일어나기 직전에 실행
FOR EACH ROW                  -- 삽입되는 행 하나하나마다 실행 (여러 행 삽입 시 반복)
BEGIN
    -- NEW.end_date : 지금 막 삽입하려는 정기권의 만료일
    -- CURDATE()    : 오늘 날짜 (시각 없이 날짜만)
    IF NEW.end_date < CURDATE() THEN
        -- 만료일이 이미 지났으면 is_active 를 FALSE 로 바꿔치기
        SET NEW.is_active = FALSE;
    END IF;
END$$

-- ============================================================
-- 2. trg_season_pass_expire_update
--    ▶ SeasonPass 의 기존 행이 UPDATE 될 때 동작
--    ▶ 목적: end_date 가 변경될 때만 is_active 를 다시 계산
--             (만료일 연장 → 활성화, 만료일 앞당김 → 비활성화)
--    ▶ 왜 end_date 변경 여부를 먼저 체크하나?
--       is_active 같은 다른 컬럼만 바꾸는 UPDATE 에서는
--       is_active 를 강제로 덮어쓰지 않기 위해서.
-- ============================================================
CREATE TRIGGER trg_season_pass_expire_update
BEFORE UPDATE ON SeasonPass   -- SeasonPass UPDATE 직전에 실행
FOR EACH ROW
BEGIN
    -- OLD.end_date : 변경 전 만료일 / NEW.end_date : 변경 후 만료일
    -- end_date 가 실제로 바뀐 경우에만 is_active 를 재계산
    IF NEW.end_date <> OLD.end_date THEN
        IF NEW.end_date < CURDATE() THEN
            SET NEW.is_active = FALSE;  -- 새 만료일이 이미 지났으면 비활성화
        ELSE
            SET NEW.is_active = TRUE;   -- 만료일이 미래면 활성화
        END IF;
    END IF;
END$$

-- ============================================================
-- 3. trg_spot_occupied_on_enter
--    ▶ ParkingRecord 에 새 행이 INSERT 될 때 동작 (= 입차 이벤트)
--    ▶ 목적: 입차 기록이 생기면 해당 주차 자리를 "점유 중(TRUE)"으로 변경
--    ▶ AFTER INSERT: 기록이 먼저 저장된 뒤 ParkingSpot 을 업데이트
--    ▶ exit_time IS NULL 인 경우만 처리하는 이유:
--       더미 데이터처럼 입·출차 시각을 동시에 넣을 때
--       이미 출차된 기록이 자리를 점유 표시하는 것을 막기 위해
-- ============================================================
CREATE TRIGGER trg_spot_occupied_on_enter
AFTER INSERT ON ParkingRecord  -- ParkingRecord INSERT 완료 후 실행
FOR EACH ROW
BEGIN
    -- exit_time 이 NULL 이면 아직 주차 중인 차량
    IF NEW.exit_time IS NULL THEN
        -- 해당 spot 의 is_occupied 를 TRUE 로 변경
        UPDATE ParkingSpot
           SET is_occupied = TRUE
         WHERE spot_id = NEW.spot_id;
    END IF;
END$$

-- ============================================================
-- 4. trg_spot_released_on_exit
--    ▶ ParkingRecord 의 기존 행이 UPDATE 될 때 동작 (= 출차 이벤트)
--    ▶ 목적: exit_time 이 NULL → NOT NULL 로 바뀌는 순간
--             해당 주차 자리를 "비어있음(FALSE)"으로 변경
--    ▶ 왜 OLD·NEW 를 둘 다 비교하나?
--       exit_time 외 다른 컬럼 UPDATE 시에는 자리를 해제하면 안 되기 때문.
--       예) user_type 수정 같은 UPDATE 는 이 조건을 통과하지 못해 무시됨.
-- ============================================================
CREATE TRIGGER trg_spot_released_on_exit
AFTER UPDATE ON ParkingRecord  -- ParkingRecord UPDATE 완료 후 실행
FOR EACH ROW
BEGIN
    -- OLD.exit_time IS NULL     : 방금 전까지 주차 중이었고
    -- NEW.exit_time IS NOT NULL : 이번 UPDATE 로 출차 시각이 기록됐다면
    IF OLD.exit_time IS NULL AND NEW.exit_time IS NOT NULL THEN
        UPDATE ParkingSpot
           SET is_occupied = FALSE
         WHERE spot_id = NEW.spot_id;
    END IF;
END$$

-- ============================================================
-- 5. trg_block_unpaid_resident
--    ▶ ParkingRecord 에 INSERT 할 때 동작 (= 입차 시도 시점)
--    ▶ 목적: 아파트 입주민(user_type = 'resident')이 입차하려 할 때
--             관리비 미납 내역이 있으면 입차 자체를 막는다.
--    ▶ BEFORE INSERT 를 쓰는 이유:
--       SIGNAL 로 오류를 던지면 INSERT 가 취소된다.
--       → sp_park_enter 프로시저를 우회해서 직접 INSERT 해도 차단됨.
--    ▶ 미납 기준: 이번 달 이전(billing_month < 이번달 1일)에 is_paid = FALSE 인 행
--       (당월 미납은 허용 — 당월 치는 말일까지 납부 가능)
-- ============================================================
CREATE TRIGGER trg_block_unpaid_resident
BEFORE INSERT ON ParkingRecord
FOR EACH ROW
BEGIN
    -- 로컬 변수 선언 (트리거 안에서만 유효한 임시 변수)
    DECLARE v_unit_id      INT;   -- 이 차량 소유 입주민의 세대 번호
    DECLARE v_unpaid_count INT;   -- 미납 건수

    -- 입주민 차량일 때만 검사 (직원·방문객·일반은 검사 안 함)
    IF NEW.user_type = 'resident' THEN

        -- ① 이 번호판으로 등록된 입주민의 세대(unit_id)를 찾는다
        SELECT ar.unit_id INTO v_unit_id
          FROM AptResident ar
         WHERE ar.plate_number = NEW.plate_number
         LIMIT 1;

        -- ② 그 세대의 이번 달 이전 미납 건수를 센다
        --    DATE_FORMAT(NEW.entry_time, '%Y-%m-01') : 입차 시각 기준 해당 월의 1일
        --    예) 2026-05-17 09:00 → '2026-05-01'
        --    billing_month < '2026-05-01' → 4월분 이전이 미납이면 차단
        SELECT COUNT(*) INTO v_unpaid_count
          FROM AptMonthlyPayment
         WHERE unit_id       = v_unit_id
           AND is_paid       = FALSE
           AND billing_month < DATE_FORMAT(NEW.entry_time, '%Y-%m-01');

        -- ③ 미납이 하나라도 있으면 오류를 던져 INSERT 를 취소
        --    SQLSTATE '45000' : 사용자 정의 예외를 나타내는 표준 코드
        IF v_unpaid_count > 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = '관리비 미납 세대는 입차할 수 없습니다.';
        END IF;
    END IF;
END$$

-- ============================================================
-- 6. trg_payment_consistency
--    ▶ Payment 에 INSERT 할 때 동작
--    ▶ 목적: 할인 사유(discount_reason)·할인율(discount_rate)·최종 금액(final_fee)
--             세 값이 서로 수학적으로 일치하지 않으면 저장을 거부한다.
--    ▶ 검증 규칙
--       none          → discount_rate 반드시 0.00
--       disabled      → discount_rate 반드시 0.50
--       season_pass   → discount_rate 반드시 1.00
--       resident_free → discount_rate 반드시 1.00
--       final_fee     = CEIL(raw_fee * (1 - discount_rate)) 와 일치해야 함
--    ▶ sp_park_exit 프로시저를 통하지 않고 Payment 를 직접 INSERT 해도
--       이 트리거가 모순된 데이터를 막아준다.
-- ============================================================
CREATE TRIGGER trg_payment_consistency
BEFORE INSERT ON Payment
FOR EACH ROW
BEGIN
    -- 할인 사유와 할인율 조합이 규칙에 맞지 않으면 오류
    IF (NEW.discount_reason = 'none'          AND NEW.discount_rate <> 0.00)
    OR (NEW.discount_reason = 'disabled'      AND NEW.discount_rate <> 0.50)
    OR (NEW.discount_reason = 'season_pass'   AND NEW.discount_rate <> 1.00)
    OR (NEW.discount_reason = 'resident_free' AND NEW.discount_rate <> 1.00) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'discount_reason 과 discount_rate 가 일치하지 않습니다.';
    END IF;

    -- final_fee 가 계산 공식과 다르면 오류
    -- CEIL(x) : x 를 올림. 예) CEIL(9000 * 0.5) = CEIL(4500) = 4500
    --                           CEIL(9001 * 0.5) = CEIL(4500.5) = 4501
    IF NEW.final_fee <> CEIL(NEW.raw_fee * (1 - NEW.discount_rate)) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'final_fee 가 계산식과 일치하지 않습니다.';
    END IF;
END$$

-- 구분자를 다시 세미콜론으로 되돌린다
DELIMITER ;
