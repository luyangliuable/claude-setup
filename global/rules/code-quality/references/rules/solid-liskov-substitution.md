# Liskov Substitution Principle (LSP)

**Category:** SOLID Principles
**Impact:** HIGH
**Difficulty to fix:** HIGH

## Rule

> Derived classes should be substitutable for their base classes.
> -- Robert C. Martin

If B is a subclass of A, you should be able to use B anywhere A is expected without breaking the program.

## Why It Matters

- Violations are latent violations of Open/Closed Principle
- Breaks client code expectations
- Leads to runtime errors and type checking hacks
- Destroys the benefits of polymorphism

## The Classic Circle/Ellipse Problem

```java
class Ellipse {
    void setFoci(Point a, Point b) {
        this.focusA = a;
        this.focusB = b;
    }
}

class Circle extends Ellipse {
    // Circle has one center, not two foci!
    void setFoci(Point a, Point b) {
        this.focusA = a;
        this.focusB = a;  // Ignores second parameter - VIOLATION!
    }
}

// Client code breaks:
void processEllipse(Ellipse e) {
    Point a = new Point(-1, 0);
    Point b = new Point(1, 0);
    e.setFoci(a, b);
    assert(e.getFocusB().equals(b));  // FAILS for Circle!
}
```

## Design by Contract Rules

A derived class is substitutable if:
1. **Preconditions are no stronger** than the base class
2. **Postconditions are no weaker** than the base class

## Bad Example

```java
public class Bird {
    public void fly() { ... }
}

public class Penguin extends Bird {
    public void fly() {
        throw new UnsupportedOperationException("Penguins can't fly!");
    }
}
```

## Good Example

```java
public interface Bird {
    void move();
}

public interface FlyingBird extends Bird {
    void fly();
}

public class Sparrow implements FlyingBird {
    public void move() { fly(); }
    public void fly() { ... }
}

public class Penguin implements Bird {
    public void move() { walk(); }
    public void walk() { ... }
}
```

## Detection

- Methods that throw `UnsupportedOperationException` or `NotImplementedException`
- Subclasses that ignore or override base class behavior completely
- Type checking before calling methods (`if (x instanceof SubType)`)
- Empty method implementations in subclasses

## How to Fix

1. Reconsider your inheritance hierarchy
2. Use composition instead of inheritance
3. Create more specific interfaces
4. Ensure subclasses honor the contract of the base class
