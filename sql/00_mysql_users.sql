-- ============================================================
-- MySQL DB 계정 설정 (root로 실행)
-- 실행 순서: 이 파일을 먼저 실행한 뒤 01_schema.sql ~ 실행
-- ============================================================

-- 기존 계정 정리 (재실행 시 오류 방지)
DROP USER IF EXISTS 'parking_admin'@'localhost';
DROP USER IF EXISTS 'parking_user'@'localhost';

-- 관리자 계정: 모든 권한 (통계 조회, 데이터 수정 등)
CREATE USER 'parking_admin'@'localhost' IDENTIFIED BY 'admin1234';
GRANT ALL PRIVILEGES ON parking_db.* TO 'parking_admin'@'localhost';

-- 일반 계정: SELECT만 가능 (입차/출차 등 프로시저 실행은 EXECUTE 권한 추가)
CREATE USER 'parking_user'@'localhost' IDENTIFIED BY 'user1234';
GRANT SELECT ON parking_db.* TO 'parking_user'@'localhost';
GRANT EXECUTE ON parking_db.* TO 'parking_user'@'localhost';

FLUSH PRIVILEGES;
-- AppUser INSERT는 01_schema.sql 실행 후 06_dummy_data.sql 끝에 있음
