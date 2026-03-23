# Code Smell: Shotgun Surgery

**Category:** Code Smells - Change Preventers
**Impact:** HIGH
**Difficulty to fix:** HIGH

## Description

> Shotgun Surgery is similar to Divergent Change but is the opposite. You whiff this when every time you make a kind of change, you have to make a lot of little changes to a lot of different classes. When the changes are all over the place, they are hard to find, and it's easy to miss an important change.
> -- *Refactoring* by Martin Fowler

One logical change requires modifications scattered across many different classes or files.

## Why It's a Problem

- Easy to miss one of the required changes
- Changes are error-prone
- Hard to understand the full impact of a change
- Testing requires checking many files
- Related code is not cohesive

## Divergent Change vs Shotgun Surgery

| Divergent Change | Shotgun Surgery |
|------------------|-----------------|
| One class, many reasons to change | One change, many classes to modify |
| Class does too much | Feature is spread too thin |
| Fix: Split the class | Fix: Consolidate related code |

## Bad Example

```python
# Adding a new customer type requires changes EVERYWHERE

# File: customer.py
class Customer:
    def get_discount_rate(self):
        if self.type == 'regular':
            return 0
        elif self.type == 'premium':
            return 0.1
        elif self.type == 'vip':
            return 0.2
        # Adding 'enterprise' requires change here

# File: billing.py
def calculate_bill(customer, amount):
    if customer.type == 'regular':
        return amount
    elif customer.type == 'premium':
        return amount * 0.9
    elif customer.type == 'vip':
        return amount * 0.8
    # AND here

# File: support.py
def get_support_level(customer):
    if customer.type == 'regular':
        return 'email'
    elif customer.type == 'premium':
        return 'chat'
    elif customer.type == 'vip':
        return 'phone'
    # AND here

# File: shipping.py
def get_shipping_speed(customer):
    if customer.type == 'regular':
        return 'standard'
    elif customer.type == 'premium':
        return 'express'
    elif customer.type == 'vip':
        return 'overnight'
    # AND here

# File: reports.py
def generate_customer_report(customers):
    regular = [c for c in customers if c.type == 'regular']
    premium = [c for c in customers if c.type == 'premium']
    vip = [c for c in customers if c.type == 'vip']
    # AND here too!
```

## Good Example

```python
# All customer type behavior consolidated using polymorphism

from abc import ABC, abstractmethod

class Customer(ABC):
    def __init__(self, name):
        self.name = name

    @abstractmethod
    def get_discount_rate(self):
        pass

    @abstractmethod
    def get_support_level(self):
        pass

    @abstractmethod
    def get_shipping_speed(self):
        pass

    def calculate_bill(self, amount):
        return amount * (1 - self.get_discount_rate())

class RegularCustomer(Customer):
    def get_discount_rate(self):
        return 0

    def get_support_level(self):
        return 'email'

    def get_shipping_speed(self):
        return 'standard'

class PremiumCustomer(Customer):
    def get_discount_rate(self):
        return 0.1

    def get_support_level(self):
        return 'chat'

    def get_shipping_speed(self):
        return 'express'

class VIPCustomer(Customer):
    def get_discount_rate(self):
        return 0.2

    def get_support_level(self):
        return 'phone'

    def get_shipping_speed(self):
        return 'overnight'

# Adding 'EnterpriseCustomer' is ONE new file, no existing code changes!
class EnterpriseCustomer(Customer):
    def get_discount_rate(self):
        return 0.3

    def get_support_level(self):
        return 'dedicated_rep'

    def get_shipping_speed(self):
        return 'same_day'
```

## How to Fix

1. **Move Method/Field**: Gather related code into one class
2. **Inline Class**: Merge small classes doing the same thing
3. **Replace Conditional with Polymorphism**: Use subclasses
4. **Use Strategy Pattern**: For varying algorithms

## Detection

- Adding a feature requires changing many files
- The same conditional appears in multiple places
- Similar changes ripple through the codebase
- You frequently forget to update one of the places

## Related Smells

- Divergent Change (opposite pattern)
- Parallel Inheritance Hierarchies
- Switch Statements
