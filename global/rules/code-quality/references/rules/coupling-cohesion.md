# Coupling and Cohesion

**Category:** Design Principles
**Impact:** HIGH
**Difficulty to fix:** MEDIUM-HIGH

## The Golden Rule

> Strive for low coupling and high cohesion.

This means code should:
- **High Cohesion**: Group together code that contributes to a single task
- **Low Coupling**: Minimize dependencies between modules

---

## Cohesion

**Cohesion** measures how strongly related the elements within a module are.

### Why High Cohesion?

- Code is reusable
- Code is simple and focused
- Easy to understand
- Easy to test
- Creates small, focused objects

### Low Cohesion (Bad)

```python
class UserManager:
    def create_user(self, data): pass
    def send_email(self, to, subject, body): pass  # Unrelated!
    def generate_report(self, type): pass  # Unrelated!
    def validate_credit_card(self, number): pass  # Unrelated!
    def log_action(self, action): pass  # Unrelated!
```

This class does 5 unrelated things - it has LOW cohesion.

### High Cohesion (Good)

```python
class UserService:
    def create(self, data): pass
    def update(self, user_id, data): pass
    def delete(self, user_id): pass
    def find_by_id(self, user_id): pass
    def find_by_email(self, email): pass
```

All methods relate to user operations - HIGH cohesion.

### Cohesion Example: Asteroid Game

```java
// High cohesion - each behavior is focused
public class Ship {
    private void rotate() {
        // only rotation logic
    }

    private void move() {
        // only movement logic
    }

    private void fire() {
        // only firing logic
    }

    public void update(Input input) {
        if (input.isRotating()) rotate();
        if (input.isMoving()) move();
        if (input.isFiring()) fire();
    }
}
```

---

## Coupling

**Coupling** measures how dependent modules are on each other.

### Why Low Coupling?

- Code is more flexible
- Easier to change
- Easier to reuse
- Easier to test
- Changes don't ripple through system

### Tight Coupling (Bad)

```python
class Order:
    def __init__(self):
        # Directly depends on specific implementations
        self.database = MySQLDatabase()  # Tight coupling!
        self.emailer = SMTPEmailer()     # Tight coupling!
        self.logger = FileLogger()       # Tight coupling!

    def process(self):
        self.database.save(self)
        self.emailer.send("Order processed")
        self.logger.log("Order processed")
```

Changing database, email, or logging requires changing Order class.

### Loose Coupling (Good)

```python
class Order:
    def __init__(self, database, emailer, logger):
        # Depends on abstractions (interfaces)
        self.database = database
        self.emailer = emailer
        self.logger = logger

    def process(self):
        self.database.save(self)
        self.emailer.send("Order processed")
        self.logger.log("Order processed")

# Inject dependencies
order = Order(
    database=PostgresDatabase(),  # Easy to swap
    emailer=SendGridEmailer(),    # Easy to swap
    logger=CloudLogger()          # Easy to swap
)
```

### CSS and HTML Example

**Before CSS (Tight Coupling)**:
```html
<p><font color="red" size="4"><b>Warning!</b></font></p>
```

**With CSS (Loose Coupling)**:
```html
<p class="warning">Warning!</p>
```
```css
.warning { color: red; font-size: 1.2em; font-weight: bold; }
```

Presentation is now decoupled from structure.

### Intermediary Class Pattern

Reduce coupling by introducing intermediary objects:

**Tightly Coupled (Direct References)**:
```
Ship ←→ Bullet
Ship ←→ Asteroid
Bullet ←→ Asteroid
Bullet ←→ FlyingSaucer
Asteroid ←→ FlyingSaucer
```

**Loosely Coupled (Through Intermediary)**:
```
Ship → CollisionManager
Bullet → CollisionManager
Asteroid → CollisionManager
FlyingSaucer → CollisionManager
```

Adding a new object (Meteor) only requires connecting to CollisionManager.

---

## Measuring Coupling

Types of coupling (worst to best):

1. **Content Coupling** (Worst): Module modifies another's internal data
2. **Common Coupling**: Modules share global data
3. **Control Coupling**: Module controls another's flow
4. **Stamp Coupling**: Modules share composite data structure
5. **Data Coupling**: Modules share only primitive data
6. **Message Coupling** (Best): Modules communicate via messages only

---

## Balance

```
Monolithic        Optimal           Over-Decomposed
(High Coupling)   (Balanced)        (Too Many Small Parts)
```

- **Too much coupling**: Hard to change anything
- **Too little coupling**: Over-engineered, hard to follow flow
- **Right balance**: Modules are independent but work together

---

## Practical Guidelines

1. **Depend on abstractions** (interfaces, protocols)
2. **Inject dependencies** rather than creating them
3. **Keep related code together** (high cohesion)
4. **Use events/messages** for loose communication
5. **Follow Single Responsibility** (one reason to change)
6. **Minimize public API surface** (hide implementation details)
