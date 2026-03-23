# Code Smell: Large Class (God Class)

**Category:** Code Smells - Bloaters
**Impact:** HIGH
**Difficulty to fix:** HIGH

## Description

A class that tries to do too much, often becoming a catch-all for functionality. Also known as "God Class" - one big class that has all the methods while other classes just contain data.

## Why It's a Problem

- Violates Single Responsibility Principle
- Has many reasons to change
- Difficult to understand and maintain
- Hard to test
- Creates tight coupling (everything depends on it)

## Signs of a God Class

- Hundreds or thousands of lines
- Many unrelated methods grouped together
- Name includes "Manager", "Handler", "Processor", "Utils"
- Other classes are mostly data holders
- Requires many imports/dependencies

## Bad Example

```java
public class UserManager {
    // User CRUD
    public User createUser(String name, String email) { ... }
    public User getUser(int id) { ... }
    public void updateUser(User user) { ... }
    public void deleteUser(int id) { ... }

    // Authentication
    public boolean authenticate(String email, String password) { ... }
    public String generateToken(User user) { ... }
    public boolean validateToken(String token) { ... }
    public void resetPassword(String email) { ... }

    // Email operations
    public void sendWelcomeEmail(User user) { ... }
    public void sendPasswordResetEmail(User user) { ... }
    public void sendNewsletter(List<User> users) { ... }

    // Reporting
    public Report generateUserReport() { ... }
    public List<User> getActiveUsers() { ... }
    public Map<String, Integer> getUserStatistics() { ... }

    // Permissions
    public boolean hasPermission(User user, String permission) { ... }
    public void grantPermission(User user, String permission) { ... }
    public void revokePermission(User user, String permission) { ... }

    // Profile
    public void updateProfile(User user, Profile profile) { ... }
    public void uploadAvatar(User user, File avatar) { ... }

    // ... and dozens more methods
}
```

## Good Example

```java
// Focused classes with single responsibilities
public class UserRepository {
    public User create(String name, String email) { ... }
    public User findById(int id) { ... }
    public void update(User user) { ... }
    public void delete(int id) { ... }
}

public class AuthenticationService {
    public boolean authenticate(String email, String password) { ... }
    public String generateToken(User user) { ... }
    public boolean validateToken(String token) { ... }
}

public class PasswordService {
    public void resetPassword(String email) { ... }
    public void changePassword(User user, String newPassword) { ... }
}

public class UserEmailService {
    public void sendWelcome(User user) { ... }
    public void sendPasswordReset(User user) { ... }
}

public class UserReportService {
    public Report generateReport() { ... }
    public Map<String, Integer> getStatistics() { ... }
}

public class PermissionService {
    public boolean hasPermission(User user, String permission) { ... }
    public void grant(User user, String permission) { ... }
    public void revoke(User user, String permission) { ... }
}

public class ProfileService {
    public void updateProfile(User user, Profile profile) { ... }
    public void uploadAvatar(User user, File avatar) { ... }
}
```

## How to Fix

1. **Extract Class**: Identify groups of related methods and fields
2. **Extract Subclass**: If variations exist, use inheritance
3. **Extract Interface**: Define contracts for different behaviors
4. **Apply SRP**: Each class should have one reason to change

## Detection

- Class has more than 200-300 lines
- Class has more than 10-15 methods
- Class has multiple groups of related methods
- IDE shows many responsibilities in outline view
- High coupling metrics

## Related Smells

- Single Responsibility Principle violation
- Feature Envy (methods envying other classes)
- Data Class (counterpart - too little responsibility)
