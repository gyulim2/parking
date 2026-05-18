USE parking_db;
DELIMITER $$

-- 입차 처리: 자리 점유 확인 → 입주민 미납 확인 → ParkingRecord INSERT
-- CALL sp_park_enter('12가3456', 3, NULL, 'employee');
-- CALL sp_park_enter('55차5678', 7, 1, 'visitor');
CREATE PROCEDURE sp_park_enter(
    IN p_plate_number  VARCHAR(20),
    IN p_spot_id       INT,
    IN p_visit_unit_id INT,
    IN p_user_type     ENUM('employee', 'resident', 'visitor', 'general')
)
BEGIN
    DECLARE v_is_occupied  BOOLEAN;
    DECLARE v_unit_id      INT;
    DECLARE v_unpaid_count INT;

    SELECT is_occupied INTO v_is_occupied
      FROM ParkingSpot WHERE spot_id = p_spot_id;

    IF v_is_occupied THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '이미 사용 중인 주차 공간입니다.';
    END IF;

    IF p_user_type = 'resident' THEN
        SELECT unit_id INTO v_unit_id
          FROM AptResident WHERE plate_number = p_plate_number LIMIT 1;

        SELECT COUNT(*) INTO v_unpaid_count
          FROM AptMonthlyPayment
         WHERE unit_id       = v_unit_id
           AND is_paid       = FALSE
           AND billing_month < DATE_FORMAT(CURDATE(), '%Y-%m-01');

        IF v_unpaid_count > 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = '관리비 미납 세대는 입차할 수 없습니다.';
        END IF;
    END IF;

    INSERT INTO ParkingRecord (plate_number, spot_id, visit_unit_id, user_type, entry_time)
    VALUES (p_plate_number, p_spot_id, p_visit_unit_id, p_user_type, NOW());
END$$

-- 출차 및 정산 처리: exit_time 기록 → 요금 계산 → Payment INSERT
-- 할인 우선순위: season_pass > resident_free > disabled > none
-- CALL sp_park_exit(9, 'card');
CREATE PROCEDURE sp_park_exit(
    IN p_record_id INT,
    IN p_method    ENUM('season_pass', 'resident_free', 'card', 'cash', 'app')
)
BEGIN
    DECLARE v_plate       VARCHAR(20);
    DECLARE v_user_type   VARCHAR(20);
    DECLARE v_entry_time  DATETIME;
    DECLARE v_exit_time   DATETIME;
    DECLARE v_minutes     INT;
    DECLARE v_raw_fee     INT;
    DECLARE v_rate        DECIMAL(3,2);
    DECLARE v_reason      VARCHAR(20);
    DECLARE v_final_fee   INT;
    DECLARE v_is_disabled BOOLEAN;
    DECLARE v_pass_active INT;

    SELECT plate_number, user_type, entry_time
      INTO v_plate, v_user_type, v_entry_time
      FROM ParkingRecord WHERE record_id = p_record_id;

    SET v_exit_time = NOW();

    UPDATE ParkingRecord SET exit_time = v_exit_time WHERE record_id = p_record_id;

    -- 30분 단위 올림, 단위당 3,000원
    SET v_minutes = TIMESTAMPDIFF(MINUTE, v_entry_time, v_exit_time);
    SET v_raw_fee = CEIL(v_minutes / 30.0) * 3000;

    IF v_user_type = 'employee' THEN
        SELECT COUNT(*) INTO v_pass_active
          FROM SeasonPass sp
          JOIN DeptEmployee de ON de.employee_id = sp.employee_id
         WHERE de.plate_number = v_plate AND sp.is_active = TRUE;

        IF v_pass_active > 0 THEN
            SET v_rate = 1.00; SET v_reason = 'season_pass';
        ELSE
            SET v_rate = 0.00; SET v_reason = 'none';
        END IF;

    ELSEIF v_user_type = 'resident' THEN
        SET v_rate = 1.00; SET v_reason = 'resident_free';

    ELSE
        SELECT is_disabled INTO v_is_disabled FROM Vehicle WHERE plate_number = v_plate;

        IF v_is_disabled THEN
            SET v_rate = 0.50; SET v_reason = 'disabled';
        ELSE
            SET v_rate = 0.00; SET v_reason = 'none';
        END IF;
    END IF;

    SET v_final_fee = CEIL(v_raw_fee * (1 - v_rate));

    INSERT INTO Payment (record_id, raw_fee, discount_rate, discount_reason, final_fee, method)
    VALUES (p_record_id, v_raw_fee, v_rate, v_reason, v_final_fee, p_method);
END$$

DELIMITER ;
