# CUPID: Predictable

**Category:** CUPID Properties
**Impact:** HIGH
**Difficulty to fix:** MEDIUM

## Rule

> Code should do what you expect, behave consistently, and have no surprises.

Functions and components should have predictable behavior based on their names and signatures.

## Why It Matters

- Reduces cognitive load when reading code
- Makes debugging easier
- Prevents unexpected side effects
- Builds trust in the codebase

## Bad Example

```javascript
// Function name suggests it just gets a user
function getUser(userId) {
    const user = db.findById(userId);

    // Surprise! Updates last access time
    user.lastAccessTime = new Date();
    db.save(user);

    // Surprise! Sends analytics
    analytics.track('user_accessed', { userId });

    // Surprise! Might return null OR throw
    if (!user.isActive) {
        throw new Error('User inactive');
    }

    return user;
}

// Function modifies input unexpectedly
function formatItems(items) {
    items.sort((a, b) => a.name.localeCompare(b.name)); // Mutates!
    items.forEach(item => {
        item.price = item.price.toFixed(2); // Mutates!
    });
    return items;
}
```

## Good Example

```javascript
// Name clearly indicates action
function findUserById(userId) {
    return db.findById(userId); // Just finds, nothing else
}

function recordUserAccess(user) {
    return db.save({
        ...user,
        lastAccessTime: new Date()
    });
}

// Pure function - no mutations
function formatItems(items) {
    return [...items]
        .sort((a, b) => a.name.localeCompare(b.name))
        .map(item => ({
            ...item,
            price: item.price.toFixed(2)
        }));
}

// Clear error handling contract
function getActiveUser(userId) {
    const user = findUserById(userId);
    if (!user) return null;
    if (!user.isActive) return null;
    return user;
}

// OR explicit throwing version
function getActiveUserOrThrow(userId) {
    const user = findUserById(userId);
    if (!user) throw new UserNotFoundError(userId);
    if (!user.isActive) throw new UserInactiveError(userId);
    return user;
}
```

## Detection

- Functions with side effects not indicated by their name
- Functions that mutate their inputs
- Inconsistent return types (sometimes null, sometimes throws)
- Hidden dependencies on global state
- Surprising behavior on edge cases

## How to Fix

1. Name functions to accurately describe ALL their effects
2. Prefer pure functions that don't mutate inputs
3. Be consistent with error handling (null vs throw)
4. Document any unavoidable surprises
5. Separate queries (get data) from commands (change state)
