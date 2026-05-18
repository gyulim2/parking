-- parking_db schema
-- ParkingLot ─┬─ ParkingSpot ─── ParkingRecord ─── Payment
--             ├─ DeptEmployee ── SeasonPass
--             └─ AptUnit ──┬─── AptResident
--                          └─── AptMonthlyPayment
-- Vehicle 은 ParkingRecord, DeptEmployee, AptResident 에서 참조

DROP DATABASE IF EXISTS parking_db;
CREATE DATABASE parking_db
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;
USE parking_db;


CREATE TABLE ParkingLot (
    lot_id   INT          NOT NULL AUTO_INCREMENT,
    name     VARCHAR(100) NOT NULL,
    lot_type ENUM('department', 'apartment') NOT NULL,
    CONSTRAINT pk_parking_lot PRIMARY KEY (lot_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci
  COMMENT = '주차장';


CREATE TABLE Vehicle (
    plate_number VARCHAR(20) NOT NULL,
    is_disabled  BOOLEAN     NOT NULL DEFAULT FALSE,
    is_ev        BOOLEAN     NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_vehicle        PRIMARY KEY (plate_number),
    CONSTRAINT chk_vehicle_plate CHECK (CHAR_LENGTH(plate_number) BETWEEN 7 AND 9)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci
  COMMENT = '차량';


CREATE TABLE DeptEmployee (
    employee_id  INT         NOT NULL AUTO_INCREMENT,
    plate_number VARCHAR(20) NOT NULL,
    lot_id       INT         NOT NULL,
    CONSTRAINT pk_dept_employee PRIMARY KEY (employee_id),
    CONSTRAINT uq_de_plate      UNIQUE (plate_number),
    CONSTRAINT fk_de_vehicle    FOREIGN KEY (plate_number)
        REFERENCES Vehicle (plate_number) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_de_lot        FOREIGN KEY (lot_id)
        REFERENCES ParkingLot (lot_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci
  COMMENT = '백화점 직원';


CREATE TABLE SeasonPass (
    pass_id     INT     NOT NULL AUTO_INCREMENT,
    employee_id INT     NOT NULL,
    start_date  DATE    NOT NULL,
    end_date    DATE    NOT NULL,
    is_active   BOOLEAN NOT NULL DEFAULT TRUE,
    monthly_fee INT     NOT NULL,
    CONSTRAINT pk_season_pass PRIMARY KEY (pass_id),
    CONSTRAINT fk_sp_employee FOREIGN KEY (employee_id)
        REFERENCES DeptEmployee (employee_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_sp_dates CHECK (end_date >= start_date),
    CONSTRAINT chk_sp_fee   CHECK (monthly_fee >= 0)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci
  COMMENT = '직원 정기권 (백화점 전용)';


CREATE TABLE AptUnit (
    unit_id     INT         NOT NULL AUTO_INCREMENT,
    lot_id      INT         NOT NULL,
    unit_number VARCHAR(20) NOT NULL,
    CONSTRAINT pk_apt_unit  PRIMARY KEY (unit_id),
    CONSTRAINT uq_apt_unit  UNIQUE (lot_id, unit_number),
    CONSTRAINT fk_au_lot    FOREIGN KEY (lot_id)
        REFERENCES ParkingLot (lot_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_unit_number CHECK (CHAR_LENGTH(unit_number) > 0)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci
  COMMENT = '아파트 세대';


CREATE TABLE AptResident (
    resident_id  INT         NOT NULL AUTO_INCREMENT,
    plate_number VARCHAR(20) NOT NULL,
    unit_id      INT         NOT NULL,
    CONSTRAINT pk_apt_resident PRIMARY KEY (resident_id),
    CONSTRAINT uq_ar_plate     UNIQUE (plate_number),
    CONSTRAINT fk_ar_vehicle   FOREIGN KEY (plate_number)
        REFERENCES Vehicle (plate_number) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_ar_unit      FOREIGN KEY (unit_id)
        REFERENCES AptUnit (unit_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci
  COMMENT = '아파트 입주민';


-- billing_month 는 YYYY-MM-01 형식으로 저장
CREATE TABLE AptMonthlyPayment (
    monthly_payment_id INT     NOT NULL AUTO_INCREMENT,
    unit_id            INT     NOT NULL,
    billing_month      DATE    NOT NULL,
    is_paid            BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_apt_monthly_payment PRIMARY KEY (monthly_payment_id),
    CONSTRAINT uq_amp_unit_month      UNIQUE (unit_id, billing_month),
    CONSTRAINT fk_amp_unit            FOREIGN KEY (unit_id)
        REFERENCES AptUnit (unit_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci
  COMMENT = '아파트 월 관리비 납부 내역';


-- floor: 지하는 음수 (-1 = 지하 1층)
CREATE TABLE ParkingSpot (
    spot_id     INT         NOT NULL AUTO_INCREMENT,
    lot_id      INT         NOT NULL,
    floor       INT         NOT NULL,
    zone        VARCHAR(10) NOT NULL,
    spot_type   ENUM('general', 'disabled', 'ev') NOT NULL,
    is_occupied BOOLEAN     NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_parking_spot PRIMARY KEY (spot_id),
    CONSTRAINT fk_ps_lot       FOREIGN KEY (lot_id)
        REFERENCES ParkingLot (lot_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_spot_floor  CHECK (floor BETWEEN -10 AND 50)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci
  COMMENT = '주차 공간';


-- exit_time NULL = 주차 중 / visit_unit_id 는 visitor 타입일 때만 사용
CREATE TABLE ParkingRecord (
    record_id     INT         NOT NULL AUTO_INCREMENT,
    plate_number  VARCHAR(20) NOT NULL,
    spot_id       INT         NOT NULL,
    visit_unit_id INT         NULL,
    user_type     ENUM('employee', 'resident', 'visitor', 'general') NOT NULL,
    entry_time    DATETIME    NOT NULL,
    exit_time     DATETIME    NULL,
    CONSTRAINT pk_parking_record PRIMARY KEY (record_id),
    CONSTRAINT fk_pr_vehicle     FOREIGN KEY (plate_number)
        REFERENCES Vehicle (plate_number) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_pr_spot        FOREIGN KEY (spot_id)
        REFERENCES ParkingSpot (spot_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_pr_visit_unit  FOREIGN KEY (visit_unit_id)
        REFERENCES AptUnit (unit_id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT chk_pr_exit_after CHECK (exit_time IS NULL OR exit_time > entry_time)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci
  COMMENT = '입출차 기록';


-- final_fee = CEIL(raw_fee * (1 - discount_rate))
-- none→0.00 / disabled→0.50 / season_pass·resident_free→1.00
CREATE TABLE Payment (
    payment_id      INT          NOT NULL AUTO_INCREMENT,
    record_id       INT          NOT NULL,
    raw_fee         INT          NOT NULL,
    discount_rate   DECIMAL(3,2) NOT NULL DEFAULT 0.00,
    discount_reason ENUM('none', 'disabled', 'season_pass', 'resident_free') NOT NULL DEFAULT 'none',
    final_fee       INT          NOT NULL,
    method          ENUM('season_pass', 'resident_free', 'card', 'cash', 'app') NOT NULL,
    CONSTRAINT pk_payment        PRIMARY KEY (payment_id),
    CONSTRAINT uq_payment_record UNIQUE (record_id),
    CONSTRAINT fk_pay_record     FOREIGN KEY (record_id)
        REFERENCES ParkingRecord (record_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_pay_raw       CHECK (raw_fee >= 0),
    CONSTRAINT chk_pay_final     CHECK (final_fee >= 0),
    CONSTRAINT chk_pay_rate      CHECK (discount_rate BETWEEN 0.00 AND 1.00)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci
  COMMENT = '정산';
