# Code Smell: Middle Man

**Category:** Code Smells - Couplers
**Impact:** MEDIUM
**Difficulty to fix:** LOW

## Description

> You look at a class's interface and find half the methods are delegating to this other class.
> -- *Refactoring* by Martin Fowler

A Middle Man is a class that does nothing but delegate to another class. It adds a layer of indirection without adding value.

## Why It's a Problem

- Adds unnecessary complexity
- Extra code to maintain
- Performance overhead (extra method calls)
- Makes the code harder to navigate
- Often a sign of over-engineering

## Bad Example

```python
class Person:
    def __init__(self, department):
        self._department = department

    # These methods just delegate - no added value
    def get_manager(self):
        return self._department.get_manager()

    def get_department_name(self):
        return self._department.get_name()

    def get_department_budget(self):
        return self._department.get_budget()

    def get_department_location(self):
        return self._department.get_location()

    def get_department_head_count(self):
        return self._department.get_head_count()

# Client code goes through the middle man
manager = person.get_manager()
location = person.get_department_location()
```

## Good Example

```python
class Person:
    def __init__(self, department):
        self.department = department  # Expose directly

    # Only add methods that add VALUE
    def is_in_same_department(self, other_person):
        return self.department == other_person.department

    def can_approve_expense(self, amount):
        return self == self.department.get_manager() or amount < 100

# Client accesses department directly when needed
manager = person.department.manager
location = person.department.location
```

## Balanced Approach

Sometimes delegation is appropriate - the key is whether it adds value:

```python
class Person:
    def __init__(self, department):
        self._department = department

    @property
    def department(self):
        """Direct access when full department info needed"""
        return self._department

    @property
    def manager(self):
        """Convenience for common operation"""
        return self._department.manager

    def reports_to(self, potential_manager):
        """Adds meaningful domain logic"""
        return self.manager == potential_manager

    def get_approval_chain(self):
        """Encapsulates complex logic"""
        chain = []
        current = self.manager
        while current:
            chain.append(current)
            current = current.manager if current != current.manager else None
        return chain
```

## When Delegation Is Good

- Hiding implementation details that might change
- Providing a simpler interface to a complex subsystem (Facade)
- Adding validation or transformation
- Lazy loading or caching
- Access control

## How to Fix

1. **Remove Middle Man**: Let clients access the delegate directly
2. **Inline Class**: If the middle man is a whole class, merge it
3. **Add Value**: If keeping delegation, add meaningful logic

## Detection

- Methods that just call another method on a field
- Classes with many one-line delegation methods
- No added logic, validation, or transformation in methods
- Class exists only to wrap another class

## Related Smells

- Feature Envy (the opposite problem - too much interest in other class)
- Message Chains (Middle Man is sometimes overcorrection)
- Lazy Class (Middle Man often becomes a Lazy Class)

## The Balance

```
Message Chains <-----> Middle Man
(too much coupling)    (too much indirection)
```

Find the right balance:
- Use delegation when it adds value
- Use direct access when indirection adds nothing
