# Interface Segregation Principle (ISP)

**Category:** SOLID Principles
**Impact:** MEDIUM-HIGH
**Difficulty to fix:** MEDIUM

## Rule

> Clients should not be forced to depend on interfaces they do not use.
> -- Robert C. Martin

Many specific interfaces are better than one general-purpose interface.

## Why It Matters

- Reduces unnecessary dependencies
- Changes to unused methods won't affect clients
- Promotes cohesion in interfaces
- Makes implementations simpler and more focused

## Bad Example

```java
interface Worker {
    void work();
    void eat();
    void sleep();
    void attendMeeting();
    void writeReport();
}

class Robot implements Worker {
    public void work() { /* OK */ }
    public void eat() { /* Robots don't eat! */ }
    public void sleep() { /* Robots don't sleep! */ }
    public void attendMeeting() { /* OK */ }
    public void writeReport() { /* OK */ }
}
```

Robot is forced to implement methods that make no sense for it.

## Good Example

```java
interface Workable {
    void work();
}

interface Feedable {
    void eat();
}

interface Restable {
    void sleep();
}

interface Reportable {
    void attendMeeting();
    void writeReport();
}

class Human implements Workable, Feedable, Restable, Reportable {
    // Implements all - makes sense for humans
}

class Robot implements Workable, Reportable {
    // Only implements what makes sense
}
```

## Detection

- Interfaces with many methods (fat interfaces)
- Implementations with empty or throwing methods
- Clients only using a subset of interface methods
- Interface methods that don't all relate to the same concept

## How to Fix

1. Identify groups of related methods
2. Split fat interface into smaller, cohesive interfaces
3. Have classes implement only the interfaces they need
4. Use interface composition when a class needs multiple behaviors

## Related Concepts

- Single Responsibility Principle (at the interface level)
- Role Interfaces
- Composition over Inheritance
