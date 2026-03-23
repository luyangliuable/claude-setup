# Code Smell: Divergent Change

**Category:** Code Smells - Change Preventers
**Impact:** HIGH
**Difficulty to fix:** MEDIUM-HIGH

## Description

> Divergent change occurs when one class is commonly changed in different ways for different reasons. If you look at a class and say, "Well, I will have to change these three methods every time I get a new database; I have to change these four methods every time there is a new financial instrument," you likely have a situation in which two objects are better than one.
> -- *Refactoring* by Martin Fowler

A single class changes for multiple unrelated reasons - a direct violation of the Single Responsibility Principle.

## Why It's a Problem

- Changes for one reason might break another
- Hard to understand which parts relate to which concern
- Testing becomes complex
- Multiple developers may conflict on the same file
- Indicates poor separation of concerns

## Bad Example

```python
class Order:
    def __init__(self, items, customer):
        self.items = items
        self.customer = customer

    # Database concern - changes when DB schema changes
    def save_to_database(self):
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute(
            "INSERT INTO orders (customer_id, total) VALUES (?, ?)",
            (self.customer.id, self.calculate_total())
        )
        for item in self.items:
            cursor.execute(
                "INSERT INTO order_items (order_id, product_id, qty) ...",
                # ...
            )
        conn.commit()

    # Pricing concern - changes when pricing rules change
    def calculate_total(self):
        total = sum(item.price * item.quantity for item in self.items)
        if self.customer.is_premium:
            total *= 0.9  # Premium discount
        if len(self.items) > 10:
            total *= 0.95  # Bulk discount
        return total

    # Tax concern - changes when tax laws change
    def calculate_tax(self):
        if self.customer.country == 'US':
            return self.calculate_total() * 0.08
        elif self.customer.country == 'UK':
            return self.calculate_total() * 0.20
        # ... more countries

    # Notification concern - changes when notification channels change
    def send_confirmation(self):
        email_service.send(
            to=self.customer.email,
            subject="Order Confirmed",
            body=self._format_email_body()
        )
        if self.customer.wants_sms:
            sms_service.send(self.customer.phone, "Order confirmed!")
```

## Good Example

```python
# Each class has ONE reason to change

class Order:
    """Pure domain object - changes only when order concept changes"""
    def __init__(self, items, customer):
        self.items = items
        self.customer = customer

class OrderRepository:
    """Changes only when database schema/technology changes"""
    def save(self, order):
        # Database logic here
        pass

    def find_by_id(self, order_id):
        # Database logic here
        pass

class PricingService:
    """Changes only when pricing rules change"""
    def calculate_total(self, order):
        total = sum(item.price * item.quantity for item in order.items)
        return self._apply_discounts(total, order)

    def _apply_discounts(self, total, order):
        if order.customer.is_premium:
            total *= 0.9
        if len(order.items) > 10:
            total *= 0.95
        return total

class TaxCalculator:
    """Changes only when tax laws change"""
    def calculate(self, order, country):
        rates = {'US': 0.08, 'UK': 0.20, 'DE': 0.19}
        return order.total * rates.get(country, 0)

class OrderNotificationService:
    """Changes only when notification requirements change"""
    def send_confirmation(self, order):
        self._send_email(order)
        if order.customer.wants_sms:
            self._send_sms(order)
```

## How to Identify

Ask yourself: "What would cause me to change this class?"

If the answer includes multiple unrelated reasons like:
- "When the database changes"
- "When business rules change"
- "When the UI changes"
- "When notification channels change"

Then you have Divergent Change.

## How to Fix

1. **Extract Class**: Pull each concern into its own class
2. **Identify axes of change**: Group methods by what causes them to change
3. **Apply SRP**: Each class should have only one reason to change

## Related Concepts

- Single Responsibility Principle (SRP)
- Shotgun Surgery (opposite - one change affects many classes)
- Separation of Concerns
