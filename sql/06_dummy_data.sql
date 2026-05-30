-- parking_db 테스트용 더미 데이터
--
-- 주차장 2개 / 자리 1600개 / 차량 10개 / 기록 10건(정산 8건)
--   Lot 1 (백화점): 지하1~3층, A~L구역, 구역당 50자리 (general 42 + disabled 3 + ev 5)
--   Lot 2 (아파트): 지하1층, P~Y구역, 구역당 100자리 (general 84 + disabled 8 + ev 8)

USE parking_db;

-- ============================================================
-- 1. ParkingLot
-- ============================================================
INSERT INTO ParkingLot (lot_id, name, lot_type) VALUES
    (1, 'A 백화점 주차장', 'department'),
    (2, 'B 아파트 주차장', 'apartment');

-- ============================================================
-- 2. ParkingSpot  (1600개)
--
--    spot_id 배치표:
--      Lot 1 (백화점, 600개)
--        지하1층: A(1~50)   B(51~100)  C(101~150) D(151~200)
--        지하2층: E(201~250) F(251~300) G(301~350) H(351~400)
--        지하3층: I(401~450) J(451~500) K(501~550) L(551~600)
--        구역당: general×42 + disabled×3 + ev×5 = 50
--
--      Lot 2 (아파트, 1000개, 지하1층만)
--        P(601~700)  Q(701~800)  R(801~900)  S(901~1000)
--        T(1001~1100) U(1101~1200) V(1201~1300) W(1301~1400)
--        X(1401~1500) Y(1501~1600)
--        구역당: general×84 + disabled×8 + ev×8 = 100
-- ============================================================
INSERT INTO ParkingSpot (lot_id, floor, zone, spot_type, is_occupied) VALUES
-- ══════════════════════════════════════════════════════════════
-- Lot 1  A 백화점 주차장  (spot 1~600)
-- ══════════════════════════════════════════════════════════════

-- ── 지하1층 ───────────────────────────────────────────────────
-- [Zone A] spots 1~50: general×42, disabled×3, ev×5
(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),
(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),
(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),
(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),
(1,-1,'A','general',FALSE),(1,-1,'A','general',FALSE),
(1,-1,'A','disabled',FALSE),(1,-1,'A','disabled',FALSE),(1,-1,'A','disabled',FALSE),
(1,-1,'A','ev',FALSE),(1,-1,'A','ev',FALSE),(1,-1,'A','ev',FALSE),(1,-1,'A','ev',FALSE),(1,-1,'A','ev',FALSE),
-- [Zone B] spots 51~100
(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),
(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),
(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),
(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),
(1,-1,'B','general',FALSE),(1,-1,'B','general',FALSE),
(1,-1,'B','disabled',FALSE),(1,-1,'B','disabled',FALSE),(1,-1,'B','disabled',FALSE),
(1,-1,'B','ev',FALSE),(1,-1,'B','ev',FALSE),(1,-1,'B','ev',FALSE),(1,-1,'B','ev',FALSE),(1,-1,'B','ev',FALSE),
-- [Zone C] spots 101~150
(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),
(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),
(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),
(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),
(1,-1,'C','general',FALSE),(1,-1,'C','general',FALSE),
(1,-1,'C','disabled',FALSE),(1,-1,'C','disabled',FALSE),(1,-1,'C','disabled',FALSE),
(1,-1,'C','ev',FALSE),(1,-1,'C','ev',FALSE),(1,-1,'C','ev',FALSE),(1,-1,'C','ev',FALSE),(1,-1,'C','ev',FALSE),
-- [Zone D] spots 151~200
(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),
(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),
(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),
(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),
(1,-1,'D','general',FALSE),(1,-1,'D','general',FALSE),
(1,-1,'D','disabled',FALSE),(1,-1,'D','disabled',FALSE),(1,-1,'D','disabled',FALSE),
(1,-1,'D','ev',FALSE),(1,-1,'D','ev',FALSE),(1,-1,'D','ev',FALSE),(1,-1,'D','ev',FALSE),(1,-1,'D','ev',FALSE),

