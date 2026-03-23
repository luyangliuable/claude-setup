# Code Smell: Primitive Obsession

**Category:** Code Smells - Bloaters
**Impact:** MEDIUM-HIGH
**Difficulty to fix:** MEDIUM

## Description

> People new to objects usually are reluctant to use small objects for small tasks, such as money classes that combine number and currency, ranges with an upper and a lower, and special strings such as telephone numbers and ZIP codes.
> -- *Refactoring* by Martin Fowler

Over-reliance on primitive types (int, string, float) instead of small objects for domain concepts.

## Why It's a Problem

- No validation at the type level
- Domain logic scattered across codebase
- Easy to mix up similar primitives (two strings, two ints)
- No place for behavior related to the concept
- Duplication of validation logic

## Bad Example

```python
# Using primitives for everything
def create_user(name, email, phone, age, zip_code, salary):
    # What currency is salary? What format is phone?
    # Is age in years? What country's zip code format?
    pass

def send_money(from_account, to_account, amount, currency):
    # Can we add USD to EUR? This code doesn't prevent it!
    pass

# Validation scattered everywhere
def validate_email(email):
    return '@' in email and '.' in email

# Called in multiple places, easy to forget
if validate_email(user_email):
    send_email(user_email, message)
```

## Good Example

```python
class Email:
    def __init__(self, value):
        if not self._is_valid(value):
            raise ValueError(f"Invalid email: {value}")
        self._value = value.lower()

    def _is_valid(self, email):
        return '@' in email and '.' in email.split('@')[1]

    @property
    def domain(self):
        return self._value.split('@')[1]

    def __str__(self):
        return self._value

class Money:
    def __init__(self, amount, currency):
        if amount < 0:
            raise ValueError("Amount cannot be negative")
        self.amount = Decimal(str(amount))
        self.currency = currency

    def __add__(self, other):
        if self.currency != other.currency:
            raise ValueError(f"Cannot add {self.currency} to {other.currency}")
        return Money(self.amount + other.amount, self.currency)

    def __str__(self):
        return f"{self.currency} {self.amount:.2f}"

class PhoneNumber:
    def __init__(self, value, country_code='US'):
        self.country_code = country_code
        self.number = self._normalize(value)
        if not self._is_valid():
            raise ValueError(f"Invalid phone: {value}")

    def _normalize(self, value):
        return ''.join(filter(str.isdigit, value))

    def _is_valid(self):
        # Validation rules by country
        if self.country_code == 'US':
            return len(self.number) == 10
        return len(self.number) >= 7

class Age:
    def __init__(self, years):
        if years < 0 or years > 150:
            raise ValueError(f"Invalid age: {years}")
        self.years = years

    def is_adult(self):
        return self.years >= 18

# Now signatures are self-documenting and validated
def create_user(name: str, email: Email, phone: PhoneNumber,
                age: Age, salary: Money):
    pass  # All types are validated by construction!
```

## Color Example from the Code Smells Reference

```ruby
class Color
    attr_reader :code

    def initialize(code)
        @code = validate(code)
    end

    def to_s
        @code.to_s
    end

    private

    def validate(code)
        raise InvalidColorError unless code =~ /[0-9A-Fa-f]{6}/
        code
    end
end

# Usage
background = Color.new("C0C0C0")  # Valid
text_color = Color.new("invalid")  # Raises error immediately
```

## How to Fix

1. **Replace Data Value with Object**: Create a class for the primitive
2. **Replace Type Code with Class**: For categorizations
3. **Replace Array with Object**: For grouped primitives
4. **Introduce Parameter Object**: For commonly grouped parameters

## Detection

- Same validation logic in multiple places
- Primitives with specific valid ranges
- Strings with specific formats (email, phone, URL)
- Numbers with units (money, weight, distance)
- Multiple primitives always used together

## Related Smells

- Data Clumps (primitives traveling together)
- Long Parameter List (primitives instead of objects)
- Data Class (opposite problem - too much wrapping)
