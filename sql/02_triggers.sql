USE parking_db;

DELIMITER $$

-- 정기권 INSERT 시 이미 만료된 날짜면 is_active = FALSE 로 저장
CREATE TRIGGER trg_season_pass_expire_insert
BEFORE INSERT ON SeasonPass
FOR EACH ROW
BEGIN
    IF NEW.end_date < CURDATE() THEN
        SET NEW.is_active = FALSE;
    END IF;
END$$

-- 정기권 end_date 변경 시 is_active 재계산
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

-- 입차 시 해당 자리 점유 표시
-- exit_time이 NULL일 때만 처리 (더미데이터처럼 입출차를 한 번에 넣으면 오작동하기 때문)
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

-- 출차 시 자리 해제 (exit_time이 NULL에서 값으로 바뀌는 순간에만)
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

-- 관리비 미납 입주민 입차 차단
-- 당월 미납은 허용, 전월 이전 미납이 있으면 입차 거부
CREATE TRIGGER trg_block_unpaid_resident
BEFORE INSERT ON ParkingRecord
FOR EACH ROW
BEGIN
    DECLARE v_unit_id      INT;
    DECLARE v_unpaid_count INT;
    DECLARE v_this_month   DATE;

    IF NEW.user_type = 'resident' THEN

        SELECT ar.unit_id INTO v_unit_id
          FROM AptResident ar
         WHERE ar.plate_number = NEW.plate_number
         LIMIT 1;

        SET v_this_month = DATE_FORMAT(NEW.entry_time, '%Y-%m-01');

        SELECT COUNT(*) INTO v_unpaid_count
          FROM AptMonthlyPayment
         WHERE unit_id       = v_unit_id
           AND is_paid       = FALSE
           AND billing_month < v_this_month;

        IF v_unpaid_count > 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = '관리비 미납 세대는 입차할 수 없습니다.';
        END IF;
    END IF;
END$$

-- 같은 번호판이 이미 주차 중이면 재입차 차단
CREATE TRIGGER trg_no_double_entry
BEFORE INSERT ON ParkingRecord
FOR EACH ROW
BEGIN
    DECLARE v_active INT;

    SELECT COUNT(*) INTO v_active
      FROM ParkingRecord
     WHERE plate_number = NEW.plate_number
       AND exit_time IS NULL;

    IF v_active > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '이미 주차 중인 차량입니다.';
    END IF;
END$$

-- 정산 데이터 일관성 검증
-- discount_reason, discount_rate, final_fee 세 값이 안 맞으면 저장 거부
CREATE TRIGGER trg_payment_consistency
BEFORE INSERT ON Payment
FOR EACH ROW
BEGIN
    DECLARE v_expected_rate DECIMAL(3,2);
    DECLARE v_expected_fee  INT;

    IF NEW.discount_reason = 'none' THEN
        SET v_expected_rate = 0.00;
    ELSEIF NEW.discount_reason = 'disabled' THEN
        SET v_expected_rate = 0.50;
    ELSE
        SET v_expected_rate = 1.00;
    END IF;

    IF NEW.discount_rate <> v_expected_rate THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'discount_reason 과 discount_rate 가 일치하지 않습니다.';
    END IF;

    SET v_expected_fee = CEIL(NEW.raw_fee * (1 - NEW.discount_rate));
    IF NEW.final_fee <> v_expected_fee THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'final_fee 가 계산식과 일치하지 않습니다.';
    END IF;
END$$

DELIMITER ;
