-- ============================================================
-- parking_db schema
-- 복합 시설물 통합 주차 관리 시스템
-- ============================================================

DROP DATABASE IF EXISTS parking_db;
CREATE DATABASE parking_db
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE parking_db;

-- ============================================================
-- 1. ParkingLot  (공통)
-- ============================================================
CREATE TABLE ParkingLot (
    lot_id   INT          NOT NULL AUTO_INCREMENT,
    name     VARCHAR(100) NOT NULL,
    lot_type ENUM('department', 'apartment') NOT NULL,
    CONSTRAINT pk_parking_lot PRIMARY KEY (lot_id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '주차장';

-- ============================================================
-- 2. Vehicle  (공통)
-- ============================================================
CREATE TABLE Vehicle (
    plate_number VARCHAR(20)  NOT NULL,
    is_disabled  BOOLEAN      NOT NULL DEFAULT FALSE,
    is_ev        BOOLEAN      NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_vehicle PRIMARY KEY (plate_number)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '차량';

-- ============================================================
-- 3. DeptEmployee  (A 백화점 전용)
-- ============================================================
CREATE TABLE DeptEmployee (
    employee_id  INT         NOT NULL AUTO_INCREMENT,
    plate_number VARCHAR(20) NOT NULL,
    lot_id       INT         NOT NULL,
    CONSTRAINT pk_dept_employee  PRIMARY KEY (employee_id),
    CONSTRAINT fk_de_vehicle     FOREIGN KEY (plate_number)
        REFERENCES Vehicle (plate_number)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_de_lot         FOREIGN KEY (lot_id)
        REFERENCES ParkingLot (lot_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '백화점 직원';

-- ============================================================
-- 4. SeasonPass  (A 백화점 전용)
-- ============================================================
CREATE TABLE SeasonPass (
    pass_id     INT  NOT NULL AUTO_INCREMENT,
    employee_id INT  NOT NULL,
    lot_id      INT  NOT NULL,
    start_date  DATE NOT NULL,
    end_date    DATE NOT NULL,
    is_active   BOOLEAN NOT NULL DEFAULT TRUE,
    monthly_fee INT  NOT NULL,
    CONSTRAINT pk_season_pass   PRIMARY KEY (pass_id),
    CONSTRAINT fk_sp_employee   FOREIGN KEY (employee_id)
        REFERENCES DeptEmployee (employee_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_sp_lot        FOREIGN KEY (lot_id)
        REFERENCES ParkingLot (lot_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '직원 정기권 (백화점 전용)';

-- ============================================================
-- 5. AptResident  (B 아파트 전용)
-- ============================================================
CREATE TABLE AptResident (
    resident_id  INT         NOT NULL AUTO_INCREMENT,
    plate_number VARCHAR(20) NOT NULL,
    lot_id       INT         NOT NULL,
    unit_number  VARCHAR(20) NOT NULL,
    CONSTRAINT pk_apt_resident PRIMARY KEY (resident_id),
    CONSTRAINT fk_ar_vehicle   FOREIGN KEY (plate_number)
        REFERENCES Vehicle (plate_number)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_ar_lot       FOREIGN KEY (lot_id)
        REFERENCES ParkingLot (lot_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '아파트 입주민';

-- ============================================================
-- 6. ParkingSpot  (공통)
-- ============================================================
CREATE TABLE ParkingSpot (
    spot_id     INT         NOT NULL AUTO_INCREMENT,
    lot_id      INT         NOT NULL,
    floor       INT         NOT NULL,
    zone        VARCHAR(10) NOT NULL,
    spot_type   ENUM('general', 'disabled', 'ev') NOT NULL,
    is_occupied BOOLEAN     NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_parking_spot PRIMARY KEY (spot_id),
    CONSTRAINT fk_ps_lot       FOREIGN KEY (lot_id)
        REFERENCES ParkingLot (lot_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '주차 공간';

-- ============================================================
-- 7. ParkingRecord  (공통)
-- ============================================================
CREATE TABLE ParkingRecord (
    record_id    INT         NOT NULL AUTO_INCREMENT,
    plate_number VARCHAR(20) NOT NULL,
    spot_id      INT         NOT NULL,
    resident_id  INT         NULL,
    user_type    ENUM('employee', 'resident', 'visitor', 'general') NOT NULL,
    entry_time   DATETIME    NOT NULL,
    exit_time    DATETIME    NULL,
    CONSTRAINT pk_parking_record PRIMARY KEY (record_id),
    CONSTRAINT fk_pr_vehicle     FOREIGN KEY (plate_number)
        REFERENCES Vehicle (plate_number)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_pr_spot        FOREIGN KEY (spot_id)
        REFERENCES ParkingSpot (spot_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_pr_resident    FOREIGN KEY (resident_id)
        REFERENCES AptResident (resident_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '입출차 기록';

-- ============================================================
-- 8. Payment  (공통)
-- ============================================================
CREATE TABLE Payment (
    payment_id    INT         NOT NULL AUTO_INCREMENT,
    record_id     INT         NOT NULL,
    raw_fee       INT         NOT NULL,
    discount_rate FLOAT       NOT NULL DEFAULT 0,
    final_fee     INT         NOT NULL,
    method        VARCHAR(20) NOT NULL,
    CONSTRAINT pk_payment        PRIMARY KEY (payment_id),
    CONSTRAINT uq_payment_record UNIQUE (record_id),
    CONSTRAINT fk_pay_record     FOREIGN KEY (record_id)
        REFERENCES ParkingRecord (record_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '정산';

-- ============================================================
-- 트리거: SeasonPass 만료 자동 처리
-- ============================================================

DELIMITER $$

-- INSERT 시: 이미 만료된 날짜로 등록하면 즉시 비활성화
CREATE TRIGGER trg_season_pass_expire_insert
BEFORE INSERT ON SeasonPass
FOR EACH ROW
BEGIN
    IF NEW.end_date < CURDATE() THEN
        SET NEW.is_active = FALSE;
    END IF;
END$$

-- UPDATE 시: end_date 변경으로 만료되면 비활성화,
--            아직 유효하면 활성화
CREATE TRIGGER trg_season_pass_expire_update
BEFORE UPDATE ON SeasonPass
FOR EACH ROW
BEGIN
    IF NEW.end_date < CURDATE() THEN
        SET NEW.is_active = FALSE;
    ELSE
        SET NEW.is_active = TRUE;
    END IF;
END$$

DELIMITER ;
