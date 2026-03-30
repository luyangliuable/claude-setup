# Code Smell: Feature Envy

**Category:** Code Smells - Couplers
**Impact:** HIGH
**Difficulty to fix:** MEDIUM

## Description

> A method that seems more interested in a class other than the one it actually is in. The most common focus of the envy is the data. We've lost count of the times we've seen a method that invokes half-a-dozen getting methods on another object to calculate some value.
> -- *Refactoring* by Martin Fowler

When a method uses more features of another class than its own, it probably belongs in that other class.

## Why It's a Problem

- Violates encapsulation
- Logic is in the wrong place
- Creates tight coupling between classes
- Makes maintenance harder
- Often duplicated in multiple places

## Bad Example

```python
class Order:
    def __init__(self):
        self.customer = None
        self.items = []

class OrderPrinter:
    def print_order(self, order):
        # This method is WAY too interested in Order's internals
        print(f"Customer: {order.customer.name}")
        print(f"Address: {order.customer.address.street}")
        print(f"City: {order.customer.address.city}")
        print(f"Items:")

        total = 0
        for item in order.items:
            line_total = item.quantity * item.product.price
            discount = item.product.discount_percent / 100
            line_total = line_total * (1 - discount)
            total += line_total
            print(f"  {item.product.name}: ${line_total:.2f}")

        tax = total * 0.1
        print(f"Subtotal: ${total:.2f}")
        print(f"Tax: ${tax:.2f}")
        print(f"Total: ${total + tax:.2f}")
```

## Good Example

```python
class Product:
    def __init__(self, name, price, discount_percent=0):
        self.name = name
        self.price = price
        self.discount_percent = discount_percent

    def discounted_price(self):
        return self.price * (1 - self.discount_percent / 100)

class OrderItem:
    def __init__(self, product, quantity):
        self.product = product
        self.quantity = quantity

    def line_total(self):
        return self.quantity * self.product.discounted_price()

class Order:
    TAX_RATE = 0.1

    def __init__(self, customer):
        self.customer = customer
        self.items = []

    def subtotal(self):
        return sum(item.line_total() for item in self.items)

    def tax(self):
        return self.subtotal() * self.TAX_RATE

    def total(self):
        return self.subtotal() + self.tax()

    def formatted_items(self):
        return [f"  {item.product.name}: ${item.line_total():.2f}"
                for item in self.items]

class OrderPrinter:
    def print_order(self, order):
        # Now just orchestrates, doesn't calculate
        print(f"Customer: {order.customer.formatted_address()}")
        print("Items:")
        for line in order.formatted_items():
            print(line)
        print(f"Subtotal: ${order.subtotal():.2f}")
        print(f"Tax: ${order.tax():.2f}")
        print(f"Total: ${order.total():.2f}")
```

## The Rule of Thumb

> The fundamental rule of thumb is to put things together that change together.

If a method needs a lot of data from another class, it probably should be **in** that class.

## Exception: Strategy Pattern

Sometimes Feature Envy is intentional:

```python
class TaxCalculator:
    def calculate(self, order):
        # Intentionally accesses order's data
        # Different calculators have different rules
        return order.subtotal() * self.tax_rate
```

This is OK when the **behavior** varies (different tax rules) while the **data** stays the same.

## How to Fix

1. **Move Method**: Move the method to the class it's envious of
2. **Extract Method**: Pull out the envious part, then move it
3. **Move Field**: If only a field is needed, move just that

## Detection

- Method calls many getters on another object
- Method calculates values from another object's data
- Method knows too much about another class's structure
- Long method chains starting from another object

## Related Smells

- Middle Man (class-level version)
- Inappropriate Intimacy
- Data Class (often the target of envy)
