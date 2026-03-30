# Code Smell: Lazy Class

**Category:** Code Smells - Dispensables
**Impact:** LOW-MEDIUM
**Difficulty to fix:** LOW

## Description

> Each class you create costs money to maintain and understand. A class that isn't doing enough to pay for itself should be eliminated.
> -- *Refactoring* by Martin Fowler

A Lazy Class doesn't do enough to justify its existence. It adds cognitive overhead without providing sufficient value.

## Why It's a Problem

- Adds unnecessary indirection
- More files/classes to navigate
- Maintenance cost without benefit
- Can result from over-aggressive refactoring
- Makes codebase seem more complex than it is

## Bad Example

```python
# A class that barely does anything
class StringUtils:
    @staticmethod
    def is_empty(s):
        return s is None or len(s) == 0

# Just use: not s or len(s) == 0

# A wrapper that adds no value
class UserWrapper:
    def __init__(self, user):
        self.user = user

    def get_name(self):
        return self.user.name

    def get_email(self):
        return self.user.email

# Just use the user directly!

# A class with a single trivial method
class Greeter:
    def greet(self, name):
        return f"Hello, {name}!"

# This could be a simple function
```

## When a Class Earns Its Keep

```python
# This class DOES enough to justify itself
class Money:
    def __init__(self, amount, currency):
        self.amount = Decimal(str(amount))
        self.currency = currency

    def __add__(self, other):
        if self.currency != other.currency:
            raise ValueError("Cannot add different currencies")
        return Money(self.amount + other.amount, self.currency)

    def __sub__(self, other):
        if self.currency != other.currency:
            raise ValueError("Cannot subtract different currencies")
        return Money(self.amount - other.amount, self.currency)

    def convert_to(self, target_currency, exchange_rate):
        return Money(self.amount * exchange_rate, target_currency)

    def __str__(self):
        return f"{self.currency} {self.amount:.2f}"

    def __eq__(self, other):
        return self.amount == other.amount and self.currency == other.currency
```

## Balance with Other Smells

Finding the right balance:

```
Lazy Class <-----> Large Class / Feature Envy
(too little)       (too much)
```

- Don't create classes for trivial operations
- Don't avoid classes when they provide real value
- A class should encapsulate a coherent concept

## How to Fix

1. **Inline Class**: Merge the lazy class into its caller
2. **Collapse Hierarchy**: Merge with parent or child class
3. **Convert to Function**: If no state is needed

## When to Keep a Small Class

- It has a clear domain concept (like Money, Email, PhoneNumber)
- It will likely grow with new requirements
- It improves testability
- It provides type safety
- It's part of a consistent pattern in your codebase

## Detection

- Class has 1-2 methods
- Methods are trivial (one-liners)
- Class is just a thin wrapper
- Class was created "just in case"
- Class could be replaced by a function

## Related Smells

- Data Class (similar - too little behavior)
- Speculative Generality (often creates lazy classes)
- Middle Man (delegate class with no added value)