-- ── 지하2층 ───────────────────────────────────────────────────
-- [Zone E] spots 201~250
(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),
(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),
(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),
(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),
(1,-2,'E','general',FALSE),(1,-2,'E','general',FALSE),
(1,-2,'E','disabled',FALSE),(1,-2,'E','disabled',FALSE),(1,-2,'E','disabled',FALSE),
(1,-2,'E','ev',FALSE),(1,-2,'E','ev',FALSE),(1,-2,'E','ev',FALSE),(1,-2,'E','ev',FALSE),(1,-2,'E','ev',FALSE),
-- [Zone F] spots 251~300
(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),
(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),
(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),
(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),
(1,-2,'F','general',FALSE),(1,-2,'F','general',FALSE),
(1,-2,'F','disabled',FALSE),(1,-2,'F','disabled',FALSE),(1,-2,'F','disabled',FALSE),
(1,-2,'F','ev',FALSE),(1,-2,'F','ev',FALSE),(1,-2,'F','ev',FALSE),(1,-2,'F','ev',FALSE),(1,-2,'F','ev',FALSE),
-- [Zone G] spots 301~350
(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),
(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),
(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),
(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),
(1,-2,'G','general',FALSE),(1,-2,'G','general',FALSE),
(1,-2,'G','disabled',FALSE),(1,-2,'G','disabled',FALSE),(1,-2,'G','disabled',FALSE),
(1,-2,'G','ev',FALSE),(1,-2,'G','ev',FALSE),(1,-2,'G','ev',FALSE),(1,-2,'G','ev',FALSE),(1,-2,'G','ev',FALSE),
-- [Zone H] spots 351~400
(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),
(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),
(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),
(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),
(1,-2,'H','general',FALSE),(1,-2,'H','general',FALSE),
(1,-2,'H','disabled',FALSE),(1,-2,'H','disabled',FALSE),(1,-2,'H','disabled',FALSE),
(1,-2,'H','ev',FALSE),(1,-2,'H','ev',FALSE),(1,-2,'H','ev',FALSE),(1,-2,'H','ev',FALSE),(1,-2,'H','ev',FALSE),

-- ── 지하3층 ───────────────────────────────────────────────────
-- [Zone I] spots 401~450
(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),
(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),
(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),
(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),
(1,-3,'I','general',FALSE),(1,-3,'I','general',FALSE),
(1,-3,'I','disabled',FALSE),(1,-3,'I','disabled',FALSE),(1,-3,'I','disabled',FALSE),
(1,-3,'I','ev',FALSE),(1,-3,'I','ev',FALSE),(1,-3,'I','ev',FALSE),(1,-3,'I','ev',FALSE),(1,-3,'I','ev',FALSE),
-- [Zone J] spots 451~500
(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),
(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),
(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),
(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),
(1,-3,'J','general',FALSE),(1,-3,'J','general',FALSE),
(1,-3,'J','disabled',FALSE),(1,-3,'J','disabled',FALSE),(1,-3,'J','disabled',FALSE),
(1,-3,'J','ev',FALSE),(1,-3,'J','ev',FALSE),(1,-3,'J','ev',FALSE),(1,-3,'J','ev',FALSE),(1,-3,'J','ev',FALSE),
-- [Zone K] spots 501~550
(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),
(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),
(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),
(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),
(1,-3,'K','general',FALSE),(1,-3,'K','general',FALSE),
(1,-3,'K','disabled',FALSE),(1,-3,'K','disabled',FALSE),(1,-3,'K','disabled',FALSE),
(1,-3,'K','ev',FALSE),(1,-3,'K','ev',FALSE),(1,-3,'K','ev',FALSE),(1,-3,'K','ev',FALSE),(1,-3,'K','ev',FALSE),
-- [Zone L] spots 551~600
(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),
(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),
(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),
(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),
(1,-3,'L','general',FALSE),(1,-3,'L','general',FALSE),
(1,-3,'L','disabled',FALSE),(1,-3,'L','disabled',FALSE),(1,-3,'L','disabled',FALSE),
(1,-3,'L','ev',FALSE),(1,-3,'L','ev',FALSE),(1,-3,'L','ev',FALSE),(1,-3,'L','ev',FALSE),(1,-3,'L','ev',FALSE),

-- ══════════════════════════════════════════════════════════════
-- Lot 2  B 아파트 주차장  (spot 601~1600, 지하1층만)
-- 10구역 × 100자리 = 1000  |  구역당: general×84 + disabled×8 + ev×8
-- ══════════════════════════════════════════════════════════════

