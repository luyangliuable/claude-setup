# Clean Code: Naming

**Category:** Clean Code
**Impact:** HIGH
**Difficulty to fix:** LOW

## Why Naming Matters

Names are everywhere in code: variables, functions, classes, packages, files. Good names make code readable without comments. Bad names obscure intent.

---

## Use Intention-Revealing Names

```python
# Bad - what does this mean?
d = 5
x = get_them()

# Good - intention is clear
elapsed_time_in_days = 5
flagged_cells = get_flagged_cells()
```

Ask yourself: **"Does this name tell me WHY it exists, WHAT it does, and HOW it's used?"**

---

## Avoid Disinformation

Don't use names that mean something different than intended:

```python
# Bad - not actually a list
account_list = {}  # It's a dict!

# Bad - misleading abbreviation
hp = health_points  # Or is it Hewlett-Packard?

# Good
accounts = {}
health_points = 100
```

---

## Make Meaningful Distinctions

If names must differ, make them meaningfully different:

```python
# Bad - noise words, no distinction
get_active_account()
get_active_accounts()
get_active_account_info()
get_active_account_data()

# Good - clear distinctions
get_account_by_id(account_id)
get_all_active_accounts()
get_account_balance(account_id)
get_account_history(account_id)
```

Avoid noise words: `Data`, `Info`, `Object`, `Manager`, `Processor`

---

## Use Pronounceable Names

```python
# Bad - can't discuss this code verbally
genymdhms = generate_timestamp()  # "gen-yim-dee-hems"?
modymdhms = modify_timestamp()

# Good - can discuss easily
generation_timestamp = generate_timestamp()
modification_timestamp = modify_timestamp()
```

---

## Use Searchable Names

```python
# Bad - impossible to search for
e = 2.71828
for i in range(34):
    s += t[i] * 4 / 5

# Good - can search for these
EULER_NUMBER = 2.71828
WORK_DAYS_PER_WEEK = 5
DAYS_IN_CALCULATION_PERIOD = 34

for day_index in range(DAYS_IN_CALCULATION_PERIOD):
    real_days += task_estimates[day_index] * 4 / WORK_DAYS_PER_WEEK
```

**Rule**: Single-letter names only for local variables in short methods.

---

## Avoid Encodings

Don't encode type or scope into names:

```python
# Bad - Hungarian notation
str_name = "John"
int_age = 25
lst_items = []
m_description = ""  # member variable

# Good - just describe what it is
name = "John"
age = 25
items = []
description = ""
```

---

## Class Names

Classes should be **nouns**, not verbs:

```python
# Good class names
Customer
Account
AddressParser
WikiPage

# Bad class names
Process  # verb
Data     # too vague
Manager  # often a sign of god class
Info     # noise word
```

---

## Method Names

Methods should be **verbs** or verb phrases:

```python
# Good method names
save()
delete_page()
get_name()
is_active()  # boolean
has_permission()  # boolean

# Factory methods - use static "from" or "of"
complex = Complex.from_real_number(23.0)
point = Point.of(x, y)
```

---

## Don't Be Cute

```python
# Bad - clever but unclear
def whack():  # deletes something
    pass

def eatMyShorts():  # aborts process
    pass

# Good - boring but clear
def delete():
    pass

def abort():
    pass
```

---

## One Word Per Concept

Pick one word and stick to it:

```python
# Inconsistent - confusing
class UserController:
    def fetch_user(): pass

class AccountManager:
    def get_account(): pass

class ProductDriver:
    def retrieve_product(): pass

# Consistent - clear pattern
class UserService:
    def get_user(): pass

class AccountService:
    def get_account(): pass

class ProductService:
    def get_product(): pass
```

---

## Use Domain Names

Use names from the problem domain:

```python
# Technical names (when appropriate)
class AccountVisitor:  # Visitor pattern
    pass

job_queue = Queue()  # CS concept

# Domain names (prefer when possible)
class PolicyHolder:  # Insurance domain
    pass

class BenefitCalculator:  # HR domain
    pass
```

---

## Summary: Naming Checklist

- [ ] Name reveals intention
- [ ] No disinformation or misleading names
- [ ] Meaningful distinctions (no noise words)
- [ ] Pronounceable
- [ ] Searchable (no single letters except loops)
- [ ] No type encodings (Hungarian notation)
- [ ] Classes are nouns
- [ ] Methods are verbs
- [ ] Consistent vocabulary across codebase
- [ ] Domain-appropriate terminology
