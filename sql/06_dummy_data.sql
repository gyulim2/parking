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
