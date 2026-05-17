-- ============================================================
-- parking_db 저장 프로시저 (Stored Procedure)
--
-- ▶ 저장 프로시저란?
--    자주 쓰는 SQL 로직을 DB 서버 안에 함수처럼 저장해두고,
--    CALL 프로시저명(인자) 로 실행하는 것.
--    애플리케이션에서 복잡한 SQL 을 직접 짜지 않아도 되고,
--    트랜잭션·오류 처리도 한 곳에서 관리할 수 있다.
--
-- ▶ IN / OUT 파라미터
--    IN  : 호출자가 값을 넘겨줌 (읽기 전용)
--    OUT : 프로시저가 값을 돌려줌 (쓰기 전용)
--    없으면 기본 IN
--
-- ▶ 이 파일에 있는 프로시저 목록
--    1. sp_park_enter : 차량 입차 처리
--    2. sp_park_exit  : 차량 출차 + 정산 처리
-- ============================================================

USE parking_db;

DELIMITER $$

-- ============================================================
-- 1. sp_park_enter  : 입차 처리
--
--    ▶ 호출 예시
--       CALL sp_park_enter('12가3456', 3, NULL, 'employee');
--       CALL sp_park_enter('55차5678', 7,    1, 'visitor');
--         → 방문객이 세대 1번(101동 501호)을 방문하며 spot 7번 에 주차
--
--    ▶ 처리 순서
--       ① 요청한 주차 자리(p_spot_id)가 비어있는지 확인 → 이미 점유면 오류
--       ② 입주민(resident)이면 관리비 미납 여부 확인 → 미납이면 오류
--          (이 검사는 트리거 5번에도 있어서 이중 방어)
--       ③ ParkingRecord 에 입차 기록 INSERT
--          → 트리거 3번(trg_spot_occupied_on_enter)이 자동으로
--            ParkingSpot.is_occupied = TRUE 로 바꿔줌
--
--    ▶ 파라미터 설명
--       p_plate_number  : 입차하는 차량 번호판
--       p_spot_id       : 주차할 자리 번호
--       p_visit_unit_id : 방문객이 방문하는 세대 번호 (visitor 아니면 NULL)
--       p_user_type     : 이용자 유형 (employee / resident / visitor / general)
-- ============================================================
CREATE PROCEDURE sp_park_enter(
    IN  p_plate_number  VARCHAR(20),
    IN  p_spot_id       INT,
    IN  p_visit_unit_id INT,
    IN  p_user_type     ENUM('employee', 'resident', 'visitor', 'general')
)
BEGIN
    -- 프로시저 안에서 쓸 임시 변수 선언
    DECLARE v_is_occupied  BOOLEAN;  -- 해당 자리의 현재 점유 상태
    DECLARE v_unit_id      INT;      -- 입주민이 사는 세대 번호
    DECLARE v_unpaid_count INT;      -- 미납 관리비 건수

    -- ① 주차 자리 점유 여부 조회
    --    INTO v_is_occupied : SELECT 결과를 변수에 담는 문법
    SELECT is_occupied INTO v_is_occupied
      FROM ParkingSpot
     WHERE spot_id = p_spot_id;

    -- 자리가 이미 점유 중이면 입차 불가 → 오류 발생
    IF v_is_occupied THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '이미 사용 중인 주차 공간입니다.';
    END IF;

    -- ② 아파트 입주민인 경우 관리비 미납 여부 확인
    IF p_user_type = 'resident' THEN

        -- 이 차량을 가진 입주민의 세대 번호를 찾는다
        SELECT ar.unit_id INTO v_unit_id
          FROM AptResident ar
         WHERE ar.plate_number = p_plate_number
         LIMIT 1;

        -- 이번 달 이전 미납 건수를 센다
        -- DATE_FORMAT(CURDATE(), '%Y-%m-01') : 오늘 기준 이번 달 1일
        --   예) 오늘이 2026-05-17 이면 → '2026-05-01'
        -- billing_month < '2026-05-01' : 4월분 이전이 미납이면 차단
        SELECT COUNT(*) INTO v_unpaid_count
          FROM AptMonthlyPayment
         WHERE unit_id      = v_unit_id
           AND is_paid      = FALSE
           AND billing_month < DATE_FORMAT(CURDATE(), '%Y-%m-01');

        IF v_unpaid_count > 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = '관리비 미납 세대는 입차할 수 없습니다.';
        END IF;
    END IF;

    -- ③ 입차 기록 저장
    --    entry_time = NOW() : 현재 날짜+시각 자동 입력
    --    exit_time 는 컬럼 목록에 없으므로 NULL (아직 주차 중)
    INSERT INTO ParkingRecord (plate_number, spot_id, visit_unit_id, user_type, entry_time)
    VALUES (p_plate_number, p_spot_id, p_visit_unit_id, p_user_type, NOW());
    -- ↑ INSERT 후 트리거 trg_spot_occupied_on_enter 가 자동 실행 →
    --   ParkingSpot.is_occupied = TRUE 로 변경됨
END$$

