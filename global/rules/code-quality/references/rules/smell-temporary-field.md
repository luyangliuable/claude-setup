# Code Smell: Temporary Field

**Category:** Code Smells - Object-Orientation Abusers
**Impact:** MEDIUM
**Difficulty to fix:** MEDIUM

## Description

> Sometimes you see an object in which an instance variable is set only in certain circumstances. Such code is difficult to understand, because you expect an object to need all of its variables.
> -- *Refactoring* by Martin Fowler

A class has fields that are only used in some situations, often being `null` or empty in other contexts.

## Why It's a Problem

- Confusing to understand when fields are valid
- Leads to null checks scattered throughout
- Object state is unclear
- Fields may not be initialized properly
- Indicates the class might be doing too much

## Bad Example

```python
class ReportGenerator:
    def __init__(self):
        self.title = None
        self.data = None
        self.summary_stats = None  # Only used for detailed reports
        self.chart_data = None     # Only used for graphical reports
        self.recipients = None     # Only used when emailing

    def generate_simple_report(self, title, data):
        self.title = title
        self.data = data
        # summary_stats, chart_data, recipients unused
        return self._format_simple()

    def generate_detailed_report(self, title, data):
        self.title = title
        self.data = data
        self.summary_stats = self._calculate_stats()  # Now it's used
        # chart_data, recipients still unused
        return self._format_detailed()

    def generate_and_email_report(self, title, data, recipients):
        self.title = title
        self.data = data
        self.recipients = recipients  # Now it's used
        report = self._format_simple()
        self._send_email(report)

    def _format_detailed(self):
        # Has to check if summary_stats exists
        if self.summary_stats:
            # use it
            pass
```

## Good Example

```python
# Option 1: Use method parameters instead of fields
class ReportGenerator:
    def generate_simple_report(self, title, data):
        return SimpleReport(title, data).format()

    def generate_detailed_report(self, title, data):
        stats = self._calculate_stats(data)
        return DetailedReport(title, data, stats).format()

    def generate_and_email_report(self, title, data, recipients):
        report = self.generate_simple_report(title, data)
        EmailService().send(recipients, report)

# Option 2: Separate classes for different report types
class SimpleReport:
    def __init__(self, title, data):
        self.title = title
        self.data = data

    def format(self):
        return f"# {self.title}\n{self.data}"

class DetailedReport:
    def __init__(self, title, data, stats):
        self.title = title
        self.data = data
        self.stats = stats  # Always present for detailed reports

    def format(self):
        return f"# {self.title}\n{self.data}\n\nStats: {self.stats}"

# Option 3: Null Object pattern for optional data
class NoStats:
    def format(self):
        return ""

class Stats:
    def __init__(self, data):
        self.mean = sum(data) / len(data)
        self.count = len(data)

    def format(self):
        return f"Mean: {self.mean}, Count: {self.count}"
```

## How to Fix

1. **Extract Class**: Create separate class for the special case
2. **Replace Temp Field with Local Variable**: Pass as parameters
3. **Introduce Null Object**: Create a "do nothing" object
4. **Move Fields**: Put them in the class that actually uses them

## Detection

- Fields that are `null` most of the time
- Null checks before using a field
- Fields only set in certain methods
- Fields with names like `temp_`, `cached_`, or `_for_x`
- Comments explaining when fields are valid

## Common Scenarios

1. **Caching**: Use explicit cache object instead
2. **Algorithm state**: Use parameter object or local variables
3. **Optional data**: Use Null Object or Optional type
4. **Different modes**: Extract separate classes

## Related Smells

- Large Class (often has temporary fields)
- Data Class (may have unused fields)
- Divergent Change (fields for different responsibilities)
