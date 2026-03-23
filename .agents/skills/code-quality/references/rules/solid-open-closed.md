# Open/Closed Principle (OCP)

**Category:** SOLID Principles
**Impact:** HIGH
**Difficulty to fix:** MEDIUM-HIGH

## Rule

> Software entities (classes, modules, functions) should be open for extension, but closed for modification.
> -- Robert C. Martin

You should be able to add new features without changing existing code.

## Why It Matters

- Changes propagating to existing working code can introduce bugs
- Changes to module interfaces can be expensive
- Makes code easier to extend and maintain
- Abstraction is key to achieving OCP

## Bad Example

```c
void LogOn(Modem& m, string& pno, string& user, string& pw) {
    if (m.type == Modem::hayes)
        DialHayes((Hayes&)m, pno);
    else if (m.type == Modem::courrier)
        DialCourrier((Courrier&)m, pno);
    else if (m.type == Modem::ernie)
        DialErnie((Ernie&)m, pno);
    // Adding new modem requires modifying this function!
}
```

Every time a new modem type is added, existing code must be modified.

## Good Example

```c++
class Modem {
public:
    virtual void Dial(const string& pno) = 0;
    virtual void Send(char) = 0;
    virtual char Recv() = 0;
    virtual void Hangup() = 0;
};

class HayesModem : public Modem {
    void Dial(const string& pno) override { /* Hayes-specific */ }
    // ... other implementations
};

void LogOn(Modem& m, string& pno, string& user, string& pw) {
    m.Dial(pno);  // Works with any modem type!
    // ...
}
```

New modem types can be added without modifying `LogOn` function.

## Detection

- Switch statements or if/else chains based on type
- Functions that need modification when new types are added
- Type checking using `instanceof`, `typeof`, or type fields

## How to Fix

1. Identify the variation point (what changes)
2. Create an abstraction (interface or abstract class)
3. Implement concrete classes for each variant
4. Use polymorphism instead of conditionals

## Related Principles

- Liskov Substitution Principle
- Dependency Inversion Principle
- Strategy Pattern
- Template Method Pattern