-- [Zone P] spots 601~700
(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),
(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),
(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),
(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),
(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),
(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),
(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),
(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),
(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),(2,-1,'P','general',FALSE),
(2,-1,'P','disabled',FALSE),(2,-1,'P','disabled',FALSE),(2,-1,'P','disabled',FALSE),(2,-1,'P','disabled',FALSE),(2,-1,'P','disabled',FALSE),(2,-1,'P','disabled',FALSE),(2,-1,'P','disabled',FALSE),(2,-1,'P','disabled',FALSE),
(2,-1,'P','ev',FALSE),(2,-1,'P','ev',FALSE),(2,-1,'P','ev',FALSE),(2,-1,'P','ev',FALSE),(2,-1,'P','ev',FALSE),(2,-1,'P','ev',FALSE),(2,-1,'P','ev',FALSE),(2,-1,'P','ev',FALSE),
-- [Zone Q] spots 701~800
(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),
(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),
(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),
(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),
(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),
(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),
(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),
(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),
(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),(2,-1,'Q','general',FALSE),
(2,-1,'Q','disabled',FALSE),(2,-1,'Q','disabled',FALSE),(2,-1,'Q','disabled',FALSE),(2,-1,'Q','disabled',FALSE),(2,-1,'Q','disabled',FALSE),(2,-1,'Q','disabled',FALSE),(2,-1,'Q','disabled',FALSE),(2,-1,'Q','disabled',FALSE),
(2,-1,'Q','ev',FALSE),(2,-1,'Q','ev',FALSE),(2,-1,'Q','ev',FALSE),(2,-1,'Q','ev',FALSE),(2,-1,'Q','ev',FALSE),(2,-1,'Q','ev',FALSE),(2,-1,'Q','ev',FALSE),(2,-1,'Q','ev',FALSE),
-- [Zone R] spots 801~900
(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),
(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),
(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),
(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),
(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),
(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),
(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),
(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),
(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),(2,-1,'R','general',FALSE),
(2,-1,'R','disabled',FALSE),(2,-1,'R','disabled',FALSE),(2,-1,'R','disabled',FALSE),(2,-1,'R','disabled',FALSE),(2,-1,'R','disabled',FALSE),(2,-1,'R','disabled',FALSE),(2,-1,'R','disabled',FALSE),(2,-1,'R','disabled',FALSE),
(2,-1,'R','ev',FALSE),(2,-1,'R','ev',FALSE),(2,-1,'R','ev',FALSE),(2,-1,'R','ev',FALSE),(2,-1,'R','ev',FALSE),(2,-1,'R','ev',FALSE),(2,-1,'R','ev',FALSE),(2,-1,'R','ev',FALSE),
-- [Zone S] spots 901~1000
(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),
(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),
(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),
(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),
(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),
(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),
(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),
(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),
(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),(2,-1,'S','general',FALSE),
(2,-1,'S','disabled',FALSE),(2,-1,'S','disabled',FALSE),(2,-1,'S','disabled',FALSE),(2,-1,'S','disabled',FALSE),(2,-1,'S','disabled',FALSE),(2,-1,'S','disabled',FALSE),(2,-1,'S','disabled',FALSE),(2,-1,'S','disabled',FALSE),
(2,-1,'S','ev',FALSE),(2,-1,'S','ev',FALSE),(2,-1,'S','ev',FALSE),(2,-1,'S','ev',FALSE),(2,-1,'S','ev',FALSE),(2,-1,'S','ev',FALSE),(2,-1,'S','ev',FALSE),(2,-1,'S','ev',FALSE),
-- [Zone T] spots 1001~1100
(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),
(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),
(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),
(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),
(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),
(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),
(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),
(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),
(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),(2,-1,'T','general',FALSE),
(2,-1,'T','disabled',FALSE),(2,-1,'T','disabled',FALSE),(2,-1,'T','disabled',FALSE),(2,-1,'T','disabled',FALSE),(2,-1,'T','disabled',FALSE),(2,-1,'T','disabled',FALSE),(2,-1,'T','disabled',FALSE),(2,-1,'T','disabled',FALSE),
(2,-1,'T','ev',FALSE),(2,-1,'T','ev',FALSE),(2,-1,'T','ev',FALSE),(2,-1,'T','ev',FALSE),(2,-1,'T','ev',FALSE),(2,-1,'T','ev',FALSE),(2,-1,'T','ev',FALSE),(2,-1,'T','ev',FALSE),
-- [Zone U] spots 1101~1200
(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),
(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),
(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),
(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),
(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),
(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),
(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),
(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),
(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),(2,-1,'U','general',FALSE),
(2,-1,'U','disabled',FALSE),(2,-1,'U','disabled',FALSE),(2,-1,'U','disabled',FALSE),(2,-1,'U','disabled',FALSE),(2,-1,'U','disabled',FALSE),(2,-1,'U','disabled',FALSE),(2,-1,'U','disabled',FALSE),(2,-1,'U','disabled',FALSE),
(2,-1,'U','ev',FALSE),(2,-1,'U','ev',FALSE),(2,-1,'U','ev',FALSE),(2,-1,'U','ev',FALSE),(2,-1,'U','ev',FALSE),(2,-1,'U','ev',FALSE),(2,-1,'U','ev',FALSE),(2,-1,'U','ev',FALSE),
-- [Zone V] spots 1201~1300
(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),
(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),
(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),
(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),
(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),
(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),
(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),
(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),
(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),(2,-1,'V','general',FALSE),
(2,-1,'V','disabled',FALSE),(2,-1,'V','disabled',FALSE),(2,-1,'V','disabled',FALSE),(2,-1,'V','disabled',FALSE),(2,-1,'V','disabled',FALSE),(2,-1,'V','disabled',FALSE),(2,-1,'V','disabled',FALSE),(2,-1,'V','disabled',FALSE),
(2,-1,'V','ev',FALSE),(2,-1,'V','ev',FALSE),(2,-1,'V','ev',FALSE),(2,-1,'V','ev',FALSE),(2,-1,'V','ev',FALSE),(2,-1,'V','ev',FALSE),(2,-1,'V','ev',FALSE),(2,-1,'V','ev',FALSE),
-- [Zone W] spots 1301~1400
(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),
(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),
(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),
(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),
(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),
(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),
(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),
(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),
(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),(2,-1,'W','general',FALSE),
(2,-1,'W','disabled',FALSE),(2,-1,'W','disabled',FALSE),(2,-1,'W','disabled',FALSE),(2,-1,'W','disabled',FALSE),(2,-1,'W','disabled',FALSE),(2,-1,'W','disabled',FALSE),(2,-1,'W','disabled',FALSE),(2,-1,'W','disabled',FALSE),
(2,-1,'W','ev',FALSE),(2,-1,'W','ev',FALSE),(2,-1,'W','ev',FALSE),(2,-1,'W','ev',FALSE),(2,-1,'W','ev',FALSE),(2,-1,'W','ev',FALSE),(2,-1,'W','ev',FALSE),(2,-1,'W','ev',FALSE),
-- [Zone X] spots 1401~1500
(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),
(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),
(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),
(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),
(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),
(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),
(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),
(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),
(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),(2,-1,'X','general',FALSE),
(2,-1,'X','disabled',FALSE),(2,-1,'X','disabled',FALSE),(2,-1,'X','disabled',FALSE),(2,-1,'X','disabled',FALSE),(2,-1,'X','disabled',FALSE),(2,-1,'X','disabled',FALSE),(2,-1,'X','disabled',FALSE),(2,-1,'X','disabled',FALSE),
(2,-1,'X','ev',FALSE),(2,-1,'X','ev',FALSE),(2,-1,'X','ev',FALSE),(2,-1,'X','ev',FALSE),(2,-1,'X','ev',FALSE),(2,-1,'X','ev',FALSE),(2,-1,'X','ev',FALSE),(2,-1,'X','ev',FALSE),
-- [Zone Y] spots 1501~1600
(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),
(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),
(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),
(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),
(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),
(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),
(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),
(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),
(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),(2,-1,'Y','general',FALSE),
(2,-1,'Y','disabled',FALSE),(2,-1,'Y','disabled',FALSE),(2,-1,'Y','disabled',FALSE),(2,-1,'Y','disabled',FALSE),(2,-1,'Y','disabled',FALSE),(2,-1,'Y','disabled',FALSE),(2,-1,'Y','disabled',FALSE),(2,-1,'Y','disabled',FALSE),
(2,-1,'Y','ev',FALSE),(2,-1,'Y','ev',FALSE),(2,-1,'Y','ev',FALSE),(2,-1,'Y','ev',FALSE),(2,-1,'Y','ev',FALSE),(2,-1,'Y','ev',FALSE),(2,-1,'Y','ev',FALSE),(2,-1,'Y','ev',FALSE);

