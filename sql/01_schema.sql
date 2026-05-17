-- ============================================================
-- parking_db schema
-- 복합 시설물 통합 주차 관리 시스템
-- ▶ 이 파일 하나로 DB 전체를 새로 만든다 (실행 순서: 위 → 아래)
-- ============================================================

-- 기존에 parking_db가 있으면 완전히 삭제하고 새로 만든다.
-- (개발 중에 스키마를 바꿀 때 깔끔하게 초기화하기 위한 것)
DROP DATABASE IF EXISTS parking_db;

-- 데이터베이스 생성
-- utf8mb4         : 한글·이모지 등 모든 유니코드 문자를 저장 가능한 문자셋
-- unicode_ci      : 대·소문자를 구분하지 않고 비교하는 정렬 규칙(collation)
CREATE DATABASE parking_db
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

-- 이후 모든 CREATE TABLE 이 이 DB 안에 만들어지도록 선택
USE parking_db;

-- ============================================================
-- ★ 테이블 간 관계 요약 (읽기 전에 머릿속에 그려두기)
--
--   ParkingLot ──┬── ParkingSpot ──── ParkingRecord ──── Payment
--                │         (어느 자리?)   (누가 언제?)
--                ├── DeptEmployee ── SeasonPass
--                │    (백화점 직원)    (직원 정기권)
--                └── AptUnit ──┬── AptResident
--                   (아파트 세대)│   (입주민)
--                              └── AptMonthlyPayment
--                                   (월 관리비 납부)
--
--  Vehicle 은 ParkingRecord, DeptEmployee, AptResident 에서 참조
-- ============================================================


-- ============================================================
-- 1. ParkingLot  (공통)
--    ▶ 주차장 자체를 나타내는 테이블.
--       백화점(department)과 아파트(apartment) 두 종류를 하나의 테이블로 관리.
--       모든 주차 관련 테이블이 결국 lot_id 를 통해 이 테이블을 참조한다.
-- ============================================================
CREATE TABLE ParkingLot (
    -- 주차장 고유 번호. AUTO_INCREMENT = INSERT 할 때 번호를 자동으로 1씩 올려준다.
    lot_id   INT          NOT NULL AUTO_INCREMENT,

    -- 주차장 이름 (예: "A백화점 지하주차장", "B아파트 주차장")
    name     VARCHAR(100) NOT NULL,

    -- 주차장 유형: 'department'(백화점) 또는 'apartment'(아파트) 중 하나만 입력 가능.
    -- ENUM 은 지정된 값 목록 외에는 저장을 막아준다.
    lot_type ENUM('department', 'apartment') NOT NULL,

    -- PRIMARY KEY: lot_id 를 기본키로 지정 → 중복 불가 + 자동 인덱스 생성
    CONSTRAINT pk_parking_lot PRIMARY KEY (lot_id)
) ENGINE = InnoDB          -- InnoDB: 트랜잭션·외래키를 지원하는 MySQL 기본 스토리지 엔진
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '주차장';


