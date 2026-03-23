# Code Smell: Comments

**Category:** Code Smells - Dispensables
**Impact:** LOW-MEDIUM
**Difficulty to fix:** LOW

## Description

> It's surprising how often you look at thickly commented code and notice that the comments are there because the code is bad.
> -- *Refactoring* by Martin Fowler

Comments aren't inherently bad, but they're often used as a crutch to allow poorly written code to remain so. If possible, code should be written so comments are unnecessary.

## When Comments Are a Smell

- Comments explaining **what** the code does (code should be self-explanatory)
- Comments compensating for bad naming
- Commented-out code
- Obvious comments that add no value
- Comments that are out of date with the code

## When Comments Are Good

- Explaining **why** something is done a certain way
- Documenting public APIs
- Warning about consequences or edge cases
- Legal/license comments when required
- TODO comments (temporarily)

## Bad Example

```ruby
# This method checks if the color is a valid SVG color
def check_color(c)
    # Check if it starts with hash
    if c[0] == '#'
        # Check if it matches the hex pattern
        return c =~ /^#[0-9A-Fa-f]{3}([0-9A-Fa-f]{3})?$/
    end
    # Check if it's a named color
    COLORS.include?(c)  # return true if in list
end
```

## Good Example

```ruby
# SVG color format reference:
# - #rgb or #rrggbb (hex format)
# - Named colors from SVG spec
# Note: rgb(255,0,0) format not yet supported
def valid_svg_color?(color)
    return valid_hex_color?(color) if color.start_with?('#')
    SVG_COLOR_NAMES.include?(color)
end

def valid_hex_color?(color)
    color.match?(/^#[0-9A-Fa-f]{3}([0-9A-Fa-f]{3})?$/)
end
```

The second example:
- Uses clear method names instead of comments
- Keeps the **why** comment (SVG spec reference)
- Documents intentional limitation (rgb format)

## Anti-Pattern: Commented-Out Code

```java
// DON'T DO THIS
public void processOrder(Order order) {
    validateOrder(order);
    // calculateDiscount(order);  // Removed in v2.3
    // if (order.isPriority()) {
    //     priorityQueue.add(order);
    // }
    processPayment(order);
    // sendNotification(order);  // TODO: re-enable later
}
```

**Just delete it!** Version control preserves history.

## How to Fix

1. **Extract Method**: Replace comment with well-named method
2. **Rename**: Use intention-revealing names
3. **Introduce Explaining Variable**: Name complex expressions
4. **Delete Dead Code**: Remove commented-out code
5. **Write Self-Documenting Code**: Code that reads like prose

## Documentation Comments

Documentation comments (docstrings, JSDoc, etc.) are different - they describe **public interfaces** and are often useful:

```python
def calculate_compound_interest(principal, rate, years, frequency=12):
    """
    Calculate compound interest.

    Args:
        principal: Initial investment amount
        rate: Annual interest rate (as decimal, e.g., 0.05 for 5%)
        years: Number of years
        frequency: Compounding frequency per year (default: monthly)

    Returns:
        Final amount after compound interest
    """
    return principal * (1 + rate/frequency) ** (frequency * years)
```

This is good because it documents the public API contract.
