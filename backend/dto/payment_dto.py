from dataclasses import dataclass
from decimal import Decimal


@dataclass
class PaymentDTO:
    payment_id:      int
    record_id:       int
    raw_fee:         int
    discount_rate:   Decimal
    discount_reason: str
    final_fee:       int
    method:          str