-- ============================================================
-- 3. Vehicle
-- ============================================================
INSERT INTO Vehicle (plate_number, is_disabled, is_ev) VALUES
    ('12가3456', FALSE, FALSE),  -- 백화점 직원1
    ('34나5678', FALSE, FALSE),  -- 백화점 직원2
    ('56다7890', FALSE, TRUE),   -- 백화점 직원3 (전기차)
    ('78라1234', FALSE, FALSE),  -- 아파트 입주민1
    ('90마5678', FALSE, TRUE),   -- 아파트 입주민2 (전기차)
    ('11바9012', TRUE,  FALSE),  -- 아파트 입주민3 (장애인, 미납 세대)
    ('22사3456', FALSE, FALSE),  -- 일반 방문객
    ('33아7890', FALSE, FALSE),  -- 일반 방문객 (현재 주차 중)
    ('44자1234', TRUE,  FALSE),  -- 장애인 방문객
    ('55차5678', FALSE, TRUE);   -- 전기차 방문객 (현재 주차 중)

-- ============================================================
-- 4. DeptEmployee
-- ============================================================
INSERT INTO DeptEmployee (employee_id, plate_number, lot_id) VALUES
    (1, '12가3456', 1),
    (2, '34나5678', 1),
    (3, '56다7890', 1);

-- ============================================================
-- 5. SeasonPass
-- ============================================================
INSERT INTO SeasonPass (employee_id, start_date, end_date, is_active, monthly_fee) VALUES
    (1, '2025-01-01', '2026-06-30', TRUE,  100000),  -- 유효
    (2, '2025-03-01', '2026-05-31', TRUE,  100000),  -- 유효
    (3, '2024-01-01', '2024-12-31', FALSE, 100000);  -- 만료

