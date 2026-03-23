# Code Smell: Refused Bequest

**Category:** Code Smells - Object-Orientation Abusers
**Impact:** MEDIUM
**Difficulty to fix:** MEDIUM

## Description

A class that inherits from another but doesn't want or use much of what it inherits. The subclass "refuses" the bequest (gift) from its parent.

## Why It's a Problem

- Violates Liskov Substitution Principle
- Inheritance relationship doesn't make semantic sense
- Parent interface is cluttered with things subclass doesn't need
- Can lead to confusing behavior

## Bad Example

```python
class Bird:
    def __init__(self, name):
        self.name = name

    def fly(self):
        return f"{self.name} is flying!"

    def eat(self):
        return f"{self.name} is eating."

    def make_sound(self):
        return f"{self.name} chirps."

class Penguin(Bird):
    def fly(self):
        # Refuses the fly behavior!
        raise NotImplementedError("Penguins can't fly!")

    def swim(self):
        return f"{self.name} is swimming!"

# Problematic usage
def let_bird_fly(bird):
    return bird.fly()  # Will crash for penguins!

birds = [Bird("Sparrow"), Penguin("Emperor")]
for bird in birds:
    print(let_bird_fly(bird))  # Error on penguin!
```

## Good Example

```python
from abc import ABC, abstractmethod

# Base class with only common behavior
class Bird(ABC):
    def __init__(self, name):
        self.name = name

    def eat(self):
        return f"{self.name} is eating."

    @abstractmethod
    def move(self):
        pass

# Interface for flying capability
class FlyingBird(Bird):
    def fly(self):
        return f"{self.name} is flying!"

    def move(self):
        return self.fly()

class SwimmingBird(Bird):
    def swim(self):
        return f"{self.name} is swimming!"

    def move(self):
        return self.swim()

class Sparrow(FlyingBird):
    def make_sound(self):
        return f"{self.name} chirps."

class Penguin(SwimmingBird):
    def make_sound(self):
        return f"{self.name} honks."

# Now this works safely
def let_bird_move(bird):
    return bird.move()

birds = [Sparrow("Tweety"), Penguin("Emperor")]
for bird in birds:
    print(let_bird_move(bird))  # Works for all!
```

## Another Common Example: Collection Inheritance

```python
# Bad: Stack inherits all of List's methods
class Stack(list):
    def push(self, item):
        self.append(item)

    def pop(self):
        return super().pop()

# Problem: Stack exposes list methods it shouldn't
stack = Stack()
stack.push(1)
stack.push(2)
stack.insert(0, 99)  # Shouldn't be allowed for a stack!
stack[0] = 100       # Shouldn't be allowed!

# Good: Composition instead of inheritance
class Stack:
    def __init__(self):
        self._items = []

    def push(self, item):
        self._items.append(item)

    def pop(self):
        if not self._items:
            raise IndexError("Stack is empty")
        return self._items.pop()

    def peek(self):
        if not self._items:
            raise IndexError("Stack is empty")
        return self._items[-1]

    def is_empty(self):
        return len(self._items) == 0
```

## How to Fix

1. **Replace Inheritance with Delegation**: Use composition
2. **Push Down Method/Field**: Move unused members to siblings
3. **Extract Superclass**: Create intermediate class with common behavior
4. **Extract Interface**: Define what subclasses should implement

## When It's Acceptable

- Temporary state during refactoring
- Framework requires inheritance (but override sparingly)
- Method implementations are legitimately "do nothing"

## Detection

- Subclass overrides methods to throw exceptions
- Subclass overrides methods to do nothing
- Subclass uses very few parent methods
- Inheritance doesn't pass the "is-a" test

## Related Principles

- Liskov Substitution Principle
- Composition over Inheritance
- Interface Segregation Principle
