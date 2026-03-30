# CUPID: Idiomatic

**Category:** CUPID Properties
**Impact:** MEDIUM
**Difficulty to fix:** LOW-MEDIUM

## Rule

> Code should feel natural in its environment. Follow the conventions and patterns of the language, framework, and team.

Write code that experienced developers in that ecosystem would recognize and understand immediately.

## Why It Matters

- Reduces friction when reading unfamiliar code
- Leverages community knowledge and best practices
- Makes code easier for new team members
- Enables better tooling support (linters, formatters)

## Bad Example (Non-idiomatic JavaScript)

```javascript
// Java-style getters/setters in JavaScript
class User {
    constructor() {
        this._name = '';
        this._age = 0;
    }

    getName() {
        return this._name;
    }

    setName(name) {
        this._name = name;
    }

    getAge() {
        return this._age;
    }

    setAge(age) {
        this._age = age;
    }
}

// Non-idiomatic iteration
for (var i = 0; i < users.length; i++) {
    var user = users[i];
    console.log(user.getName());
}
```

## Good Example (Idiomatic JavaScript)

```javascript
// Idiomatic JavaScript class with property access
class User {
    constructor(name = '', age = 0) {
        this.name = name;
        this.age = age;
    }

    // Only add getters/setters if you need logic
    get displayName() {
        return `${this.name} (${this.age})`;
    }
}

// Idiomatic iteration
users.forEach(user => console.log(user.name));
// or
for (const user of users) {
    console.log(user.name);
}
```

## Bad Example (Non-idiomatic Python)

```python
# JavaScript-style code in Python
def processUsers(userList):
    result = []
    for i in range(len(userList)):
        user = userList[i]
        if user['active'] == True:
            result.append(user['name'])
    return result
```

## Good Example (Idiomatic Python)

```python
# Pythonic code
def process_users(users):
    return [user['name'] for user in users if user['active']]
```

## Detection

- Code that looks like it was written in a different language
- Not using language-specific features (list comprehensions, spread operator)
- Inconsistent naming conventions (camelCase vs snake_case)
- Reinventing functionality that exists in standard library
- Fighting the framework instead of working with it

## How to Fix

1. Learn the idioms of your language/framework
2. Follow official style guides (PEP 8, Airbnb JS, etc.)
3. Use linters and formatters (ESLint, Prettier, Black)
4. Read well-regarded open source projects in your ecosystem
5. Stay consistent with your team's conventions
