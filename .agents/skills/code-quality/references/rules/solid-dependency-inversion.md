# Dependency Inversion Principle (DIP)

**Category:** SOLID Principles
**Impact:** HIGH
**Difficulty to fix:** MEDIUM-HIGH

## Rule

> High-level modules should not depend on low-level modules. Both should depend on abstractions.
> Abstractions should not depend on details. Details should depend on abstractions.
> -- Robert C. Martin

Depend on interfaces/abstract classes, not concrete implementations.

## Why It Matters

- Concrete things change frequently; abstractions change less
- Abstractions are "hinge points" where design can bend/extend
- Makes code more testable (easy to mock dependencies)
- Reduces coupling between modules

## Bad Example (Depending on Concretions)

```java
class OrderService {
    private MySQLDatabase database;  // Concrete dependency!
    private SmtpEmailSender emailer; // Concrete dependency!

    public OrderService() {
        this.database = new MySQLDatabase();
        this.emailer = new SmtpEmailSender();
    }

    public void placeOrder(Order order) {
        database.save(order);
        emailer.send(order.getCustomerEmail(), "Order confirmed");
    }
}
```

## Good Example (Depending on Abstractions)

```java
interface Database {
    void save(Object entity);
}

interface EmailSender {
    void send(String to, String message);
}

class OrderService {
    private Database database;     // Abstraction!
    private EmailSender emailer;   // Abstraction!

    public OrderService(Database database, EmailSender emailer) {
        this.database = database;
        this.emailer = emailer;
    }

    public void placeOrder(Order order) {
        database.save(order);
        emailer.send(order.getCustomerEmail(), "Order confirmed");
    }
}
```

Now `OrderService` can work with any database or email implementation.

## Object Creation: Abstract Factory

When you need to create instances, use the Abstract Factory pattern:

```java
interface ServiceFactory {
    Database createDatabase();
    EmailSender createEmailSender();
}

class ProductionFactory implements ServiceFactory {
    public Database createDatabase() { return new MySQLDatabase(); }
    public EmailSender createEmailSender() { return new SmtpEmailSender(); }
}

class TestFactory implements ServiceFactory {
    public Database createDatabase() { return new InMemoryDatabase(); }
    public EmailSender createEmailSender() { return new MockEmailSender(); }
}
```

## Exception: Non-Volatile Classes

Some concrete classes are not volatile and may be depended on directly:
- Standard library classes (String, List, etc.)
- Stable utility classes

However, non-volatility is not a replacement for substitutability.

## Detection

- Direct instantiation of concrete classes with `new`
- Hard-coded class names in business logic
- Difficulty writing unit tests (can't mock dependencies)
- Changes to low-level modules require high-level changes

## How to Fix

1. Identify dependencies on concrete classes
2. Extract interfaces for those dependencies
3. Use dependency injection (constructor, setter, or interface)
4. Use factories for object creation when needed
