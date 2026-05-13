# parking
복합 시설물 통합 주차 관리 시스템
야르

## DB 초기 세팅 방법

### 1. 저장소 클론
```bash
git clone https://github.com/gyulim2/parking.git
cd parking/sql
```

### 2. 스키마 생성 (테이블 + 트리거)
```bash
mysql -u root -p < 01_schema.sql
```

### 3. 더미 데이터 삽입
```bash
mysql -u root -p < 02_dummy_data.sql
```

> `-p` 뒤에 본인 MySQL 비밀번호를 입력하면 됩니다.  
> 비밀번호가 없으면 프롬프트에서 엔터만 치면 됩니다.

### 4. 정상 적용 확인
```bash
mysql -u root -p parking_db -e "SHOW TABLES;"
```
