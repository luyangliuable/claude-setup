# Code Smell: Switch Statements

**Category:** Code Smells - Object-Orientation Abusers
**Impact:** MEDIUM-HIGH
**Difficulty to fix:** MEDIUM

## Description

> Often you find the same switch statement scattered about a program in different places. If you add a new clause to the switch, you have to find all these switch statements and change them.
> -- *Refactoring* by Martin Fowler

Switch statements on type codes, especially when duplicated across the codebase, are a sign that polymorphism should be used instead.

## Why It's a Problem

- Adding new types requires changing multiple locations
- Violates Open/Closed Principle
- Easy to forget to update all switches
- Type-checking logic scattered across codebase
- Often duplicated

## Bad Example

```python
class Employee:
    def __init__(self, name, type_code):
        self.name = name
        self.type_code = type_code  # 'engineer', 'manager', 'salesperson'

def calculate_pay(employee, hours):
    if employee.type_code == 'engineer':
        return hours * 50
    elif employee.type_code == 'manager':
        return 5000 + (hours * 60)  # salary + overtime
    elif employee.type_code == 'salesperson':
        return hours * 40 + calculate_commission(employee)
    else:
        raise ValueError(f"Unknown type: {employee.type_code}")

def calculate_bonus(employee):
    if employee.type_code == 'engineer':
        return 1000
    elif employee.type_code == 'manager':
        return 2000
    elif employee.type_code == 'salesperson':
        return calculate_sales_bonus(employee)
    else:
        raise ValueError(f"Unknown type: {employee.type_code}")

# If we add 'contractor' type, must update EVERY switch
```

## Good Example

```python
from abc import ABC, abstractmethod

class Employee(ABC):
    def __init__(self, name):
        self.name = name

    @abstractmethod
    def calculate_pay(self, hours):
        pass

    @abstractmethod
    def calculate_bonus(self):
        pass

class Engineer(Employee):
    HOURLY_RATE = 50
    BONUS = 1000

    def calculate_pay(self, hours):
        return hours * self.HOURLY_RATE

    def calculate_bonus(self):
        return self.BONUS

class Manager(Employee):
    BASE_SALARY = 5000
    OVERTIME_RATE = 60
    BONUS = 2000

    def calculate_pay(self, hours):
        return self.BASE_SALARY + (hours * self.OVERTIME_RATE)

    def calculate_bonus(self):
        return self.BONUS

class Salesperson(Employee):
    HOURLY_RATE = 40

    def __init__(self, name, sales_record):
        super().__init__(name)
        self.sales_record = sales_record

    def calculate_pay(self, hours):
        return hours * self.HOURLY_RATE + self._commission()

    def calculate_bonus(self):
        return self._sales_bonus()

    def _commission(self):
        return self.sales_record.total * 0.05

    def _sales_bonus(self):
        return self.sales_record.total * 0.01

# Adding 'Contractor' just means adding a new class
# No existing code needs to change!
class Contractor(Employee):
    def calculate_pay(self, hours):
        return hours * 75

    def calculate_bonus(self):
        return 0
```

## When Switch Is OK

Single switch for object creation (Factory):

```python
def create_employee(type_code, name, **kwargs):
    """Factory - single place that knows about types"""
    if type_code == 'engineer':
        return Engineer(name)
    elif type_code == 'manager':
        return Manager(name)
    elif type_code == 'salesperson':
        return Salesperson(name, kwargs['sales_record'])
    else:
        raise ValueError(f"Unknown type: {type_code}")

# Rest of code uses polymorphism
employee = create_employee('engineer', 'Alice')
pay = employee.calculate_pay(40)  # No switch needed!
```

## How to Fix

1. **Replace Type Code with Subclasses**: Create class hierarchy
2. **Replace Conditional with Polymorphism**: Move each branch to a subclass
3. **Replace Type Code with State/Strategy**: If type changes at runtime

## Detection

- Multiple switch/if-else chains on same variable
- Type code fields ('type', 'kind', 'category')
- Switches that throw "unknown type" exceptions
- New types require changes in multiple files

## Related Principles

- Open/Closed Principle
- Polymorphism
- Strategy Pattern