-- ============================================================
-- 2. Vehicle  (공통)
--    ▶ 시스템에 등록된 차량 정보.
--       번호판(plate_number)이 곧 차량의 고유 식별자(PK).
--       직원·입주민·방문객 모두 이 테이블을 공유한다.
-- ============================================================
CREATE TABLE Vehicle (
    -- 차량 번호판. 예: "123가4567", "서울12가3456"
    -- PK 이므로 중복 불가 (같은 번호판의 차량을 두 번 등록할 수 없음)
    plate_number VARCHAR(20) NOT NULL,

    -- 장애인 차량 여부. TRUE 면 장애인 할인 적용 대상.
    -- DEFAULT FALSE = 따로 지정 안 하면 일반 차량으로 간주
    is_disabled  BOOLEAN     NOT NULL DEFAULT FALSE,

    -- 전기차 여부. TRUE 면 ev(전기차) 전용 구역 이용 가능.
    is_ev        BOOLEAN     NOT NULL DEFAULT FALSE,

    CONSTRAINT pk_vehicle        PRIMARY KEY (plate_number),

    -- CHECK 제약: 번호판 길이가 7~9자 사이여야만 저장 허용.
    -- 한국 번호판 형식(7~9자)을 강제하는 데이터 유효성 검사.
    CONSTRAINT chk_vehicle_plate CHECK (CHAR_LENGTH(plate_number) BETWEEN 7 AND 9)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '차량';


-- ============================================================
-- 3. DeptEmployee  (A 백화점 전용)
--    ▶ 백화점 직원 정보. "이 직원이 어느 주차장 소속인가" 를 lot_id 로 기록.
--       한 직원은 차량 한 대만 등록 가능 (uq_de_plate 로 강제).
-- ============================================================
CREATE TABLE DeptEmployee (
    -- 직원 고유 번호 (자동 증가)
    employee_id  INT         NOT NULL AUTO_INCREMENT,

    -- 직원이 등록한 차량 번호판. Vehicle 테이블과 연결됨.
    plate_number VARCHAR(20) NOT NULL,

    -- 이 직원이 소속된 주차장 번호. ParkingLot 과 연결됨.
    lot_id       INT         NOT NULL,

    CONSTRAINT pk_dept_employee PRIMARY KEY (employee_id),

    -- UNIQUE: plate_number 는 이 테이블 안에서 중복 불가.
    -- → 한 차량이 두 명의 직원으로 등록될 수 없다.
    CONSTRAINT uq_de_plate      UNIQUE (plate_number),

    -- 외래키(FK): plate_number 는 반드시 Vehicle 에 먼저 존재해야 한다.
    -- ON DELETE RESTRICT : Vehicle 에서 차량을 삭제하려 하면, 이 직원 레코드가
    --                      남아 있는 한 삭제를 막는다(실수 방지).
    -- ON UPDATE CASCADE  : Vehicle 에서 번호판이 바뀌면, 여기도 자동으로 같이 바뀐다.
    CONSTRAINT fk_de_vehicle    FOREIGN KEY (plate_number)
        REFERENCES Vehicle (plate_number)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    -- 외래키: lot_id 는 반드시 ParkingLot 에 먼저 존재해야 한다.
    CONSTRAINT fk_de_lot        FOREIGN KEY (lot_id)
        REFERENCES ParkingLot (lot_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '백화점 직원';


-- ============================================================
-- 4. SeasonPass  (A 백화점 전용)
--    ▶ 백화점 직원의 월정기권 정보.
--       lot_id 를 여기에 두지 않는 이유:
--         employee_id → DeptEmployee.lot_id 로 한 번만 따라가면 주차장을 알 수 있기 때문
--         (중복 저장하면 데이터 불일치 위험 → 3NF 정규화 원칙)
-- ============================================================
CREATE TABLE SeasonPass (
    -- 정기권 고유 번호
    pass_id     INT     NOT NULL AUTO_INCREMENT,

    -- 이 정기권을 소유한 직원 번호. DeptEmployee 와 연결됨.
    employee_id INT     NOT NULL,

    -- 정기권 시작일 (예: 2025-01-01)
    start_date  DATE    NOT NULL,

    -- 정기권 만료일 (예: 2025-01-31)
    end_date    DATE    NOT NULL,

    -- 현재 유효한 정기권인지 여부.
    -- FALSE 가 되는 경우: 만료일이 지났거나, 직원이 퇴사했거나, 관리자가 비활성화.
    is_active   BOOLEAN NOT NULL DEFAULT TRUE,

    -- 이 정기권의 월 요금 (단위: 원). 0원도 허용(무료 정기권).
    monthly_fee INT     NOT NULL,

    CONSTRAINT pk_season_pass PRIMARY KEY (pass_id),

    -- 외래키: employee_id 는 DeptEmployee 에 존재해야 한다.
    -- ON DELETE CASCADE: 직원이 삭제되면 그 직원의 정기권도 자동으로 같이 삭제.
    --   (직원이 없는데 정기권만 남으면 의미 없으므로)
    CONSTRAINT fk_sp_employee FOREIGN KEY (employee_id)
        REFERENCES DeptEmployee (employee_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    -- CHECK: 만료일이 시작일보다 같거나 뒤여야 한다 (날짜가 뒤집히는 실수 방지)
    CONSTRAINT chk_sp_dates CHECK (end_date >= start_date),

    -- CHECK: 요금은 음수가 될 수 없다
    CONSTRAINT chk_sp_fee   CHECK (monthly_fee >= 0)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '직원 정기권 (백화점 전용)';


-- ============================================================
-- 5. AptUnit  (B 아파트 전용)
--    ▶ 아파트의 개별 세대(호수) 정보.
--       unit_number 는 "101호", "B동 202호" 같은 자유 문자열.
--       같은 주차장 안에서는 동일 호수가 중복될 수 없다 (uq_apt_unit).
-- ============================================================
CREATE TABLE AptUnit (
    -- 세대 고유 번호 (자동 증가)
    unit_id     INT         NOT NULL AUTO_INCREMENT,

    -- 이 세대가 속한 주차장 번호
    lot_id      INT         NOT NULL,

    -- 세대 호수 문자열 (예: "101", "B-202")
    unit_number VARCHAR(20) NOT NULL,

    CONSTRAINT pk_apt_unit    PRIMARY KEY (unit_id),

    -- UNIQUE (lot_id, unit_number): 같은 주차장 내에서 같은 호수는 딱 하나만 존재
    -- → (lot_id=1, unit_number="101") 과 (lot_id=2, unit_number="101") 은 OK
    -- → (lot_id=1, unit_number="101") 이 두 개 있으면 오류
    CONSTRAINT uq_apt_unit    UNIQUE (lot_id, unit_number),

    CONSTRAINT fk_au_lot      FOREIGN KEY (lot_id)
        REFERENCES ParkingLot (lot_id)
        ON DELETE RESTRICT   -- 세대가 남아있는 주차장은 삭제 불가
        ON UPDATE CASCADE,

    -- CHECK: 호수 문자열이 비어있으면 안 됨 (공백 문자열 방지)
    CONSTRAINT chk_unit_number CHECK (CHAR_LENGTH(unit_number) > 0)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '아파트 세대';


-- ============================================================
-- 6. AptResident  (B 아파트 전용)
--    ▶ 아파트 입주민 정보.
--       한 입주민 = 한 차량 (uq_ar_plate),
--       한 입주민 = 한 세대에 소속 (unit_id FK).
--       과거에는 unit_number(문자열)로 직접 연결했으나
--       → AptUnit.unit_id(정수 FK)로 바꾸어 정규화.
-- ============================================================
CREATE TABLE AptResident (
    -- 입주민 고유 번호
    resident_id  INT         NOT NULL AUTO_INCREMENT,

    -- 등록된 차량 번호판
    plate_number VARCHAR(20) NOT NULL,

    -- 소속 세대 번호 (AptUnit 참조)
    unit_id      INT         NOT NULL,

    CONSTRAINT pk_apt_resident PRIMARY KEY (resident_id),

    -- 한 차량은 한 명의 입주민으로만 등록 가능
    CONSTRAINT uq_ar_plate     UNIQUE (plate_number),

    CONSTRAINT fk_ar_vehicle   FOREIGN KEY (plate_number)
        REFERENCES Vehicle (plate_number)
        ON DELETE RESTRICT   -- 차량 정보가 있는 한 Vehicle 삭제 불가
        ON UPDATE CASCADE,

    CONSTRAINT fk_ar_unit      FOREIGN KEY (unit_id)
        REFERENCES AptUnit (unit_id)
        ON DELETE RESTRICT   -- 세대가 삭제되기 전에 입주민을 먼저 처리해야 함
        ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '아파트 입주민';


-- ============================================================
-- 7. AptMonthlyPayment  (B 아파트 전용)
--    ▶ 세대별 월 관리비 납부 여부를 추적하는 테이블.
--       아파트 입주민의 주차 무료 혜택은 이 납부 여부에 따라 결정된다.
--       billing_month 는 항상 해당 월의 1일로 저장 (예: 5월 → 2025-05-01).
-- ============================================================
CREATE TABLE AptMonthlyPayment (
    -- 납부 내역 고유 번호
    monthly_payment_id INT     NOT NULL AUTO_INCREMENT,

    -- 납부 대상 세대
    unit_id            INT     NOT NULL,

    -- 청구 월. DATE 타입이지만 항상 1일로 저장하는 관례 (2025-05-01 = 2025년 5월분)
    billing_month      DATE    NOT NULL COMMENT 'YYYY-MM-01 형식으로 저장',

    -- 납부 완료 여부. FALSE = 미납, TRUE = 납부 완료
    is_paid            BOOLEAN NOT NULL DEFAULT FALSE,

    CONSTRAINT pk_apt_monthly_payment PRIMARY KEY (monthly_payment_id),

    -- 같은 세대의 같은 월 청구는 단 하나만 존재 가능 (중복 청구 방지)
    CONSTRAINT uq_amp_unit_month      UNIQUE (unit_id, billing_month),

    -- ON DELETE CASCADE: 세대(AptUnit)가 삭제되면 납부 내역도 함께 삭제
    CONSTRAINT fk_amp_unit            FOREIGN KEY (unit_id)
        REFERENCES AptUnit (unit_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '아파트 월 관리비 납부 내역';


-- ============================================================
-- 8. ParkingSpot  (공통)
--    ▶ 주차장 안의 개별 주차 공간(자리) 하나하나를 나타낸다.
--       어느 주차장(lot_id), 몇 층(floor), 어느 구역(zone), 무슨 타입(spot_type).
--       is_occupied 로 현재 자리가 비어있는지 실시간으로 추적.
-- ============================================================
CREATE TABLE ParkingSpot (
    -- 주차 공간 고유 번호
    spot_id     INT         NOT NULL AUTO_INCREMENT,

    -- 이 자리가 속한 주차장
    lot_id      INT         NOT NULL,

    -- 층 번호. 지하는 음수 (예: 지하 1층 = -1, 지하 2층 = -2)
    floor       INT         NOT NULL,

    -- 구역 코드 (예: "A", "B", "가", "나-1" 등 자유 문자열)
    zone        VARCHAR(10) NOT NULL,

    -- 자리 유형:
    --   'general'  = 일반 자리
    --   'disabled' = 장애인 전용 자리
    --   'ev'       = 전기차 충전 자리
    spot_type   ENUM('general', 'disabled', 'ev') NOT NULL,

    -- 현재 점유 여부. TRUE = 차가 있음, FALSE = 비어있음.
    -- ParkingRecord 에 입차 기록이 생기면 TRUE, 출차 시 FALSE 로 업데이트.
    is_occupied BOOLEAN     NOT NULL DEFAULT FALSE,

    CONSTRAINT pk_parking_spot PRIMARY KEY (spot_id),

    -- ON DELETE CASCADE: 주차장이 삭제되면 그 안의 자리들도 자동으로 삭제
    CONSTRAINT fk_ps_lot       FOREIGN KEY (lot_id)
        REFERENCES ParkingLot (lot_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    -- CHECK: 층이 -10 ~ 50 범위 안이어야 함 (비현실적인 층수 방지)
    CONSTRAINT chk_spot_floor  CHECK (floor BETWEEN -10 AND 50)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '주차 공간';


-- ============================================================
-- 9. ParkingRecord  (공통)
--    ▶ 차량의 입차(들어옴) / 출차(나감) 기록.
--       exit_time 이 NULL 이면 → 아직 주차 중 (출차 안 함).
--       user_type 으로 이 차가 어떤 사람인지 구분:
--         'employee' = 백화점 직원
--         'resident' = 아파트 입주민
--         'visitor'  = 아파트 방문객 (visit_unit_id 에 방문 세대 기록)
--         'general'  = 일반 방문객 (백화점 쇼핑객 등)
-- ============================================================
CREATE TABLE ParkingRecord (
    -- 입출차 기록 고유 번호
    record_id     INT         NOT NULL AUTO_INCREMENT,

    -- 입차한 차량의 번호판
    plate_number  VARCHAR(20) NOT NULL,

    -- 주차한 자리 번호
    spot_id       INT         NOT NULL,

    -- 방문객이 방문한 세대 번호. visitor 타입일 때만 값이 들어오고, 나머지는 NULL.
    -- NULL 허용(NULL) = 값이 없어도 됨
    visit_unit_id INT         NULL     COMMENT '방문객이 방문한 세대 (visitor일 때만 사용)',

    -- 이 차의 이용자 유형 (할인·요금 계산에 사용됨)
    user_type     ENUM('employee', 'resident', 'visitor', 'general') NOT NULL,

    -- 입차 시각 (차가 들어온 시간)
    entry_time    DATETIME    NOT NULL,

    -- 출차 시각 (차가 나간 시간). NULL = 아직 주차 중.
    exit_time     DATETIME    NULL,

    CONSTRAINT pk_parking_record PRIMARY KEY (record_id),

    CONSTRAINT fk_pr_vehicle     FOREIGN KEY (plate_number)
        REFERENCES Vehicle (plate_number)
        ON DELETE RESTRICT   -- 입출차 기록이 있는 차량은 Vehicle 에서 삭제 불가
        ON UPDATE CASCADE,

    CONSTRAINT fk_pr_spot        FOREIGN KEY (spot_id)
        REFERENCES ParkingSpot (spot_id)
        ON DELETE RESTRICT   -- 기록이 있는 주차 자리는 삭제 불가
        ON UPDATE CASCADE,

    -- ON DELETE SET NULL: 방문한 세대(AptUnit)가 삭제되어도 이 기록은 남겨두되,
    --                     visit_unit_id 만 NULL 로 바꾼다 (기록 자체는 보존).
    CONSTRAINT fk_pr_visit_unit  FOREIGN KEY (visit_unit_id)
        REFERENCES AptUnit (unit_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    -- CHECK: 출차 시각이 입차 시각보다 반드시 나중이어야 함 (또는 아직 출차 안 한 경우 NULL)
    -- exit_time IS NULL : 아직 주차 중 → 검사 생략
    -- exit_time > entry_time : 출차 기록이 있으면 입차 이후여야 함
    CONSTRAINT chk_pr_exit_after CHECK (exit_time IS NULL OR exit_time > entry_time)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '입출차 기록';


-- ============================================================
-- 10. Payment  (공통)
--    ▶ 출차 시 발생하는 정산(결제) 내역. 입출차 기록 1건당 정산 1건.
--
--    요금 계산 흐름:
--      ① raw_fee     = 주차 시간 기준 원금 (30분당 3,000원, 올림 적용)
--      ② discount_rate 결정 (할인율: 0.00 = 할인 없음, 1.00 = 100% 무료)
--      ③ final_fee   = CEIL(raw_fee * (1 - discount_rate))
--         예) raw_fee=9000, discount_rate=0.50 → final_fee=4500
--
--    discount_reason 과 discount_rate 대응 예시:
--      'none'          → 0.00  (일반 요금 그대로)
--      'disabled'      → 0.50  (장애인 50% 할인)
--      'season_pass'   → 1.00  (직원 정기권 → 무료)
--      'resident_free' → 1.00  (납부 완료 입주민 → 무료)
-- ============================================================
CREATE TABLE Payment (
    -- 정산 고유 번호
    payment_id      INT          NOT NULL AUTO_INCREMENT,

    -- 어느 입출차 기록에 대한 정산인지 (ParkingRecord 참조)
    record_id       INT          NOT NULL,

    -- 할인 전 원금 (단위: 원). 주차 시간으로만 계산한 금액.
    raw_fee         INT          NOT NULL COMMENT '할인 전 원금 (30분당 3000원, 올림 단위)',

    -- 할인율. 0.00 ~ 1.00 사이의 소수.
    -- DECIMAL(3,2): 전체 3자리 중 소수점 이하 2자리 (예: 0.50, 1.00)
    discount_rate   DECIMAL(3,2) NOT NULL DEFAULT 0.00
        COMMENT '할인율 0.00~1.00. 계산식: final_fee = CEIL(raw_fee * (1 - discount_rate))',

    -- 할인 사유. 어떤 이유로 할인이 적용됐는지 기록.
    discount_reason ENUM('none', 'disabled', 'season_pass', 'resident_free') NOT NULL DEFAULT 'none'
        COMMENT '할인 사유',

    -- 실제 청구 금액 (= 할인 후 최종 금액, 단위: 원)
    final_fee       INT          NOT NULL COMMENT '최종 청구 금액',

    -- 결제 수단:
    --   'season_pass'   = 정기권으로 처리 (현금 수수 없음)
    --   'resident_free' = 입주민 무료 처리
    --   'card'          = 신용/체크카드
    --   'cash'          = 현금
    --   'app'           = 간편결제 앱 (카카오페이, 네이버페이 등)
    method          ENUM('season_pass', 'resident_free', 'card', 'cash', 'app') NOT NULL COMMENT '결제 수단',

    CONSTRAINT pk_payment        PRIMARY KEY (payment_id),

    -- 입출차 기록 1건에 정산은 반드시 1건만 (중복 정산 방지)
    CONSTRAINT uq_payment_record UNIQUE (record_id),

    -- ON DELETE CASCADE: 입출차 기록이 삭제되면 정산 내역도 같이 삭제
    CONSTRAINT fk_pay_record     FOREIGN KEY (record_id)
        REFERENCES ParkingRecord (record_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT chk_pay_raw       CHECK (raw_fee       >= 0),         -- 원금은 0 이상
    CONSTRAINT chk_pay_final     CHECK (final_fee     >= 0),         -- 최종 금액도 0 이상
    CONSTRAINT chk_pay_rate      CHECK (discount_rate BETWEEN 0.00 AND 1.00)  -- 할인율은 0~100%
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '정산';
