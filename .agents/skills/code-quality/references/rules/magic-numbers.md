# Avoid Magic Numbers and Literals

**Category:** Clean Code / Coding Practices
**Impact:** MEDIUM
**Difficulty to fix:** LOW

## Rule

> Numerical constants (literals) should not be coded directly, except for -1, 0, and 1, which can appear in a for loop as counter values.

Give literals a name and type that are declared once and can never change.

## Why It Matters

- Magic numbers have no context
- Same number in different places may mean different things
- Changes require finding all occurrences
- No compile-time checking
- Violates DRY principle

## Bad Example

```java
public class Watch {
    public Watch() {
        hours = new MaxCounter(24);        // What is 24?
        minutes = new LinkedCounter(60, hours);  // What is 60?
        seconds = new LinkedCounter(60, minutes);
    }

    public boolean isOvertime(int hoursWorked) {
        return hoursWorked > 8;  // What is 8?
    }

    public double calculatePay(double hours) {
        if (hours > 40) {  // What is 40?
            return 40 * 15 + (hours - 40) * 22.50;  // What is 15? 22.50?
        }
        return hours * 15;
    }
}
```

## Good Example

```java
public class Watch {
    static final int MAX_HOURS = 24;
    static final int MAX_MINUTES = 60;
    static final int MAX_SECONDS = 60;

    public Watch() {
        hours = new MaxCounter(MAX_HOURS);
        minutes = new LinkedCounter(MAX_MINUTES, hours);
        seconds = new LinkedCounter(MAX_SECONDS, minutes);
    }
}

public class PayrollCalculator {
    private static final int STANDARD_HOURS_PER_WEEK = 40;
    private static final int STANDARD_HOURS_PER_DAY = 8;
    private static final double REGULAR_RATE = 15.00;
    private static final double OVERTIME_MULTIPLIER = 1.5;
    private static final double OVERTIME_RATE = REGULAR_RATE * OVERTIME_MULTIPLIER;

    public boolean isOvertime(int hoursWorked) {
        return hoursWorked > STANDARD_HOURS_PER_DAY;
    }

    public double calculatePay(double hours) {
        if (hours > STANDARD_HOURS_PER_WEEK) {
            double overtimeHours = hours - STANDARD_HOURS_PER_WEEK;
            return STANDARD_HOURS_PER_WEEK * REGULAR_RATE
                 + overtimeHours * OVERTIME_RATE;
        }
        return hours * REGULAR_RATE;
    }
}
```

## Static Final Fields

Use `static final` (Java) or `const` (JavaScript/TypeScript) for constants:

```java
// Java
static final int MAX_HOURS = 24;

// TypeScript
const MAX_HOURS = 24;

// Python
MAX_HOURS = 24  # Convention: ALL_CAPS indicates constant
```

### Why Not Private for Final Fields?

Static final fields can't be modified after creation, so there's no danger of unauthorized modification. Making them package-private or public allows reuse.

## Magic Strings Too!

```python
# Bad
if user.role == "admin":
    pass
if order.status == "pending":
    pass

# Good
class UserRole:
    ADMIN = "admin"
    USER = "user"

class OrderStatus:
    PENDING = "pending"
    SHIPPED = "shipped"
    DELIVERED = "delivered"

if user.role == UserRole.ADMIN:
    pass
if order.status == OrderStatus.PENDING:
    pass
```

## Acceptable Exceptions

- 0, 1, -1 in loops and basic arithmetic
- Empty string "" or empty array []
- true/false boolean literals
- null/None for explicit null checks

```java
// These are OK
for (int i = 0; i < items.length; i++) { }
return count == 0;
return index == -1;  // Common "not found" convention
```

## How to Fix

1. **Extract Constant**: Create a named constant
2. **Use Enums**: For related groups of values
3. **Configuration Objects**: For configurable values
4. **Domain Objects**: For values with behavior (like Money)

## Related Concepts

- DRY (Don't Repeat Yourself)
- Connascence of Meaning
- Primitive Obsession