-- ============================================================
-- 6. AptUnit
-- ============================================================
INSERT INTO AptUnit (unit_id, lot_id, unit_number, monthly_fee) VALUES
    (1, 2, '101동 501호', 50000),
    (2, 2, '102동 301호', 50000),
    (3, 2, '103동 201호', 50000);   -- 5월 미납!

-- ============================================================
-- 7. AptResident
-- ============================================================
INSERT INTO AptResident (resident_id, plate_number, unit_id) VALUES
    (1, '78라1234', 1),
    (2, '90마5678', 2),
    (3, '11바9012', 3);

-- ============================================================
-- 8. AptMonthlyPayment
-- ============================================================
INSERT INTO AptMonthlyPayment (unit_id, billing_month, is_paid) VALUES
    (1, '2026-04-01', TRUE),
    (1, '2026-05-01', TRUE),
    (2, '2026-04-01', TRUE),
    (2, '2026-05-01', TRUE),
    (3, '2026-04-01', TRUE),
    (3, '2026-05-01', FALSE);   -- ★ 미납

-- ============================================================
-- 9. ParkingRecord  (입출차 기록 10개)
--
--    spot_id 대응표 (1600자리 기준):
--      Lot 1 백화점 spot 1~600
--        spot   1 = Zone A general   ← record 1 (직원1)
--        spot   2 = Zone A general   ← record 2 (직원2)
--        spot  46 = Zone A ev        ← record 3 (직원3, 전기차)  [A: general1~42, disabled43~45, ev46~50]
--        spot  51 = Zone B general   ← record 7 (일반방문객)
--        spot  52 = Zone B general   ← record 9 (현재주차중)     [B: general51~92, disabled93~95, ev96~100]
--        spot  93 = Zone B disabled  ← record 8 (장애인방문객)
--      Lot 2 아파트 spot 601~1600
--        spot 601 = Zone P general   ← record 4 (입주민1)        [P: general601~684, disabled685~692, ev693~700]
--        spot 685 = Zone P disabled  ← record 6 (입주민3, 장애인)
--        spot 693 = Zone P ev        ← record 5 (입주민2, 전기차)
--        spot 694 = Zone P ev        ← record 10 (현재주차중)
-- ============================================================
INSERT INTO ParkingRecord
    (record_id, plate_number, spot_id, visit_unit_id, user_type, entry_time, exit_time)
VALUES
    -- ── 완료된 기록 (8개) ──────────────────────────────────
    (1,  '12가3456',   1, NULL, 'employee', '2026-05-12 09:00:00', '2026-05-12 18:00:00'),
    (2,  '34나5678',   2, NULL, 'employee', '2026-05-12 08:30:00', '2026-05-12 17:30:00'),
    (3,  '56다7890',  46, NULL, 'employee', '2026-05-12 09:15:00', '2026-05-12 18:15:00'),
    (4,  '78라1234', 601, NULL, 'resident', '2026-05-12 08:00:00', '2026-05-12 20:00:00'),
    (5,  '90마5678', 693, NULL, 'resident', '2026-05-12 07:50:00', '2026-05-12 21:00:00'),
    (6,  '11바9012', 685, NULL, 'resident', '2026-05-12 10:00:00', '2026-05-12 15:00:00'),
    (7,  '22사3456',  51, NULL, 'general',  '2026-05-12 11:00:00', '2026-05-12 13:30:00'),
    (8,  '44자1234',  93, NULL, 'general',  '2026-05-12 13:00:00', '2026-05-12 14:00:00'),

    -- ── 현재 주차 중 (2개, exit_time=NULL) ─────────────────
    (9,  '33아7890',  52, NULL, 'general',  '2026-05-13 09:00:00', NULL),
    (10, '55차5678', 694,    1, 'visitor',  '2026-05-13 10:30:00', NULL);

-- ============================================================
-- 10. Payment  (정산 8건)
-- ============================================================
INSERT INTO Payment
    (payment_id, record_id, raw_fee, discount_rate, discount_reason, final_fee, method)
VALUES
    (1, 1, 54000, 1.00, 'season_pass',   0, 'season_pass'),
    (2, 2, 54000, 1.00, 'season_pass',   0, 'season_pass'),
    (3, 3, 54000, 0.00, 'none',      54000, 'card'),
    (4, 4, 72000, 1.00, 'resident_free', 0, 'resident_free'),
    (5, 5, 81000, 1.00, 'resident_free', 0, 'resident_free'),
    (6, 6, 30000, 1.00, 'resident_free', 0, 'resident_free'),
    (7, 7, 15000, 0.00, 'none',      15000, 'card'),
    (8, 8,  6000, 0.50, 'disabled',   3000, 'card');

