# Single Responsibility Principle (SRP)

**Category:** SOLID Principles
**Impact:** HIGH
**Difficulty to fix:** MEDIUM

## Rule

> A class should have one, and only one reason to change.
> -- Robert C. Martin

Each class should have a single responsibility and contain all functionality needed to support that responsibility.

## Why It Matters

- Code within classes becomes cohesive
- No excess features getting in the way of changes
- System is easier to maintain and extend
- Reduces ripple effects when changes are needed

## Bad Example

```java
public class Employee {
    public String name;
    public String address;

    // HR responsibility
    public void updatePersonalInfo() { ... }

    // Finance responsibility - VIOLATION
    public void computePay() { ... }

    // Operations responsibility - VIOLATION
    public void reportHours() { ... }

    // IT responsibility - VIOLATION
    public void saveToDatabase() { ... }
}
```

This class has multiple reasons to change: HR policy changes, payroll calculation changes, time tracking changes, and database schema changes.

## Good Example

```java
public class Employee {
    public String name;
    public String address;

    public void updatePersonalInfo() { ... }
}

public class PayrollCalculator {
    public Money computePay(Employee employee) { ... }
}

public class TimeTracker {
    public Report reportHours(Employee employee) { ... }
}

public class EmployeeRepository {
    public void save(Employee employee) { ... }
}
```

Each class now has a single responsibility and reason to change.

## Detection

- Class has methods that serve different stakeholders (HR, Finance, IT)
- Class name includes "And" or "Manager" or "Handler" (often a sign)
- Class has many unrelated methods
- Changes to one feature require changes to unrelated methods

## How to Fix

1. Identify different responsibilities within the class
2. Extract each responsibility into its own class
3. Use composition or dependency injection to coordinate
4. Ensure each new class has a focused, cohesive purpose

## Related Smells

- God Class
- Large Class
- Divergent Change
