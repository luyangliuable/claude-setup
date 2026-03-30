# Code Smell: Data Class

**Category:** Code Smells - Dispensables
**Impact:** MEDIUM
**Difficulty to fix:** MEDIUM

## Description

> Classes that have fields, getting and setting methods for the fields, and nothing else. Such classes are dumb data holders and are almost certainly being manipulated in far too much detail by other classes.
> -- *Refactoring* by Martin Fowler

A Data Class ties data together but provides no behavior, leading to logic being scattered elsewhere.

## Why It's a Problem

- Logic that should be with the data is spread across the codebase
- Violates encapsulation (data and behavior should be together)
- Often leads to duplicate code
- Makes it hard to maintain invariants

## Bad Example

```ruby
class Point
    attr_accessor :x
    attr_accessor :y

    def initialize(x = 0, y = 0)
        @x = x
        @y = y
    end
end

# Logic scattered in other classes
class GeometryUtils
    def self.distance(point1, point2)
        Math.sqrt((point1.x - point2.x)**2 + (point1.y - point2.y)**2)
    end

    def self.midpoint(point1, point2)
        Point.new(
            (point1.x + point2.x) / 2.0,
            (point1.y + point2.y) / 2.0
        )
    end

    def self.translate(point, dx, dy)
        Point.new(point.x + dx, point.y + dy)
    end
end
```

## Good Example

```ruby
class Point
    attr_reader :x, :y  # Immutable is often better

    def initialize(x = 0, y = 0)
        @x = x
        @y = y
    end

    def distance_to(other = Point.new)
        Math.sqrt((x - other.x)**2 + (y - other.y)**2)
    end

    def midpoint_to(other)
        Point.new(
            (x + other.x) / 2.0,
            (y + other.y) / 2.0
        )
    end

    def translate(dx, dy)
        Point.new(x + dx, y + dy)
    end

    def to_s
        "(#{x}, #{y})"
    end
end

# Usage is cleaner and more OO
origin = Point.new
point = Point.new(3, 4)

puts point.distance_to(origin)  # => 5.0
puts point.midpoint_to(origin)  # => (1.5, 2.0)
```

## Exception: DTOs and Value Objects

Data Transfer Objects (DTOs) for serialization/API boundaries are acceptable:

```python
@dataclass
class UserDTO:
    id: int
    name: str
    email: str
    # Pure data for JSON serialization - OK
```

But domain objects should have behavior:

```python
class User:
    def __init__(self, id, name, email):
        self.id = id
        self.name = name
        self.email = email

    def change_email(self, new_email):
        if not self._valid_email(new_email):
            raise InvalidEmailError(new_email)
        self.email = new_email

    def _valid_email(self, email):
        return '@' in email and '.' in email
```

## How to Fix

1. **Move Method**: Move behavior from other classes into the data class
2. **Encapsulate Field**: Add validation in setters if needed
3. **Encapsulate Collection**: Return defensive copies
4. **Remove Setting Method**: Make immutable where possible

## Detection

- Class has only fields and getters/setters
- Other classes have methods that operate primarily on this class's data
- Feature Envy in other classes toward this class

## Related Smells

- Feature Envy (methods that should be in this class)
- Primitive Obsession (opposite problem - no class at all)
