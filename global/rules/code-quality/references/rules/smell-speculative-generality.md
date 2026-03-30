# Code Smell: Speculative Generality

**Category:** Code Smells - Dispensables
**Impact:** MEDIUM
**Difficulty to fix:** LOW

## Description

> You get it when people say, "Oh, I think we need the ability to do this kind of thing someday" and thus want all sorts of hooks and special cases to handle things that aren't required. The result often is harder to understand and maintain. If all this machinery were being used, it would be worth it. But if it isn't, it isn't. The machinery just gets in the way, so get rid of it.
> -- *Refactoring* by Martin Fowler

Over-engineering for hypothetical future requirements that may never materialize. Also known as "YAGNI" violation (You Ain't Gonna Need It).

## Why It's a Problem

- Adds complexity with no current benefit
- Makes code harder to understand
- Increases maintenance burden
- Future requirements rarely match predictions
- Unused code still needs testing

## Bad Example

```python
# Over-engineered "just in case"
class DataProcessor:
    def __init__(self, config=None):
        self.config = config or {}
        self._plugins = []  # "We might need plugins later"
        self._middlewares = []  # "We might need middleware"
        self._event_handlers = {}  # "We might need events"
        self._cache = None  # "We might need caching"
        self._logger = None  # "We might need custom logging"

    def register_plugin(self, plugin):
        """We don't have any plugins yet, but we might!"""
        self._plugins.append(plugin)

    def add_middleware(self, middleware):
        """No middleware exists, but someday..."""
        self._middlewares.append(middleware)

    def on_event(self, event_name, handler):
        """No events are ever fired, but just in case..."""
        if event_name not in self._event_handlers:
            self._event_handlers[event_name] = []
        self._event_handlers[event_name].append(handler)

    def process(self, data, options=None):
        # The only method actually being used
        return data.upper()

# Abstract class with only one implementation
class AbstractNotificationService(ABC):
    @abstractmethod
    def send(self, message): pass

    @abstractmethod
    def send_batch(self, messages): pass  # Never used

    @abstractmethod
    def schedule(self, message, time): pass  # Never used

    @abstractmethod
    def cancel(self, message_id): pass  # Never used

class EmailService(AbstractNotificationService):
    def send(self, message):
        # The only method ever called
        pass

    def send_batch(self, messages):
        raise NotImplementedError("Not needed yet")

    def schedule(self, message, time):
        raise NotImplementedError("Not needed yet")

    def cancel(self, message_id):
        raise NotImplementedError("Not needed yet")
```

## Good Example

```python
# Simple and focused - only what's needed NOW
class DataProcessor:
    def process(self, data):
        return data.upper()

# When you actually need plugins, THEN add them:
# class DataProcessor:
#     def __init__(self):
#         self._plugins = []
#     def register_plugin(self, plugin):
#         self._plugins.append(plugin)

# Simple class, no unnecessary abstraction
class EmailService:
    def send(self, message):
        # Just what we need
        pass

# If you need more notification types later, THEN refactor
```

## The YAGNI Principle

**Y**ou **A**in't **G**onna **N**eed **I**t

- Don't add functionality until it's needed
- Don't make abstractions until there's more than one case
- Don't add parameters "just in case"
- Don't create interfaces for single implementations

## When Abstraction IS Appropriate

- When you have **two or more** concrete implementations
- When you're working with external dependencies (for testing)
- When following established patterns in your codebase
- When the abstraction aids understanding

## How to Fix

1. **Collapse Hierarchy**: Remove unused abstract classes
2. **Inline Class**: Merge classes that don't do much
3. **Remove Parameter**: Delete unused parameters
4. **Remove Dead Code**: Delete unused methods

## Detection

- Abstract classes with only one concrete subclass
- Parameters that are always passed as null/default
- Methods that are never called
- Comments saying "for future use"
- Configuration options that no one uses
- Unused hooks, callbacks, or extension points

## The Rule

> "Always implement things when you actually need them, never when you just foresee that you need them."
> -- Ron Jeffries
