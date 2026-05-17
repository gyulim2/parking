# parking
복합 시설물 통합 주차 관리 시스템

## DB 초기 세팅 방법

### 1. 저장소 클론
```bash
git clone https://github.com/gyulim2/parking.git
cd parking/sql
```

### 2. 파일 실행 순서

아래 순서대로 실행해야 합니다. 의존성이 있으므로 순서를 지켜주세요.

```bash
mysql -u root -p < 01_schema.sql      # 테이블 DDL + CHECK 제약
mysql -u root -p < 02_triggers.sql    # 트리거 (is_occupied 동기화, SeasonPass 만료)
mysql -u root -p < 03_procedures.sql  # 저장 프로시저 (입차/출차 정산)
mysql -u root -p < 04_views.sql       # 뷰 (시간대별 혼잡도)
mysql -u root -p < 05_indexes.sql     # 인덱스
mysql -u root -p < 06_dummy_data.sql  # 더미 데이터
```

> `-p` 뒤에 본인 MySQL 비밀번호를 입력하면 됩니다.  
> 비밀번호가 없으면 프롬프트에서 엔터만 치면 됩니다.

### 3. 정상 적용 확인
```bash
mysql -u root -p parking_db -e "SHOW TABLES;"
```

## 파일 구성

| 파일 | 내용 |
|---|---|
| `01_schema.sql` | 테이블 DDL, FK, CHECK 제약 |
| `02_triggers.sql` | 트리거 4개 |
| `03_procedures.sql` | 저장 프로시저 2개 (sp_park_enter, sp_park_exit) |
| `04_views.sql` | 뷰 1개 (v_hourly_congestion) |
| `05_indexes.sql` | 복합 인덱스 8개 |
| `06_dummy_data.sql` | 테스트용 더미 데이터 |