# Code Smell: Duplicate Code

**Category:** Code Smells - Dispensables
**Impact:** HIGH
**Difficulty to fix:** MEDIUM

## Description

> If you see the same code structure in more than one place, you can be sure that your program will be better if you find a way to unify them.
> -- *Refactoring* by Martin Fowler

The most common code smell. Duplicate code comes in many shapes: obvious copy-paste, parameterized variations, or subtle structural duplications.

## Why It's a Problem

- Changes must be made in multiple places
- Easy to miss updating one copy
- Increases codebase size unnecessarily
- Indicates missing abstraction

## Examples

### Obvious Duplication

```ruby
# Bad: Same validation logic repeated
def validate_email(email)
    return false if email.nil?
    return false if email.empty?
    return email.include?('@')
end

def validate_user_email(user_email)
    return false if user_email.nil?
    return false if user_email.empty?
    return user_email.include?('@')
end
```

### Parameterized Duplication

```python
# Bad: Same structure, slightly different parameters
def get_active_users():
    users = db.query("SELECT * FROM users WHERE status = 'active'")
    return [format_user(u) for u in users]

def get_pending_users():
    users = db.query("SELECT * FROM users WHERE status = 'pending'")
    return [format_user(u) for u in users]

def get_banned_users():
    users = db.query("SELECT * FROM users WHERE status = 'banned'")
    return [format_user(u) for u in users]
```

### Good: Unified

```python
def get_users_by_status(status):
    users = db.query(f"SELECT * FROM users WHERE status = '{status}'")
    return [format_user(u) for u in users]

# Usage
active_users = get_users_by_status('active')
pending_users = get_users_by_status('pending')
```

## How to Fix

1. **Extract Method**: Pull common code into a shared function
2. **Extract Class**: Create a class if the duplication involves state
3. **Pull Up Method**: Move to parent class if in sibling classes
4. **Template Method Pattern**: For algorithmic variations
5. **Parameterize**: Add parameters for the varying parts

## Detection

- Code review reveals copy-paste
- Same bug appears in multiple places
- Multiple methods with similar structures
- IDE duplicate detection tools

## Related Smells

- Shotgun Surgery (duplication across classes)
- Parallel Inheritance Hierarchies

## Related Principle

- DRY (Don't Repeat Yourself)
