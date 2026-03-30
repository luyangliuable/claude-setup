# CUPID: Composable

**Category:** CUPID Properties
**Impact:** HIGH
**Difficulty to fix:** MEDIUM

## Rule

> Code should play well with others. Components should be small, focused units that can be combined in various ways.

Composable code consists of small, focused pieces that can be easily combined to create larger functionality.

## Why It Matters

- Enables code reuse without copy-paste
- Makes testing easier (test small units)
- Allows flexibility in combining behaviors
- Reduces coupling between components

## Bad Example

```javascript
// Monolithic function doing everything
function processUserOrder(userId, items, paymentInfo, shippingAddress) {
    // Validate user
    const user = db.findUser(userId);
    if (!user) throw new Error('User not found');
    if (!user.isActive) throw new Error('User inactive');

    // Validate items
    for (const item of items) {
        const product = db.findProduct(item.id);
        if (product.stock < item.quantity) {
            throw new Error('Insufficient stock');
        }
    }

    // Process payment
    const payment = paymentGateway.charge(paymentInfo, calculateTotal(items));

    // Create order
    const order = db.createOrder({ userId, items, payment, shippingAddress });

    // Send notifications
    emailService.send(user.email, 'Order confirmed', order);
    smsService.send(user.phone, 'Order confirmed');

    return order;
}
```

## Good Example

```javascript
// Small, composable functions
const validateUser = (userId) => {
    const user = db.findUser(userId);
    if (!user) throw new Error('User not found');
    if (!user.isActive) throw new Error('User inactive');
    return user;
};

const validateStock = (items) => {
    for (const item of items) {
        const product = db.findProduct(item.id);
        if (product.stock < item.quantity) {
            throw new Error('Insufficient stock');
        }
    }
    return items;
};

const processPayment = (paymentInfo, amount) =>
    paymentGateway.charge(paymentInfo, amount);

const createOrder = (data) => db.createOrder(data);

const notifyUser = (user, order) => {
    emailService.send(user.email, 'Order confirmed', order);
    smsService.send(user.phone, 'Order confirmed');
};

// Compose them together
function processUserOrder(userId, items, paymentInfo, shippingAddress) {
    const user = validateUser(userId);
    validateStock(items);
    const payment = processPayment(paymentInfo, calculateTotal(items));
    const order = createOrder({ userId, items, payment, shippingAddress });
    notifyUser(user, order);
    return order;
}
```

## Detection

- Functions longer than 20-30 lines
- Functions with multiple levels of abstraction
- Difficulty reusing parts of a function
- Functions that are hard to test in isolation

## How to Fix

1. Identify distinct responsibilities within the code
2. Extract each into its own function/module
3. Design functions to accept inputs and return outputs (pure when possible)
4. Use composition to combine small pieces into larger workflows