-- ============================================================
-- 2. sp_park_exit  : 출차 및 정산 처리
--
--    ▶ 호출 예시
--       CALL sp_park_exit(9, 'card');   -- record 9번, 카드 결제
--       CALL sp_park_exit(10, 'app');   -- record 10번, 앱 결제
--
--    ▶ 처리 순서
--       ① 기록 조회 (차량·이용자 유형·입차 시각)
--       ② ParkingRecord.exit_time 을 현재 시각으로 UPDATE
--          → 트리거 4번(trg_spot_released_on_exit)이 자동으로
--            ParkingSpot.is_occupied = FALSE 로 바꿔줌
--       ③ 주차 시간(분) → 30분 단위 올림 → 원금(raw_fee) 계산
--       ④ 할인 사유 및 할인율 결정 (우선순위: season_pass > resident_free > disabled > none)
--       ⑤ final_fee = CEIL(raw_fee * (1 - 할인율)) 계산
--       ⑥ Payment 에 정산 내역 INSERT
--
--    ▶ 파라미터 설명
--       p_record_id : 출차할 입출차 기록 번호
--       p_method    : 결제 수단 (season_pass / resident_free / card / cash / app)
-- ============================================================
CREATE PROCEDURE sp_park_exit(
    IN p_record_id INT,
    IN p_method    ENUM('season_pass', 'resident_free', 'card', 'cash', 'app')
)
BEGIN
    -- 계산에 필요한 임시 변수들
    DECLARE v_plate       VARCHAR(20);   -- 차량 번호판
    DECLARE v_user_type   VARCHAR(20);   -- 이용자 유형
    DECLARE v_entry_time  DATETIME;      -- 입차 시각
    DECLARE v_exit_time   DATETIME;      -- 출차 시각 (NOW()로 설정할 것)
    DECLARE v_minutes     INT;           -- 주차 시간(분)
    DECLARE v_units       INT;           -- 30분 단위 개수 (올림)
    DECLARE v_raw_fee     INT;           -- 할인 전 원금
    DECLARE v_rate        DECIMAL(3,2);  -- 할인율
    DECLARE v_reason      VARCHAR(20);   -- 할인 사유
    DECLARE v_final_fee   INT;           -- 최종 청구 금액
    DECLARE v_is_disabled BOOLEAN;       -- 장애인 차량 여부
    DECLARE v_pass_active INT;           -- 유효한 정기권 건수

    -- ① 해당 입출차 기록에서 필요한 정보 가져오기
    SELECT plate_number, user_type, entry_time
      INTO v_plate, v_user_type, v_entry_time
      FROM ParkingRecord
     WHERE record_id = p_record_id;

    -- 출차 시각 = 지금
    SET v_exit_time = NOW();

    -- ② exit_time 기록 (이 UPDATE 로 트리거가 is_occupied = FALSE 처리)
    UPDATE ParkingRecord
       SET exit_time = v_exit_time
     WHERE record_id = p_record_id;

    -- ③ 요금 계산
    --    TIMESTAMPDIFF(MINUTE, 시작, 끝) : 두 시각의 차이를 분 단위로 반환
    --    CEIL(분 / 30.0) : 30분 단위로 올림
    --      예) 45분 → CEIL(1.5) = 2단위 → 6,000원
    --          90분 → CEIL(3.0) = 3단위 → 9,000원
    --          91분 → CEIL(3.03) = 4단위 → 12,000원
    SET v_minutes  = TIMESTAMPDIFF(MINUTE, v_entry_time, v_exit_time);
    SET v_units    = CEIL(v_minutes / 30.0);
    SET v_raw_fee  = v_units * 3000;

    -- ④ 할인 사유 결정 (우선순위 순서로 IF ~ ELSEIF 구성)
    IF v_user_type = 'employee' THEN
        -- 백화점 직원: 유효한 정기권이 있으면 100% 할인, 없으면 정가
        SELECT COUNT(*) INTO v_pass_active
          FROM SeasonPass sp
          JOIN DeptEmployee de ON de.employee_id = sp.employee_id
         WHERE de.plate_number = v_plate
           AND sp.is_active    = TRUE;

        IF v_pass_active > 0 THEN
            SET v_rate = 1.00; SET v_reason = 'season_pass';   -- 정기권 → 무료
        ELSE
            SET v_rate = 0.00; SET v_reason = 'none';           -- 정기권 없음 → 정가
        END IF;

    ELSEIF v_user_type = 'resident' THEN
        -- 아파트 입주민: 항상 100% 무료 (입차 시 이미 미납 차단됨)
        SET v_rate = 1.00; SET v_reason = 'resident_free';

    ELSE
        -- visitor / general: 장애인이면 50% 할인, 아니면 정가
        SELECT is_disabled INTO v_is_disabled
          FROM Vehicle WHERE plate_number = v_plate;

        IF v_is_disabled THEN
            SET v_rate = 0.50; SET v_reason = 'disabled';   -- 장애인 50% 할인
        ELSE
            SET v_rate = 0.00; SET v_reason = 'none';        -- 일반 정가
        END IF;
    END IF;

    -- ⑤ 최종 금액 계산
    --    CEIL(raw_fee * (1 - rate)) : 할인 후 올림
    --      예) raw_fee=9000, rate=0.50 → CEIL(9000 * 0.5) = CEIL(4500) = 4500
    --      예) raw_fee=9001, rate=0.50 → CEIL(9001 * 0.5) = CEIL(4500.5) = 4501
    SET v_final_fee = CEIL(v_raw_fee * (1 - v_rate));

    -- ⑥ 정산 내역 저장
    --    INSERT 후 트리거 trg_payment_consistency 가 자동으로 데이터 검증
    INSERT INTO Payment (record_id, raw_fee, discount_rate, discount_reason, final_fee, method)
    VALUES (p_record_id, v_raw_fee, v_rate, v_reason, v_final_fee, p_method);
END$$

DELIMITER ;
