---
name: code-quality
description: Comprehensive code quality guide based on Clean Code, SOLID, DRY, CUPID, Coupling, Connascence, and Code Smells. Use when writing, reviewing, or refactoring code to ensure best practices.
version: 1.0.0
author: Personal Knowledge Base
license: MIT
tags: [Clean Code, SOLID, DRY, CUPID, Connascence, Code Smells, Refactoring, OOP, Best Practices]
dependencies: []
---

# Code Quality - Best Practices Guide

Comprehensive code quality guide synthesizing principles from Clean Code (Robert C. Martin), SOLID principles, DRY, CUPID, Coupling/Cohesion, Connascence, and Code Smells. Use this skill when writing new code, reviewing existing code, or refactoring for improved maintainability.

## When to use this skill

**Use Code Quality when:**
- Writing new classes, functions, or modules
- Reviewing code for quality issues
- Refactoring existing code
- Identifying and eliminating code smells
- Making architectural decisions
- Reducing technical debt
- Improving code maintainability and readability

## Quick Reference

### SOLID Principles

| Principle | Description | Key Insight |
|-----------|-------------|-------------|
| **S**ingle Responsibility | A class should have one reason to change | Easier to maintain and extend |
| **O**pen/Closed | Open for extension, closed for modification | Use abstraction and polymorphism |
| **L**iskov Substitution | Subtypes must be substitutable for base types | Don't break contracts |
| **I**nterface Segregation | Many specific interfaces > one general interface | Clients shouldn't depend on unused methods |
| **D**ependency Inversion | Depend on abstractions, not concretions | High-level modules shouldn't depend on low-level |

### DRY (Don't Repeat Yourself)

> "Every piece of knowledge must have a single, unambiguous, authoritative representation within a system."

- Extract duplicated code into functions/methods
- Use constants for magic numbers/strings
- Create shared utilities for common operations
- Single source of truth for configuration

### CUPID Properties

| Property | Description |
|----------|-------------|
| **C**omposable | Plays well with others, small focused units |
| **U**nix Philosophy | Does one thing well |
| **P**redictable | Does what you expect, no surprises |
| **I**diomatic | Feels natural in its environment |
| **D**omain-based | Models the problem domain clearly |

### Coupling & Cohesion

**Goal: Low Coupling, High Cohesion**

- **High Cohesion**: Group code that contributes to a single task
- **Low Coupling**: Minimize dependencies between modules
- Use intermediary classes to reduce direct dependencies
- Separate concerns (like CSS separates presentation from HTML)

### Connascence Strength (Weakest to Strongest)

#### Static Connascence (Compile-time)
1. **Name** - Components agree on entity names
2. **Type** - Components agree on entity types
3. **Meaning** - Components agree on value meanings (magic values)
4. **Position** - Components agree on order (arguments, data structures)
5. **Algorithm** - Components agree on algorithms (validation, encoding)

#### Dynamic Connascence (Runtime)
6. **Execution** - Order of execution matters
7. **Timing** - Timing of execution matters
8. **Value** - Values must change together
9. **Identity** - Components must reference same entity

**Rule**: Prefer weaker connascence. Convert stronger to weaker when possible.

## Code Smells Checklist

### Bloaters
- [ ] **Long Method** - Methods should be short and focused
- [ ] **Large Class** - Classes doing too much (God classes)
- [ ] **Long Parameter List** - More than 3 parameters is suspicious
- [ ] **Data Clumps** - Same data groups appearing together

### Object-Orientation Abusers
- [ ] **Switch Statements** - Consider polymorphism instead
- [ ] **Refused Bequest** - Subclass not using parent features
- [ ] **Alternative Classes with Different Interfaces** - Similar classes should have similar interfaces
- [ ] **Temporary Field** - Fields only used in certain circumstances

### Change Preventers
- [ ] **Divergent Change** - One class changed for different reasons
- [ ] **Shotgun Surgery** - One change requires many small changes
- [ ] **Parallel Inheritance Hierarchies** - Subclass one = subclass another

### Dispensables
- [ ] **Comments** - Code should be self-documenting
- [ ] **Duplicate Code** - DRY violation
- [ ] **Lazy Class** - Class not doing enough
- [ ] **Data Class** - Class with only getters/setters
- [ ] **Dead Code** - Unused code
- [ ] **Speculative Generality** - YAGNI violation

### Couplers
- [ ] **Feature Envy** - Method more interested in another class
- [ ] **Inappropriate Intimacy** - Classes too coupled
- [ ] **Message Chains** - Long chains of method calls
- [ ] **Middle Man** - Class delegating most work

## Clean Code Guidelines

### Naming
- Use intention-revealing names
- Avoid disinformation
- Make meaningful distinctions
- Use pronounceable names
- Use searchable names
- Avoid encodings (Hungarian notation)

