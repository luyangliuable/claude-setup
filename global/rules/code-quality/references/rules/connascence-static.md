# Static Connascence

**Category:** Connascence
**Impact:** VARIES (weakest to moderate)
**Difficulty to fix:** LOW-MEDIUM

## Overview

Static connascence can be determined by examining source code alone. These are generally weaker and more acceptable forms of coupling.

---

## Connascence of Name (Weakest)

Multiple components must agree on the name of an entity.

### Example

```python
class Request:
    def __init__(self, url, data=None):
        self.url = url
        self.data = data

    def set_proxy(self, host, type):
        pass
```

Changing any name requires updating all references:
- Class name `Request`
- Method name `set_proxy`
- Parameter names `url`, `data`, `host`, `type`

### Why It's Acceptable

Connascence of name is unavoidable and the **weakest** form. However, it illustrates why good naming is critical.

---

## Connascence of Type

Multiple components must agree on the type of an entity.

### Statically Typed Languages (Caught by Compiler)

```cpp
std::string cost;
cost = 10.95;  // Compiler error!
```

### Dynamically Typed Languages (More Dangerous)

```python
def calculate_age(birth_day, birth_month, birth_year):
    pass

# How should this be called?
calculate_age(1, 9, 1984)      # Numbers?
calculate_age('1', '9', '1984')  # Strings?
calculate_age('1', 'September', '1984')  # Mixed?
```

### Solution

Use type hints or create specific types:

```python
from datetime import date

def calculate_age(birth_date: date) -> int:
    pass
```

---

## Connascence of Meaning

Multiple components must agree on the meaning of particular values.

### Bad: Magic Values

```python
def get_user_role(username):
    if user.is_admin:
        return 2  # What does 2 mean?
    elif user.is_manager:
        return 1
    else:
        return 0

# Elsewhere, must know that 2 means admin
if get_user_role(username) != 2:
    raise PermissionDenied("Must be admin")
```

### Bad: None with Multiple Meanings

```python
def find_user(username):
    try:
        return database.find(username) or None  # Not found
    except DatabaseError:
        return None  # Error occurred - same as not found!
```

### Good: Named Constants and Explicit Types

```python
from enum import Enum

class UserRole(Enum):
    REGULAR = 0
    MANAGER = 1
    ADMIN = 2

class UserNotFound:
    pass

class DatabaseError(Exception):
    pass

def find_user(username):
    try:
        return database.find(username) or UserNotFound()
    except DatabaseError as e:
        raise  # Propagate error explicitly
```

---

## Connascence of Position

Components must agree on the order of elements.

### In Data Structures

```python
# Bad: Position matters
def get_user_details():
    # first_name, last_name, year_of_birth, is_admin
    return ["Thomas", "Richards", 1984, True]

def launch_nukes(user):
    if user[3]:  # Is this is_admin? Fragile!
        # launch
```

### In Function Arguments

```python
# Bad: Easy to mix up parameters
def send_email(to, from_, cc, bcc, subject, body):
    pass

# Which is which?
send_email("a@x.com", "b@x.com", None, None, "Hi", "Body")
```

### Good: Named Access

```python
# Use dictionary or class
def get_user_details():
    return {
        "first_name": "Thomas",
        "is_admin": True
    }

# Use keyword arguments
def send_email(*, to, from_, subject, body, cc=None, bcc=None):
    pass
```

---

## Connascence of Algorithm

Components must agree on a particular algorithm.

### In Data Transmission

```python
# Sender uses MD5
def send_data(data):
    checksum = hashlib.md5(data).hexdigest()
    transmit(data, checksum)

# Receiver must use same algorithm!
def receive_data(data, checksum):
    if hashlib.md5(data).hexdigest() != checksum:
        raise IntegrityError()
```

### In Validation

```python
# Front-end validation
function validateEmail(email) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

# Back-end validation - must match!
def validate_email(email):
    return re.match(r'^[^\s@]+@[^\s@]+\.[^\s@]+$', email)
```

### Solution: Single Source of Truth

```python
# Define in ONE place, import everywhere
EMAIL_PATTERN = r'^[^\s@]+@[^\s@]+\.[^\s@]+$'

def validate_email(email):
    return re.match(EMAIL_PATTERN, email)
```

---

## Summary: Static Connascence Strength

| Connascence | Strength | Can Be Reduced To |
|-------------|----------|-------------------|
| Name | Weakest | N/A (unavoidable) |
| Type | Weak | Type hints, classes |
| Meaning | Moderate | Enums, named constants |
| Position | Moderate | Named params, objects |
| Algorithm | Moderate | Single source of truth |

**Rule**: Try to convert stronger connascence to weaker forms.