-- 관리자 계정 (비밀번호: admin1234)
INSERT INTO AppUser (user_id, pwd_hash, role)
VALUES ('admin', SHA2('admin1234', 256), 'admin');

-- ============================================================
-- 추가 더미 데이터: 2026년 5월 한 달치
-- record_id 11~72, payment_id 9~70
-- ============================================================

-- ============================================================
-- ParkingRecord (입출차 기록 62개)
-- ============================================================
INSERT IGNORE INTO ParkingRecord
    (record_id, plate_number, spot_id, visit_unit_id, user_type, entry_time, exit_time)
VALUES
-- ── 1주차: 5/1(목) ~ 5/4(일) ──────────────────────────────
(11, '12가3456',   3, NULL, 'employee', '2026-05-01 09:00:00', '2026-05-01 18:00:00'),
(12, '78라1234', 602, NULL, 'resident', '2026-05-01 08:00:00', '2026-05-01 20:00:00'),
(13, '34나5678',   4, NULL, 'employee', '2026-05-02 08:30:00', '2026-05-02 17:30:00'),
(14, '22사3456',  53, NULL, 'general',  '2026-05-02 10:00:00', '2026-05-02 13:00:00'),
(15, '55차5678',  54, NULL, 'general',  '2026-05-02 14:00:00', '2026-05-02 16:00:00'),
(16, '12가3456',   5, NULL, 'employee', '2026-05-03 09:00:00', '2026-05-03 18:00:00'),
(17, '44자1234',  93, NULL, 'general',  '2026-05-03 13:00:00', '2026-05-03 15:00:00'),
(18, '90마5678', 603, NULL, 'resident', '2026-05-04 10:00:00', '2026-05-04 18:00:00'),

-- ── 2주차: 5/5(월) ~ 5/11(일) ─────────────────────────────
(19, '12가3456',   6, NULL, 'employee', '2026-05-05 09:00:00', '2026-05-05 18:00:00'),
(20, '34나5678',   7, NULL, 'employee', '2026-05-05 08:30:00', '2026-05-05 17:30:00'),
(21, '22사3456',  55, NULL, 'general',  '2026-05-05 10:00:00', '2026-05-05 14:00:00'),
(22, '56다7890',   8, NULL, 'employee', '2026-05-06 09:00:00', '2026-05-06 18:00:00'),
(23, '78라1234', 604, NULL, 'resident', '2026-05-06 08:00:00', '2026-05-06 17:00:00'),
(24, '12가3456',   9, NULL, 'employee', '2026-05-07 09:00:00', '2026-05-07 18:00:00'),
(25, '22사3456',  56, NULL, 'general',  '2026-05-07 11:00:00', '2026-05-07 13:30:00'),
(26, '90마5678', 605, NULL, 'resident', '2026-05-07 09:00:00', '2026-05-07 19:00:00'),
(27, '34나5678',  10, NULL, 'employee', '2026-05-08 08:30:00', '2026-05-08 17:30:00'),
(28, '44자1234',  94, NULL, 'general',  '2026-05-08 13:00:00', '2026-05-08 15:00:00'),
(29, '12가3456',   3, NULL, 'employee', '2026-05-09 09:00:00', '2026-05-09 18:00:00'),
(30, '56다7890',   4, NULL, 'employee', '2026-05-09 09:15:00', '2026-05-09 18:15:00'),
(31, '55차5678',  57, NULL, 'general',  '2026-05-10 10:00:00', '2026-05-10 13:00:00'),
(32, '78라1234', 606, NULL, 'resident', '2026-05-11 09:00:00', '2026-05-11 18:00:00'),

-- ── 3주차: 5/13(화) ~ 5/18(일)  ── 5/12는 기존 데이터 있음 ──
(33, '12가3456',   5, NULL, 'employee', '2026-05-13 09:00:00', '2026-05-13 18:00:00'),
(34, '34나5678',   6, NULL, 'employee', '2026-05-13 08:30:00', '2026-05-13 17:30:00'),
(35, '22사3456',  58, NULL, 'general',  '2026-05-13 10:00:00', '2026-05-13 13:00:00'),
(36, '12가3456',   7, NULL, 'employee', '2026-05-14 09:00:00', '2026-05-14 18:00:00'),
(37, '78라1234', 607, NULL, 'resident', '2026-05-14 08:00:00', '2026-05-14 19:00:00'),
(38, '44자1234',  93, NULL, 'general',  '2026-05-14 13:00:00', '2026-05-14 15:00:00'),
(39, '34나5678',   8, NULL, 'employee', '2026-05-15 08:30:00', '2026-05-15 17:30:00'),
(40, '56다7890',   9, NULL, 'employee', '2026-05-15 09:00:00', '2026-05-15 18:00:00'),
(41, '22사3456',  59, NULL, 'general',  '2026-05-15 10:00:00', '2026-05-15 14:00:00'),
(42, '90마5678', 608, NULL, 'resident', '2026-05-15 09:00:00', '2026-05-15 18:00:00'),
(43, '12가3456',  10, NULL, 'employee', '2026-05-16 09:00:00', '2026-05-16 18:00:00'),
(44, '55차5678',  60, NULL, 'general',  '2026-05-16 11:00:00', '2026-05-16 14:00:00'),
(45, '22사3456',  53, NULL, 'general',  '2026-05-16 14:00:00', '2026-05-16 17:00:00'),
(46, '78라1234', 609, NULL, 'resident', '2026-05-17 10:00:00', '2026-05-17 17:00:00'),
(47, '44자1234',  94, NULL, 'general',  '2026-05-17 13:00:00', '2026-05-17 16:00:00'),
(48, '12가3456',   3, NULL, 'employee', '2026-05-18 09:00:00', '2026-05-18 17:00:00'),

