from dataclasses import dataclass
from decimal import Decimal


@dataclass
class PaymentDTO:
    """DAO → Service → Controller: 정산 결과"""
    payment_id:      int
    record_id:       int
    raw_fee:         int
    discount_rate:   Decimal
    discount_reason: str   # 'none' | 'disabled' | 'season_pass' | 'resident_free'
    final_fee:       int
    method:          str   # 'season_pass' | 'resident_free' | 'card' | 'cash' | 'app'
