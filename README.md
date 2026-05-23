# 이경규의 파킹랏
복합 시설물(백화점 + 아파트) 통합 주차 관리 시스템  
Flask + PyMySQL + HTML/CSS

---

## 실행 방법

### 1. 저장소 클론
```bash
git clone https://github.com/gyulim2/parking.git
cd parking
```

### 2. DB 세팅 (MySQL / MariaDB)

`sql/` 폴더 안 파일을 **순서대로** 실행합니다.

```bash
# MySQL (비밀번호 있는 경우)
mysql -u root -p < sql/01_schema.sql
mysql -u root -p < sql/02_triggers.sql
mysql -u root -p < sql/03_procedures.sql
mysql -u root -p < sql/04_views.sql
mysql -u root -p < sql/05_indexes.sql
mysql -u root -p < sql/06_dummy_data.sql
mysql -u root -p < sql/07_events.sql

# Mac Homebrew MariaDB (비밀번호 없는 경우)
mariadb -u $(whoami) < sql/01_schema.sql
mariadb -u $(whoami) < sql/02_triggers.sql
# ... 이하 동일
```

### 3. 환경 변수 설정
```bash
cd backend
cp .env.example .env
# .env 파일을 열어 본인 DB 접속 정보로 수정
```

### 4. 패키지 설치 및 서버 실행
```bash
cd backend
pip3 install -r requirements.txt
python3 app.py
```

브라우저에서 `http://localhost:5000` 접속

---

## 사이트 구조

| 페이지 | 경로 | 설명 |
|--------|------|------|
| 메인 | `/` | 사용자 / 오너 선택 |
| 입차 | `/user/enter.html` | 평면도 + 자동 배정 + 입차 |
| 출차 | `/user/exit.html` | 번호판 조회 + 정산 |
| 관리자 로그인 | `/admin/login.html` | 오너 인증번호: `1234` → 관리자 로그인 |
| 대시보드 | `/admin/dashboard.html` | 매출 통계 + 혼잡도 + 이력 조회 |

---

## SQL 파일 구성

| 파일 | 내용 |
|------|------|
| `01_schema.sql` | 테이블 DDL, FK, CHECK 제약 |
| `02_triggers.sql` | 트리거 6개 (점유 동기화, 미납 차단, 정산 일관성, 정기권 만료) |
| `03_procedures.sql` | 저장 프로시저 2개 (`sp_park_enter`, `sp_park_exit`) |
| `04_views.sql` | 뷰 1개 (`v_hourly_congestion`) |
| `05_indexes.sql` | 인덱스 8개 |
| `06_dummy_data.sql` | 테스트용 더미 데이터 |
| `07_events.sql` | 이벤트 1개 (정기권 만료 일배치) |

---

## 백엔드 구조

```
backend/
├── app.py              Flask 진입점 (정적 파일 서빙 포함)
├── config.py           DB 연결
├── auth.py             @admin_required 데코레이터
├── requirements.txt
├── .env.example        환경 변수 템플릿 (복사해서 .env 로 사용)
├── controllers/        라우팅 (API 엔드포인트)
├── services/           비즈니스 로직
├── dao/                DB 쿼리
└── dto/                데이터 구조 정의
```
