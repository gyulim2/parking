USE parking_db;

DROP PROCEDURE IF EXISTS sp_park_enter;
DROP PROCEDURE IF EXISTS sp_park_exit;

DELIMITER $$

-- 입차 처리
CREATE PROCEDURE sp_park_enter(
    IN  p_plate_number  VARCHAR(20),  -- 차량 번호판
    IN  p_spot_id       INT,          -- 주차할 자리
    IN  p_visit_unit_id INT,          -- 방문 세대 id (visitor 아니면 NULL)
    IN  p_user_type     ENUM('employee', 'resident', 'visitor', 'general')
)
BEGIN
    DECLARE v_is_occupied  BOOLEAN;
    DECLARE v_spot_type    VARCHAR(10);
    DECLARE v_is_disabled  BOOLEAN;
    DECLARE v_is_ev        BOOLEAN;
    DECLARE v_unit_id      INT;
    DECLARE v_unpaid_count INT;
    DECLARE v_this_month   DATE;

    START TRANSACTION;

    -- 자리 상태랑 타입 같이 가져옴
    SELECT is_occupied, spot_type INTO v_is_occupied, v_spot_type
      FROM ParkingSpot
     WHERE spot_id = p_spot_id;

    IF v_is_occupied THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '이미 사용 중인 주차 공간입니다.';
    END IF;

    -- 장애인/전기차 전용 자리인지 확인
    SELECT is_disabled, is_ev INTO v_is_disabled, v_is_ev
      FROM Vehicle
     WHERE plate_number = p_plate_number;

    IF v_spot_type = 'disabled' AND v_is_disabled = FALSE THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '장애인 전용 자리입니다.';
    END IF;

    IF v_spot_type = 'ev' AND v_is_ev = FALSE THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '전기차 전용 자리입니다.';
    END IF;

    -- 입주민이면 관리비 미납 확인 (입차 시점 기준으로 전월까지 미납이 있으면 입차 거부)
    IF p_user_type = 'resident' THEN
        SELECT ar.unit_id INTO v_unit_id
          FROM AptResident ar
         WHERE ar.plate_number = p_plate_number
         LIMIT 1;

        SET v_this_month = DATE_FORMAT(CURDATE(), '%Y-%m-01');

        SELECT COUNT(*) INTO v_unpaid_count
          FROM AptMonthlyPayment
         WHERE unit_id      = v_unit_id
           AND is_paid      = FALSE
           AND billing_month < v_this_month;

        IF v_unpaid_count > 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = '관리비 미납 세대는 입차할 수 없습니다.';
        END IF;
    END IF;

    INSERT INTO ParkingRecord (plate_number, spot_id, visit_unit_id, user_type, entry_time)
    VALUES (p_plate_number, p_spot_id, p_visit_unit_id, p_user_type, NOW());

    COMMIT;
END$$

-- 출차 + 요금 정산
CREATE PROCEDURE sp_park_exit(
    IN p_record_id INT,  -- 출차할 입출차 기록 번호
    IN p_method    ENUM('season_pass', 'resident_free', 'card', 'cash', 'app')  -- 결제 수단
)
BEGIN
    DECLARE v_plate       VARCHAR(20);
    DECLARE v_user_type   VARCHAR(20);
    DECLARE v_entry_time  DATETIME;
    DECLARE v_exit_time   DATETIME;
    DECLARE v_units       INT;
    DECLARE v_raw_fee     INT;
    DECLARE v_rate        DECIMAL(3,2);
    DECLARE v_reason      VARCHAR(20);
    DECLARE v_final_fee   INT;
    DECLARE v_is_disabled BOOLEAN;
    DECLARE v_pass_active INT;

    START TRANSACTION;

    SELECT plate_number, user_type, entry_time
      INTO v_plate, v_user_type, v_entry_time
      FROM ParkingRecord
     WHERE record_id = p_record_id;

    SET v_exit_time = NOW();

    UPDATE ParkingRecord
       SET exit_time = v_exit_time
     WHERE record_id = p_record_id;

    -- 요금 계산 (30분당 3000원, 초 단위로 올림, 최소 1단위)
    SET v_units   = GREATEST(CEIL(TIMESTAMPDIFF(SECOND, v_entry_time, v_exit_time) / 1800.0), 1);
    SET v_raw_fee = v_units * 3000;

    -- 할인 사유 결정 (정기권 있는 직원 > 입주민 무료 > 장애인 50% > 일반)
    IF v_user_type = 'employee' THEN
        SELECT COUNT(*) INTO v_pass_active
          FROM SeasonPass sp
          JOIN DeptEmployee de ON de.employee_id = sp.employee_id
         WHERE de.plate_number = v_plate
           AND sp.is_active    = TRUE;

        IF v_pass_active > 0 THEN
            SET v_rate   = 1.00;
            SET v_reason = 'season_pass';
        ELSE
            SET v_rate   = 0.00;
            SET v_reason = 'none';
        END IF;

    ELSEIF v_user_type = 'resident' THEN
        SET v_rate   = 1.00;
        SET v_reason = 'resident_free';

    ELSE
        SELECT is_disabled INTO v_is_disabled
          FROM Vehicle WHERE plate_number = v_plate;

        IF v_is_disabled THEN
            SET v_rate   = 0.50;
            SET v_reason = 'disabled';
        ELSE
            SET v_rate   = 0.00;
            SET v_reason = 'none';
        END IF;
    END IF;

    SET v_final_fee = CEIL(v_raw_fee * (1 - v_rate));

    INSERT INTO Payment (record_id, raw_fee, discount_rate, discount_reason, final_fee, method)
    VALUES (p_record_id, v_raw_fee, v_rate, v_reason, v_final_fee, p_method);

    COMMIT;
END$$

DELIMITER ;
