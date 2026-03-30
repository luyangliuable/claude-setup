# Code Smell: Data Clumps

**Category:** Code Smells - Bloaters
**Impact:** MEDIUM
**Difficulty to fix:** MEDIUM

## Description

> Data items tend to be like children; they enjoy hanging around in groups together. Often you'll see the same three or four data items together in lots of places: fields in a couple of classes, parameters in many method signatures.
> -- *Refactoring* by Martin Fowler

When the same group of data appears together repeatedly, it should be its own object.

## Why It's a Problem

- Violates DRY principle
- Increases parameter counts
- Scatters related logic
- Easy to pass parameters in wrong order
- Hard to add new data to the group

## Bad Example

```ruby
# x, y coordinates appear together everywhere
def draw_line(start_x, start_y, end_x, end_y)
    # ...
end

def draw_circle(center_x, center_y, radius)
    # ...
end

def draw_rectangle(x, y, width, height)
    # ...
end

def move_shape(shape, new_x, new_y)
    # ...
end

def calculate_distance(x1, y1, x2, y2)
    Math.sqrt((x2 - x1)**2 + (y2 - y1)**2)
end
```

## Good Example

```ruby
class Point
    attr_reader :x, :y

    def initialize(x, y)
        @x = x
        @y = y
    end

    def distance_to(other)
        Math.sqrt((other.x - x)**2 + (other.y - y)**2)
    end
end

def draw_line(start_point, end_point)
    # ...
end

def draw_circle(center, radius)
    # ...
end

def draw_rectangle(origin, width, height)
    # ...
end

def move_shape(shape, new_position)
    # ...
end
```

## Another Example: Date Range

```python
# Bad: start_date and end_date always together
def get_sales_report(start_date, end_date, region):
    pass

def calculate_revenue(start_date, end_date, products):
    pass

def count_orders(start_date, end_date):
    pass

# Good: Extract DateRange class
@dataclass
class DateRange:
    start: date
    end: date

    def contains(self, d: date) -> bool:
        return self.start <= d <= self.end

    @property
    def days(self) -> int:
        return (self.end - self.start).days

def get_sales_report(period: DateRange, region):
    pass

def calculate_revenue(period: DateRange, products):
    pass

def count_orders(period: DateRange):
    pass
```

## How to Identify

Look for data that:
- Always appears together in method signatures
- Is stored together in multiple classes
- Is validated together
- Has operations that apply to the group

## How to Fix

1. **Extract Class**: Create a class for the clumped data
2. **Introduce Parameter Object**: Replace parameter groups with object
3. **Preserve Whole Object**: Pass object instead of extracting parts
4. **Move methods** that operate on the clump into the new class

## Related Smells

- Long Parameter List
- Primitive Obsession
- Feature Envy
