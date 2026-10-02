# 이경규의 파킹랏

백화점 + 아파트 복합 시설 통합 주차 관리 시스템

> **한눈에 보기**
> - **무엇**: 서로 다른 요금·권한 규칙을 가진 두 주차장(백화점 600면 / 아파트 1,000면)을 하나의 웹 서비스로 관리
> - **역할**: 리드
> - **스택**: Flask · MySQL(저장 프로시저·트리거·뷰·인덱스) · Vanilla JS · Railway 배포
> - **핵심 설계**: 입차/출차+정산을 **DB 트랜잭션(저장 프로시저)** 으로 묶고 `FOR UPDATE` 행 잠금으로 **동시 입차 시 중복 배정 방지**, 이중 입차·관리비 미납 차단·요금 일관성 검증을 **트리거**로 DB 레벨에서 강제
> - **권한 분리**: DB 계정을 일반(`SELECT`/`EXECUTE`)과 관리자(전체)로 나눠 최소 권한 적용
> - **화면**: [메인](#메인) · [입차](#입차---주차장-선택-후-평면도에서-자리-확인-및-입차) · [출차·정산](#출차---번호판-입력--주차-시간--요금-자동-계산) · [관리자 대시보드](#관리자-대시보드---매출-통계-시간대별-혼잡도-입출차-및-결제-이력)

---

## 프로젝트 개요

백화점과 아파트 주차장을 하나의 웹 서비스로 관리하는 시스템입니다.

| | A 백화점 주차장 (Lot 1) | B 아파트 주차장 (Lot 2) |
|---|---|---|
| 층 | 지하 1~3층 | 지하 1층 |
| 구역 | A~L (12구역) | P~Y (10구역) |
| 총 자리 | 600자리 | 1,000자리 |
| 구역당 구성 | 일반 42 + 장애인 3 + 전기차 5 = 50 | 일반 84 + 장애인 8 + 전기차 8 = 100 |

### A 백화점 주차장 요금 (일반 / 방문객 / 직원)

| 유형 | 요금 | 비고 |
|------|------|------|
| 일반 | 30분당 3,000원 | |
| 방문객 | 30분당 3,000원 | 방문 세대 ID 필요 |
| 직원 (정기권 有) | 무료 | 유효한 정기권 필요 |
| 직원 (정기권 無) | 30분당 3,000원 | |

### B 아파트 주차장 요금 (입주민 / 방문객)

| 유형 | 요금 | 비고 |
|------|------|------|
| 입주민 | 무료 | 관리비 전월 미납 시 입차 차단 |
| 방문객 | 30분당 3,000원 | 방문 세대 ID 필요 |

### 공통 - 차량 특성별 적용

| 차량 유형 | 적용 | 비고 |
|-----------|------|------|
| 장애인 차량 | 요금 50% 할인 | 장애인 전용 자리만 이용 가능 |
| 전기차 | 요금 변동 없음 | 전기차 전용 자리만 이용 가능 |

---

## 화면 구성

### 메인

![메인 화면](docs/screenshots/main.png)

### 입차 - 주차장 선택 후 평면도에서 자리 확인 및 입차

4초마다 자리 상태를 자동 갱신합니다. 내가 선택한 자리를 다른 사람이 먼저 차지하면 빈 자리로 자동 재배정됩니다.

![입차 화면](docs/screenshots/enter.png)

### 출차 - 번호판 입력 → 주차 시간 + 요금 자동 계산

![출차 화면](docs/screenshots/exit.png)
![정산 화면](docs/screenshots/exit1.png)

### 관리자 대시보드 - 매출 통계, 시간대별 혼잡도, 입출차 및 결제 이력

![관리자 대시보드1](docs/screenshots/dashboard1.png)
![관리자 대시보드2](docs/screenshots/dashboard2.png)

---

## DB 설계

### ERD

![erd](docs/screenshots/erd.png)

### 테이블 구조

| 테이블 | 설명 |
|--------|------|
| `ParkingLot` | 주차장 정보 |
| `ParkingSpot` | 주차 자리 (층, 구역, 타입, 점유 여부) |
| `ParkingRecord` | 입출차 기록 (방문객은 `visit_unit_id`로 방문 세대 연결) |
| `Payment` | 결제 정보 (원래 요금, 할인율, 최종 요금, 결제 수단) |
| `Vehicle` | 차량 (번호판, 장애인차 또는 전기차 여부) |
| `AptUnit` | 아파트 세대 |
| `AptResident` | 입주민 ↔ 차량 연결 |
| `AptMonthlyPayment` | 관리비 납부 이력 |
| `DeptEmployee` | 직원 ↔ 차량 연결 |
| `SeasonPass` | 직원 정기권 |
| `AppUser` | 관리자 계정 (비밀번호는 MySQL SHA2-256 해싱) |

### 저장 프로시저

입차와 출차+정산 로직을 트랜잭션으로 묶어 처리합니다.  
중간에 오류가 나면 자동으로 롤백됩니다.

**`sp_park_enter`** - 입차 처리

1. 자리 점유 여부 확인 (`FOR UPDATE`로 행 잠금 — 동시 입차 시 같은 자리 중복 배정 방지)
2. user_type 검증 (입주민은 아파트만, 직원은 백화점만)
3. 장애인/전기차 전용 자리 차량 검증
4. `ParkingRecord` 삽입

**`sp_park_exit`** - 출차 + 정산

1. `ParkingRecord.exit_time` 업데이트
2. 주차 시간 계산 (30분 단위, 초 단위 올림, 최소 1단위)
3. 할인 사유 결정 (정기권 직원 → 입주민 → 장애인 → 일반)
4. `Payment` 삽입

### 트리거 (8개)

| 트리거 | 시점 | 설명 |
|--------|------|------|
| `trg_spot_occupied_on_enter` | AFTER INSERT ParkingRecord | 입차 시 자리 점유 표시 |
| `trg_spot_released_on_exit` | AFTER UPDATE ParkingRecord | 출차 시 자리 해제 |
| `trg_no_double_entry` | BEFORE INSERT ParkingRecord | 같은 차량 이중 입차 차단 |
| `trg_block_unpaid_resident` | BEFORE INSERT ParkingRecord | 관리비 미납 입주민 입차 차단 |
| `trg_payment_consistency` | BEFORE INSERT Payment | 할인율 및 최종금액 일관성 검증 |
| `trg_payment_consistency_update` | BEFORE UPDATE Payment | 결제 수정 시 동일 일관성 검증 |
| `trg_season_pass_expire_insert` | BEFORE INSERT SeasonPass | 만료일 지난 정기권 비활성 처리 |
| `trg_season_pass_expire_update` | BEFORE UPDATE SeasonPass | 정기권 기간 변경 시 활성 상태 재계산 |

![트리거 목록](docs/screenshots/triggers.png)

### 뷰 (2개)

**`v_current_parked`** — 현재 주차 중인 차량 목록  
(입차 시간, 경과 분 포함 — 대시보드 실시간 조회에 사용)

**`v_hourly_congestion`** — 시간대별 입차 건수 집계  
(대시보드 혼잡도 차트에 사용)

![뷰 정의](docs/screenshots/views.png)

### 인덱스 (8개)

| 인덱스 | 대상 | 용도 |
|--------|------|------|
| `idx_pr_plate` | ParkingRecord.plate_number | 번호판으로 입출차 이력 조회 |
| `idx_pr_entry_time` | ParkingRecord.entry_time | 시간대별 혼잡도 집계 |
| `idx_pr_exit_null` | ParkingRecord.exit_time | 현재 주차 중인 차량 조회 |
| `idx_ps_lot_occupied` | ParkingSpot(lot_id, spot_type, is_occupied) | 빈 자리 검색 |
| `idx_ps_lot_floor_zone` | ParkingSpot(lot_id, floor, zone) | 평면도 렌더링 |
| `idx_sp_employee_active` | SeasonPass(employee_id, is_active) | 직원 정기권 확인 |
| `idx_amp_unit_paid` | AptMonthlyPayment(unit_id, is_paid) | 관리비 미납 확인 |
| `idx_pay_method` | Payment.method | 결제 수단별 집계 |

![인덱스 목록](docs/screenshots/indexes.png)

---

DB 계정은 두 개로 분리되어 있습니다.  
`parking_user` - 입차/출차 등 일반 사용자 요청 (SELECT, EXECUTE만 가능)  
`parking_admin` - 관리자가 통계 및 이력 조회 (전체 권한)

---

## 실행 방법

### 1. 저장소 클론

```bash
git clone https://github.com/gyulim2/parking.git
cd parking
```

### 2. DB 계정 및 스키마 세팅

`sql/` 폴더 파일을 **순서대로** 실행합니다.  
Windows는 인코딩 문제로 `--default-character-set=utf8mb4`를 붙여야 합니다.

```bash
# DB 계정 생성 (가장 먼저 실행)
mysql -u root -p --default-character-set=utf8mb4 < sql/00_mysql_users.sql

# 스키마, 트리거, 프로시저, 뷰, 인덱스, 데이터
mysql -u root -p --default-character-set=utf8mb4 < sql/01_schema.sql
mysql -u root -p --default-character-set=utf8mb4 < sql/02_triggers.sql
mysql -u root -p --default-character-set=utf8mb4 < sql/03_procedures.sql
mysql -u root -p --default-character-set=utf8mb4 < sql/04_views.sql
mysql -u root -p --default-character-set=utf8mb4 < sql/05_indexes.sql
mysql -u root -p --default-character-set=utf8mb4 < sql/06_dummy_data.sql
mysql -u root -p --default-character-set=utf8mb4 < sql/07_events.sql
```

### 3. 환경 변수 설정

```bash
cd backend
cp .env.example .env
```

`.env` 파일을 열어서 DB 접속 정보를 입력합니다.  
기본값은 `00_mysql_users.sql`에서 설정한 값과 동일합니다.

```
DB_ADMIN_USER=parking_admin
DB_ADMIN_PASSWORD=admin1234
DB_USER=parking_user
DB_PASSWORD=user1234
DB_HOST=localhost
DB_PORT=3306
DB_NAME=parking_db
FLASK_SECRET_KEY=길고-무작위한-문자열
APP_ENV=development
```

- `FLASK_SECRET_KEY`는 **필수**입니다. 없으면 서버가 시작되지 않습니다. (세션 서명 키가 코드에 기본값으로 있으면 누구나 관리자 세션을 위조할 수 있기 때문)
- `APP_ENV=development`는 **로컬 개발 전용**입니다. 이 값이 없으면 세션 쿠키가 HTTPS에서만 전송(`Secure`)되어 `http://localhost`에서는 로그인이 유지되지 않습니다. 운영(Railway)에서는 설정하지 마세요.

### 4. 패키지 설치 및 서버 실행

```bash
pip install -r requirements.txt
python app.py
```

`http://localhost:5001` 접속 (`PORT` 환경변수로 변경 가능)

---

## 테스트용 더미 데이터

- 차량 10대, 입출차 기록 10건, 결제 완료 8건
- 관리자 계정 : `admin` / `admin1234`

**A 백화점 주차장 (Lot 1)**
- 지하 1-3층, A-L구역, 구역당 50자리 (일반 42 + 장애인 3 + 전기차 5)
- 총 600자리

**B 아파트 주차장 (Lot 2)**
- 지하 1층, P-Y구역, 구역당 100자리 (일반 84 + 장애인 8 + 전기차 8)
- 총 1,000자리

---

## 보안 메모

- 모든 SQL은 파라미터 바인딩을 사용합니다. 사용자 입력이 쿼리 문자열에 직접 들어가지 않습니다.
- 번호판은 서버에서 형식(`12가3456`)을 검증하고, 관리자 화면은 서버 값을 이스케이프해서 출력합니다. (이전에는 번호판에 스크립트를 넣어 관리자 화면에서 실행시킬 수 있었던 문제를 수정)
- 관리자 API는 세션 인증(`admin_required`)이 필요하며, 오류 응답에는 내부 예외 메시지를 노출하지 않습니다.
- 위 계정 정보(`admin1234`, `user1234`)는 **로컬 데모용**입니다. 배포 전에 DB 계정과 관리자 비밀번호를 반드시 바꾸세요.

## 알려진 한계 / 개선 예정

- 관리자 비밀번호가 솔트 없는 `SHA2-256`으로 저장됩니다. `bcrypt`/`scrypt` 같은 느린 해시로 교체해야 합니다.
- 장애인·전기차 여부를 미등록 차량은 **자가 신고**로 받습니다. 실제 서비스라면 차량 등록 정보와 대조가 필요합니다.
- 관리자 로그인에 시도 횟수 제한이 없습니다.
- 자동화 테스트가 없습니다.
