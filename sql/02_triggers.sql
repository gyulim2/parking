USE parking_db;
DELIMITER $$

-- 만료일이 이미 지난 정기권은 INSERT 시 즉시 비활성화
CREATE TRIGGER trg_season_pass_expire_insert
BEFORE INSERT ON SeasonPass
FOR EACH ROW
BEGIN
    IF NEW.end_date < CURDATE() THEN
        SET NEW.is_active = FALSE;
    END IF;
END$$

-- end_date 변경 시에만 is_active 재계산
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

-- 입차 기록 생성 시 주차 자리 점유 처리
-- exit_time IS NULL 조건: 입·출차 동시 삽입(더미 데이터)인 경우 점유 표시 안 함
CREATE TRIGGER trg_spot_occupied_on_enter
AFTER INSERT ON ParkingRecord
FOR EACH ROW
BEGIN
    IF NEW.exit_time IS NULL THEN
        UPDATE ParkingSpot SET is_occupied = TRUE WHERE spot_id = NEW.spot_id;
    END IF;
END$$

-- exit_time 이 NULL → NOT NULL 로 바뀌는 순간만 자리 해제
CREATE TRIGGER trg_spot_released_on_exit
AFTER UPDATE ON ParkingRecord
FOR EACH ROW
BEGIN
    IF OLD.exit_time IS NULL AND NEW.exit_time IS NOT NULL THEN
        UPDATE ParkingSpot SET is_occupied = FALSE WHERE spot_id = NEW.spot_id;
    END IF;
END$$

-- 입주민 입차 시 이전 달 미납 관리비 있으면 차단
CREATE TRIGGER trg_block_unpaid_resident
BEFORE INSERT ON ParkingRecord
FOR EACH ROW
BEGIN
    DECLARE v_unit_id      INT;
    DECLARE v_unpaid_count INT;

    IF NEW.user_type = 'resident' THEN
        SELECT unit_id INTO v_unit_id
          FROM AptResident WHERE plate_number = NEW.plate_number LIMIT 1;

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

-- discount_reason·discount_rate·final_fee 세 값의 일관성 검증
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
