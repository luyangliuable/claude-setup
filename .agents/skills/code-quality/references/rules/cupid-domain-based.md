# CUPID: Domain-Based

**Category:** CUPID Properties
**Impact:** HIGH
**Difficulty to fix:** MEDIUM-HIGH

## Rule

> Code should model the problem domain clearly. Names, structures, and behaviors should reflect the business concepts they represent.

The code should speak the language of the business, not just the language of the technology.

## Why It Matters

- Bridges communication between developers and domain experts
- Makes code self-documenting
- Reduces translation errors between requirements and implementation
- Enables non-technical stakeholders to validate logic

## Bad Example

```python
# Technical names that don't reflect the domain
class DataProcessor:
    def process(self, data_dict):
        result = []
        for item in data_dict['items']:
            if item['flag1'] and item['val'] > 100:
                obj = {
                    'id': item['id'],
                    'computed': item['val'] * 0.1,
                    'status': 'A'
                }
                result.append(obj)
        return result

# What is this actually doing? What business rules apply?
```

## Good Example

```python
# Domain-driven names that tell the story
class OrderFulfillmentService:
    def identify_orders_eligible_for_discount(self, orders):
        eligible_orders = []
        for order in orders:
            if order.is_premium_customer and order.total > DISCOUNT_THRESHOLD:
                discounted_order = DiscountedOrder(
                    order_id=order.id,
                    discount_amount=order.total * PREMIUM_DISCOUNT_RATE,
                    status=OrderStatus.PENDING_DISCOUNT_APPROVAL
                )
                eligible_orders.append(discounted_order)
        return eligible_orders

# Constants with business meaning
DISCOUNT_THRESHOLD = Money(100, 'USD')
PREMIUM_DISCOUNT_RATE = Decimal('0.10')  # 10% discount

# Enums for domain concepts
class OrderStatus(Enum):
    PENDING = 'pending'
    PENDING_DISCOUNT_APPROVAL = 'pending_discount_approval'
    APPROVED = 'approved'
    SHIPPED = 'shipped'
```

## Domain Objects vs Primitives

```python
# Bad: Primitive obsession
def calculate_shipping(weight, distance, is_express):
    # weight in kg? lbs? distance in miles? km?
    pass

# Good: Domain objects
@dataclass
class Weight:
    value: Decimal
    unit: Literal['kg', 'lbs']

    def to_kg(self):
        if self.unit == 'kg':
            return self.value
        return self.value * Decimal('0.453592')

@dataclass
class Distance:
    value: Decimal
    unit: Literal['km', 'miles']

class ShippingMethod(Enum):
    STANDARD = 'standard'
    EXPRESS = 'express'

def calculate_shipping(weight: Weight, distance: Distance, method: ShippingMethod):
    # Clear what units and types are expected
    pass
```

## Detection

- Generic names like "data", "item", "obj", "val", "flag"
- Magic numbers without business meaning
- Code that requires documentation to explain business rules
- Mismatch between code terminology and business terminology
- Primitive types used for domain concepts (string for email, int for money)

## How to Fix

1. Create a ubiquitous language with domain experts
2. Use that language consistently in code
3. Replace primitives with domain value objects
4. Name classes after domain concepts, not technical patterns
5. Use enums for domain-specific states and categories
