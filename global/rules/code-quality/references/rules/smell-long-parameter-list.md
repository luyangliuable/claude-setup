# Code Smell: Long Parameter List

**Category:** Code Smells - Bloaters
**Impact:** MEDIUM-HIGH
**Difficulty to fix:** LOW-MEDIUM

## Description

More than three arguments to a function is generally problematic. Long parameter lists are hard to understand, easy to misuse, and often indicate that a function is doing too much.

## Why It's a Problem

- Difficult to remember parameter order
- Easy to pass arguments in wrong order
- Often indicates function doing too much
- Makes testing more complex
- Changes to parameters ripple through callers

## Bad Example

```ruby
def send_email(to, from, cc, bcc, subject, body, attachments,
               priority, read_receipt, reply_to, format)
    # ...
end

# Calling code is confusing
send_email("user@example.com", "admin@example.com", nil, nil,
           "Hello", "Body text", [], "high", true, nil, "html")
```

## Good Example

```ruby
# Using a parameter object
class EmailMessage
    attr_accessor :to, :from, :cc, :bcc, :subject, :body
    attr_accessor :attachments, :priority, :read_receipt
    attr_accessor :reply_to, :format

    def initialize(to:, from:, subject:, body:)
        @to = to
        @from = from
        @subject = subject
        @body = body
        @attachments = []
        @priority = :normal
        @format = :html
    end
end

def send_email(message)
    # ...
end

# Calling code is clear
message = EmailMessage.new(
    to: "user@example.com",
    from: "admin@example.com",
    subject: "Hello",
    body: "Body text"
)
message.priority = :high
message.read_receipt = true

send_email(message)
```

## Alternative: Named Parameters

```python
# Python with keyword arguments
def send_email(*, to, from_addr, subject, body,
               cc=None, bcc=None, priority='normal'):
    pass

# Clear at call site
send_email(
    to="user@example.com",
    from_addr="admin@example.com",
    subject="Hello",
    body="Body text",
    priority="high"
)
```

## How to Fix

1. **Introduce Parameter Object**: Group related parameters into a class
2. **Preserve Whole Object**: Pass an object instead of extracting values
3. **Use Named Parameters**: Languages supporting keyword arguments
4. **Replace Parameter with Method**: If parameter can be computed

## Guidelines

- 0-2 parameters: Ideal
- 3 parameters: Acceptable with good names
- 4+ parameters: Consider refactoring

## Related Smells

- Data Clumps (parameters that always appear together)
- Feature Envy (extracting data from objects to pass as parameters)