-- ── 4주차: 5/19(월) ~ 5/24(토) ────────────────────────────
(49, '12가3456',   4, NULL, 'employee', '2026-05-19 09:00:00', '2026-05-19 18:00:00'),
(50, '34나5678',   5, NULL, 'employee', '2026-05-19 08:30:00', '2026-05-19 17:30:00'),
(51, '22사3456',  54, NULL, 'general',  '2026-05-19 10:00:00', '2026-05-19 13:00:00'),
(52, '78라1234', 610, NULL, 'resident', '2026-05-19 08:00:00', '2026-05-19 19:00:00'),
(53, '12가3456',   6, NULL, 'employee', '2026-05-20 09:00:00', '2026-05-20 18:00:00'),
(54, '56다7890',   7, NULL, 'employee', '2026-05-20 09:00:00', '2026-05-20 18:00:00'),
(55, '44자1234',  93, NULL, 'general',  '2026-05-20 13:00:00', '2026-05-20 15:30:00'),
(56, '90마5678', 695, NULL, 'resident', '2026-05-20 09:00:00', '2026-05-20 18:00:00'),
(57, '12가3456',   8, NULL, 'employee', '2026-05-21 09:00:00', '2026-05-21 18:00:00'),
(58, '34나5678',   9, NULL, 'employee', '2026-05-21 08:30:00', '2026-05-21 17:30:00'),
(59, '22사3456',  55, NULL, 'general',  '2026-05-21 10:00:00', '2026-05-21 14:00:00'),
(60, '55차5678',  56, NULL, 'general',  '2026-05-21 14:00:00', '2026-05-21 17:00:00'),
(61, '12가3456',  10, NULL, 'employee', '2026-05-22 09:00:00', '2026-05-22 18:00:00'),
(62, '78라1234', 602, NULL, 'resident', '2026-05-22 08:00:00', '2026-05-22 18:00:00'),
(63, '22사3456',  57, NULL, 'general',  '2026-05-22 10:00:00', '2026-05-22 14:00:00'),
(64, '44자1234',  94, NULL, 'general',  '2026-05-22 13:00:00', '2026-05-22 16:00:00'),
(65, '12가3456',   3, NULL, 'employee', '2026-05-23 09:00:00', '2026-05-23 18:00:00'),
(66, '34나5678',   4, NULL, 'employee', '2026-05-23 08:30:00', '2026-05-23 17:30:00'),
(67, '56다7890',   5, NULL, 'employee', '2026-05-23 09:00:00', '2026-05-23 18:00:00'),
(68, '22사3456',  58, NULL, 'general',  '2026-05-23 11:00:00', '2026-05-23 14:00:00'),
(69, '90마5678', 603, NULL, 'resident', '2026-05-23 09:00:00', '2026-05-23 19:00:00'),
(70, '12가3456',   6, NULL, 'employee', '2026-05-24 09:00:00', '2026-05-24 18:00:00'),
(71, '55차5678',  59, NULL, 'general',  '2026-05-24 10:00:00', '2026-05-24 12:00:00'),
(72, '44자1234',  93, NULL, 'general',  '2026-05-24 13:00:00', '2026-05-24 15:00:00');

-- ============================================================
-- Payment (정산 62건)
-- 요금 기준: 6,000원/시간  |  장애인 50% 할인
-- 직원1,2(season_pass) → final 0원  |  직원3(만료) → card 정가
-- 입주민 → resident_free 0원
-- ============================================================
INSERT IGNORE INTO Payment
    (payment_id, record_id, raw_fee, discount_rate, discount_reason, final_fee, method)
