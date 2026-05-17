-- ============================================================
-- parking_db 트리거
-- ============================================================

USE parking_db;

DELIMITER $$

-- ============================================================
-- 1. SeasonPass 만료 자동 처리 (INSERT)
--    이미 만료된 날짜로 등록하면 즉시 비활성화
-- ============================================================
CREATE TRIGGER trg_season_pass_expire_insert
BEFORE INSERT ON SeasonPass
FOR EACH ROW
BEGIN
    IF NEW.end_date < CURDATE() THEN
        SET NEW.is_active = FALSE;
    END IF;
END$$

-- ============================================================
-- 2. SeasonPass 만료 자동 처리 (UPDATE)
--    end_date만 변경된 경우에만 is_active 재계산
-- ============================================================
CREATE TRIGGER trg_season_pass_expire_update
BEFORE UPDATE ON SeasonPass
FOR EACH ROW
BEGIN
    IF NEW.end_date <> OLD.end_date THEN
        IF NEW.end_date < CURDATE() THEN
            SET NEW.is_active = FALSE;
        ELSE
            SET NEW.is_active = TRUE;
        END IF;
    END IF;
END$$

-- ============================================================
-- 3. ParkingSpot.is_occupied 자동 동기화 (입차)
--    ParkingRecord INSERT → 해당 spot is_occupied = TRUE
-- ============================================================
CREATE TRIGGER trg_spot_occupied_on_enter
AFTER INSERT ON ParkingRecord
FOR EACH ROW
BEGIN
    IF NEW.exit_time IS NULL THEN
        UPDATE ParkingSpot
           SET is_occupied = TRUE
         WHERE spot_id = NEW.spot_id;
    END IF;
END$$

-- ============================================================
-- 4. ParkingSpot.is_occupied 자동 동기화 (출차)
--    ParkingRecord.exit_time 이 NULL → NOT NULL 로 바뀔 때만 해제
-- ============================================================
CREATE TRIGGER trg_spot_released_on_exit
AFTER UPDATE ON ParkingRecord
FOR EACH ROW
BEGIN
    IF OLD.exit_time IS NULL AND NEW.exit_time IS NOT NULL THEN
        UPDATE ParkingSpot
           SET is_occupied = FALSE
         WHERE spot_id = NEW.spot_id;
    END IF;
END$$

-- ============================================================
-- 5. 아파트 입주민 미납 차단 (INSERT)
--    BEFORE INSERT: resident 차량 입차 시 미납 세대면 차단
--    프로시저(sp_park_enter) 우회 INSERT 도 차단하는 DB 단 방어선
-- ============================================================
CREATE TRIGGER trg_block_unpaid_resident
BEFORE INSERT ON ParkingRecord
FOR EACH ROW
BEGIN
    DECLARE v_unit_id      INT;
    DECLARE v_unpaid_count INT;

    IF NEW.user_type = 'resident' THEN
        SELECT ar.unit_id INTO v_unit_id
          FROM AptResident ar
         WHERE ar.plate_number = NEW.plate_number
         LIMIT 1;

        SELECT COUNT(*) INTO v_unpaid_count
          FROM AptMonthlyPayment
         WHERE unit_id       = v_unit_id
           AND is_paid       = FALSE
           AND billing_month < DATE_FORMAT(NEW.entry_time, '%Y-%m-01');

        IF v_unpaid_count > 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = '관리비 미납 세대는 입차할 수 없습니다.';
        END IF;
    END IF;
END$$

-- ============================================================
-- 6. Payment 데이터 일관성 보장 (INSERT)
--    BEFORE INSERT: discount_reason ↔ discount_rate, final_fee 정합성 검증
--    프로시저(sp_park_exit) 우회 INSERT 시 모순 데이터 차단
-- ============================================================
CREATE TRIGGER trg_payment_consistency
BEFORE INSERT ON Payment
FOR EACH ROW
BEGIN
    IF (NEW.discount_reason = 'none'          AND NEW.discount_rate <> 0.00)
    OR (NEW.discount_reason = 'disabled'      AND NEW.discount_rate <> 0.50)
    OR (NEW.discount_reason = 'season_pass'   AND NEW.discount_rate <> 1.00)
    OR (NEW.discount_reason = 'resident_free' AND NEW.discount_rate <> 1.00) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'discount_reason 과 discount_rate 가 일치하지 않습니다.';
    END IF;

    IF NEW.final_fee <> CEIL(NEW.raw_fee * (1 - NEW.discount_rate)) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'final_fee 가 계산식과 일치하지 않습니다.';
    END IF;
END$$

DELIMITER ;
