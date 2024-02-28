from enum import Enum


class Status(Enum):
    PENDING = "pending"
    CANCEL = "cancel"

    ONTHEWAY = "on the way"
    DELIVERED = "delivered"


class PaymentMethod(Enum):
    ESEWA = "esewa"
    KHALTI = "khali"
    CASH = "cash"


STATUS_CHOICES = [
    (Status.CANCEL.value, "cancel"),
    (Status.PENDING.value, "pending"),
    (Status.ONTHEWAY.value, "on the way"),
    (Status.DELIVERED.value, "delivered"),
]
PAYMENT_METHOD = [
    (PaymentMethod.ESEWA.value, "esewa"),
    (PaymentMethod.KHALTI.value, "khalti"),
    (PaymentMethod.CASH.value, "cash"),
]
