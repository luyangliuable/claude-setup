# Dynamic Connascence

**Category:** Connascence
**Impact:** HIGH
**Difficulty to fix:** MEDIUM-HIGH

## Overview

Dynamic connascence requires knowledge of runtime behavior to understand. These are generally stronger and more dangerous forms of coupling. **Static connascence is preferred over dynamic connascence**.

---

## Connascence of Execution

The order of execution of multiple components is important.

### Example: State Machine

```python
email = Email()

# Operations must happen in specific order
email.set_recipient("user@example.com")
email.set_sender("me@example.com")
email.set_subject("Hello")
email.send()  # Must be AFTER setting recipient, sender

# This would be a bug:
email.send()
email.set_subject("Hello")  # Too late!
```

### Example: Resource Locking

```python
# All code must acquire/release in same order
def process_data():
    lock_a.acquire()
    lock_b.acquire()  # Must be AFTER lock_a
    try:
        # do work
        pass
    finally:
        lock_b.release()  # Must be BEFORE lock_a release
        lock_a.release()
```

### Solution: Make Execution Order Explicit

```python
class EmailBuilder:
    def __init__(self, recipient, sender):
        # Required fields in constructor
        self.recipient = recipient
        self.sender = sender
        self.subject = None
        self.body = None

    def with_subject(self, subject):
        self.subject = subject
        return self

    def with_body(self, body):
        self.body = body
        return self

    def send(self):
        if not self.recipient or not self.sender:
            raise ValueError("Recipient and sender required")
        # send email

# Now order is clearer
EmailBuilder("user@x.com", "me@x.com") \
    .with_subject("Hello") \
    .with_body("Content") \
    .send()
```

---

## Connascence of Timing

The timing of execution of multiple components is important.

### Example: Race Condition

```python
# Thread A
def update_counter():
    global counter
    temp = counter
    time.sleep(0.001)  # Timing issue!
    counter = temp + 1

# Thread B - same code
# If both run simultaneously, updates may be lost!
```

### Example: Timeout Dependency

```python
# Service A expects response in 5 seconds
response = service_a.call(timeout=5)

# Service B must respond within 5 seconds
# If Service B takes 6 seconds, Service A fails
def service_b_handler():
    time.sleep(6)  # Bug: exceeds caller's timeout
    return result
```

### Solution: Use Synchronization or Make Timing Explicit

```python
from threading import Lock

counter_lock = Lock()

def update_counter():
    global counter
    with counter_lock:
        counter += 1

# Or use atomic operations
from threading import atomic
counter = atomic.AtomicInteger(0)
counter.increment()
```

---

## Connascence of Value

Several values must change together.

### Example: Test and Production Code

```python
class ArticleState(Enum):
    Draft = 1
    Published = 2

class Article:
    def __init__(self, contents):
        self.state = ArticleState.Draft  # Initial state

# Test knows about initial state
def test_publish():
    article = Article("Test")
    assert article.state == ArticleState.Draft  # Coupled to initial value!
    article.publish()
    assert article.state == ArticleState.Published
```

### Solution: Introduce Named Constants

```python
class ArticleState(Enum):
    Draft = 1
    Published = 2
    InitialState = Draft  # Single source of truth

class Article:
    def __init__(self, contents):
        self.state = ArticleState.InitialState

# Test uses the named constant
def test_publish():
    article = Article("Test")
    assert article.state == ArticleState.InitialState  # Now decoupled!
    article.publish()
    assert article.state == ArticleState.Published
```

---

## Connascence of Identity

Multiple components must reference the **same** entity (not just equal values).

### Example: Shared Object Identity

```java
public class Person {
    private Set<Person> parents;

    public boolean isSibling(Person other) {
        for (Person parent : parents) {
            // Checking IDENTITY, not equality
            if (other.getParents().contains(parent)) {
                return true;
            }
        }
        return false;
    }
}

// Usage
Person gina = new Person("Gina");
Person anna = new Person("Anna", gina, fred);
Person kerrie = new Person("Kerrie", gina, fred);

// These share the SAME gina object
anna.isSibling(kerrie);  // true - same parent identity

// Different object with same data
Person gina2 = new Person("Gina");  // Different identity!
Person kerrie2 = new Person("Kerrie", gina2, fred2);

anna.isSibling(kerrie2);  // false - different parent identity!
```

### When Identity Matters

- Caching (must be same object)
- Parent-child relationships
- Observer patterns (same observer instance)
- Singleton usage

---

## Contranascence

When two things are required to be **different**.

```python
# These MUST be different values
GENRE_ACTION = 0
GENRE_DRAMA = 1

# If someone accidentally sets both to 0, bugs occur
```

### Solution: Use Enums

```python
from enum import Enum, auto

class Genre(Enum):
    ACTION = auto()  # Guaranteed unique
    DRAMA = auto()
    COMEDY = auto()
```

---

## Summary: Dynamic Connascence Strength

| Connascence | Strength | Mitigation |
|-------------|----------|------------|
| Execution | Strong | Builder pattern, state machines |
| Timing | Strong | Synchronization, explicit timeouts |
| Value | Strong | Named constants, single source |
| Identity | Strongest | Clear documentation, value objects |

**Key Principle**: Keep strong connascence within module boundaries. Between modules, prefer weaker forms.

## Connascence Properties

1. **Strength**: How hard to refactor (dynamic > static)
2. **Locality**: How close are coupled components (closer = more acceptable)
3. **Degree**: How many components are coupled (fewer = better)