### Functions
- Small (ideally < 20 lines)
- Do one thing
- One level of abstraction
- Descriptive names
- Few arguments (0-2 ideal, 3 max)
- No side effects
- Command-Query Separation

### Classes
- Small and focused
- Single Responsibility
- High cohesion
- Encapsulate behavior with data

### Comments
- Explain WHY, not WHAT
- Legal comments when required
- TODO comments (temporary)
- Avoid redundant comments
- Don't comment out code - delete it

## Refactoring Strategies

### Process
1. Identify a code smell
2. Identify appropriate refactoring
3. Apply the refactoring
4. Test that code still works
5. Commit the refactored code
6. Repeat until quality is acceptable

### Common Refactorings
- **Extract Method** - Break long methods into smaller ones
- **Rename** - Improve naming clarity
- **Move Method** - Fix feature envy
- **Replace Temp with Query** - Remove temporary variables
- **Replace Conditional with Polymorphism** - Eliminate switch statements
- **Introduce Parameter Object** - Reduce parameter lists
- **Extract Class** - Split large classes

## Anti-Patterns to Avoid

- **God Class** - One class that does everything
- **Primitive Obsession** - Using primitives instead of small objects
- **Shotgun Surgery** - Changes scattered across codebase
- **Copy-Paste Programming** - Duplicating code instead of abstracting
- **Magic Numbers/Strings** - Hardcoded values without context
- **Deep Nesting** - Too many levels of indentation
- **Arrow Anti-Pattern** - Excessive if/else nesting

## Implementation Approach

When reviewing or writing code:

1. **Check SOLID compliance** - Especially SRP and DIP
2. **Look for code smells** - Use the checklist above
3. **Evaluate coupling** - Can components be more independent?
4. **Assess cohesion** - Is related code grouped together?
5. **Review connascence** - Can stronger forms be weakened?
6. **Apply DRY** - Is there duplication to eliminate?
7. **Consider CUPID** - Is the code composable and predictable?

## Quality Metrics

- **Cyclomatic Complexity** - Keep functions simple (< 10)
- **Cognitive Complexity** - Code should be easy to understand
- **Test Coverage** - Aim for meaningful coverage
- **Duplication** - Minimize copy-paste code
- **Dependency Count** - Fewer dependencies = more maintainable

## Resources

- *Clean Code* by Robert C. Martin
- *Refactoring* by Martin Fowler
- *SOLID Principles* by Robert C. Martin
- [Connascence.io](https://connascence.io)
- [Code Smells Reference](https://refactoring.guru/refactoring/smells)
- *Anti Patterns* by William J. Brown et al.

## References

Detailed rules and examples are available in the references folder:

### SOLID Principles (5 rules)
- `solid-single-responsibility.md` - One reason to change
- `solid-open-closed.md` - Open for extension, closed for modification
- `solid-liskov-substitution.md` - Subtypes must be substitutable
- `solid-interface-segregation.md` - Many specific interfaces
- `solid-dependency-inversion.md` - Depend on abstractions

### CUPID Properties (5 rules)
- `cupid-composable.md` - Small, combinable units
- `cupid-unix-philosophy.md` - Do one thing well
- `cupid-predictable.md` - No surprises
- `cupid-idiomatic.md` - Follows conventions
- `cupid-domain-based.md` - Models the domain

### Code Smells (17 rules)
- `smell-duplicate-code.md` - DRY violations
- `smell-long-method.md` - Methods too long
- `smell-large-class.md` - God classes
- `smell-long-parameter-list.md` - Too many parameters
- `smell-comments.md` - Compensating for bad code
- `smell-data-class.md` - No behavior
- `smell-data-clumps.md` - Data traveling together
- `smell-feature-envy.md` - Method envies another class
- `smell-switch-statements.md` - Use polymorphism instead
- `smell-primitive-obsession.md` - Use domain objects
- `smell-message-chains.md` - Long call chains
- `smell-middle-man.md` - Excessive delegation
- `smell-divergent-change.md` - Multiple reasons to change
- `smell-shotgun-surgery.md` - Changes scattered everywhere
- `smell-speculative-generality.md` - YAGNI violations
- `smell-lazy-class.md` - Does too little
- `smell-refused-bequest.md` - Refuses inheritance
- `smell-temporary-field.md` - Fields used sometimes

### Connascence (2 comprehensive rules)
- `connascence-static.md` - Name, Type, Meaning, Position, Algorithm
- `connascence-dynamic.md` - Execution, Timing, Value, Identity

### Design Principles (1 rule)
- `coupling-cohesion.md` - Low coupling, high cohesion

### Clean Code (2 rules)
- `clean-code-naming.md` - Naming best practices
- `magic-numbers.md` - Avoid literals, use constants

### React Specific (2 rules)
- `react-solid-principles.md` - SOLID applied to React
- `react-thinking.md` - The 5 steps of thinking in React
