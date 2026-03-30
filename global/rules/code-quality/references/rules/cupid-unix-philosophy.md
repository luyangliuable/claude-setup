# CUPID: Unix Philosophy

**Category:** CUPID Properties
**Impact:** HIGH
**Difficulty to fix:** MEDIUM

## Rule

> Do one thing and do it well.

Each module, function, or component should have a single, well-defined purpose that it executes excellently.

## Why It Matters

- Easier to understand, test, and maintain
- Clear responsibilities lead to clear interfaces
- Promotes reusability
- Reduces cognitive load

## Bad Example

```python
class UserManager:
    def process_user(self, user_data):
        # Validates
        if not user_data.get('email'):
            raise ValueError('Email required')
        if not user_data.get('name'):
            raise ValueError('Name required')

        # Transforms
        user_data['email'] = user_data['email'].lower()
        user_data['name'] = user_data['name'].title()

        # Saves
        self.db.save(user_data)

        # Sends welcome email
        self.email_service.send(
            user_data['email'],
            'Welcome!',
            f"Hello {user_data['name']}"
        )

        # Logs
        self.logger.info(f"User created: {user_data['email']}")

        # Analytics
        self.analytics.track('user_created', user_data)

        return user_data
```

## Good Example

```python
class UserValidator:
    def validate(self, user_data):
        if not user_data.get('email'):
            raise ValueError('Email required')
        if not user_data.get('name'):
            raise ValueError('Name required')
        return user_data

class UserNormalizer:
    def normalize(self, user_data):
        return {
            **user_data,
            'email': user_data['email'].lower(),
            'name': user_data['name'].title()
        }

class UserRepository:
    def save(self, user_data):
        return self.db.save(user_data)

class WelcomeEmailer:
    def send_welcome(self, user):
        self.email_service.send(
            user['email'],
            'Welcome!',
            f"Hello {user['name']}"
        )

# Orchestration layer composes them
class UserRegistration:
    def register(self, user_data):
        validated = self.validator.validate(user_data)
        normalized = self.normalizer.normalize(validated)
        saved = self.repository.save(normalized)
        self.emailer.send_welcome(saved)
        return saved
```

## Detection

- Class or function names with "And" or "Manager"
- Functions with multiple unrelated operations
- Long parameter lists
- Difficulty describing what a function does in one sentence

## How to Fix

1. Identify distinct operations within the code
2. Extract each into its own unit with a clear name
3. Each unit should be testable independently
4. Create an orchestration layer to combine units