VALUES
-- 1주차
( 9, 11, 54000, 1.00, 'season_pass',    0, 'season_pass'),
(10, 12, 72000, 1.00, 'resident_free',  0, 'resident_free'),
(11, 13, 54000, 1.00, 'season_pass',    0, 'season_pass'),
(12, 14, 18000, 0.00, 'none',       18000, 'card'),
(13, 15, 12000, 0.00, 'none',       12000, 'card'),
(14, 16, 54000, 1.00, 'season_pass',    0, 'season_pass'),
(15, 17, 12000, 0.50, 'disabled',    6000, 'card'),
(16, 18, 48000, 1.00, 'resident_free',  0, 'resident_free'),

-- 2주차
(17, 19, 54000, 1.00, 'season_pass',    0, 'season_pass'),
(18, 20, 54000, 1.00, 'season_pass',    0, 'season_pass'),
(19, 21, 24000, 0.00, 'none',       24000, 'card'),
(20, 22, 54000, 0.00, 'none',       54000, 'card'),
(21, 23, 54000, 1.00, 'resident_free',  0, 'resident_free'),
(22, 24, 54000, 1.00, 'season_pass',    0, 'season_pass'),
(23, 25, 15000, 0.00, 'none',       15000, 'card'),
(24, 26, 60000, 1.00, 'resident_free',  0, 'resident_free'),
(25, 27, 54000, 1.00, 'season_pass',    0, 'season_pass'),
(26, 28, 12000, 0.50, 'disabled',    6000, 'card'),
(27, 29, 54000, 1.00, 'season_pass',    0, 'season_pass'),
(28, 30, 54000, 0.00, 'none',       54000, 'card'),
(29, 31, 18000, 0.00, 'none',       18000, 'card'),
(30, 32, 54000, 1.00, 'resident_free',  0, 'resident_free'),

-- 3주차
(31, 33, 54000, 1.00, 'season_pass',    0, 'season_pass'),
(32, 34, 54000, 1.00, 'season_pass',    0, 'season_pass'),
(33, 35, 18000, 0.00, 'none',       18000, 'card'),
(34, 36, 54000, 1.00, 'season_pass',    0, 'season_pass'),
(35, 37, 66000, 1.00, 'resident_free',  0, 'resident_free'),
(36, 38, 12000, 0.50, 'disabled',    6000, 'card'),
(37, 39, 54000, 1.00, 'season_pass',    0, 'season_pass'),
(38, 40, 54000, 0.00, 'none',       54000, 'card'),
(39, 41, 24000, 0.00, 'none',       24000, 'card'),
(40, 42, 54000, 1.00, 'resident_free',  0, 'resident_free'),
(41, 43, 54000, 1.00, 'season_pass',    0, 'season_pass'),
(42, 44, 18000, 0.00, 'none',       18000, 'card'),
(43, 45, 18000, 0.00, 'none',       18000, 'card'),
(44, 46, 42000, 1.00, 'resident_free',  0, 'resident_free'),
(45, 47, 18000, 0.50, 'disabled',    9000, 'card'),
(46, 48, 48000, 1.00, 'season_pass',    0, 'season_pass'),

-- 4주차
(47, 49, 54000, 1.00, 'season_pass',    0, 'season_pass'),
(48, 50, 54000, 1.00, 'season_pass',    0, 'season_pass'),
(49, 51, 18000, 0.00, 'none',       18000, 'card'),
(50, 52, 66000, 1.00, 'resident_free',  0, 'resident_free'),
(51, 53, 54000, 1.00, 'season_pass',    0, 'season_pass'),
(52, 54, 54000, 0.00, 'none',       54000, 'card'),
(53, 55, 15000, 0.50, 'disabled',    7500, 'card'),
(54, 56, 54000, 1.00, 'resident_free',  0, 'resident_free'),
(55, 57, 54000, 1.00, 'season_pass',    0, 'season_pass'),
(56, 58, 54000, 1.00, 'season_pass',    0, 'season_pass'),
(57, 59, 24000, 0.00, 'none',       24000, 'card'),
(58, 60, 18000, 0.00, 'none',       18000, 'card'),
(59, 61, 54000, 1.00, 'season_pass',    0, 'season_pass'),
(60, 62, 60000, 1.00, 'resident_free',  0, 'resident_free'),
(61, 63, 24000, 0.00, 'none',       24000, 'card'),
(62, 64, 18000, 0.50, 'disabled',    9000, 'card'),
(63, 65, 54000, 1.00, 'season_pass',    0, 'season_pass'),
(64, 66, 54000, 1.00, 'season_pass',    0, 'season_pass'),
(65, 67, 54000, 0.00, 'none',       54000, 'card'),
(66, 68, 18000, 0.00, 'none',       18000, 'card'),
(67, 69, 60000, 1.00, 'resident_free',  0, 'resident_free'),
(68, 70, 54000, 1.00, 'season_pass',    0, 'season_pass'),
(69, 71, 12000, 0.00, 'none',       12000, 'card'),
(70, 72, 12000, 0.50, 'disabled',    6000, 'card');
