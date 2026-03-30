# Code Smell: Long Method

**Category:** Code Smells - Bloaters
**Impact:** HIGH
**Difficulty to fix:** MEDIUM

## Description

The longer a function is, the more difficult it is to understand. Long methods try to do too much and become hard to maintain, test, and reuse.

## Why It's a Problem

- Difficult to understand at a glance
- Hard to test individual behaviors
- Encourages duplication (copying parts instead of reusing)
- Often violates Single Responsibility Principle
- Difficult to name accurately

## Guidelines

- Methods should ideally be 5-20 lines
- If you can't see the whole method on screen, it's too long
- Each method should do one thing at one level of abstraction

## Bad Example

```ruby
def process_order(order)
    # Validate order
    return false if order.nil?
    return false if order.items.empty?
    order.items.each do |item|
        return false if item.quantity <= 0
        return false if item.price <= 0
    end

    # Calculate totals
    subtotal = 0
    order.items.each do |item|
        subtotal += item.price * item.quantity
    end
    tax = subtotal * 0.1
    shipping = order.items.length > 5 ? 0 : 5.99
    total = subtotal + tax + shipping

    # Apply discounts
    if order.customer.is_premium?
        total = total * 0.9
    end
    if order.coupon_code == "SAVE20"
        total = total - 20
    end

    # Process payment
    payment_result = payment_gateway.charge(order.customer.card, total)
    return false unless payment_result.success?

    # Update inventory
    order.items.each do |item|
        product = Product.find(item.product_id)
        product.stock -= item.quantity
        product.save!
    end

    # Send notifications
    EmailService.send_confirmation(order.customer.email, order)
    SMSService.send_confirmation(order.customer.phone, order)

    # Log and return
    Logger.info("Order #{order.id} processed successfully")
    true
end
```

## Good Example

```ruby
def process_order(order)
    return false unless valid_order?(order)

    total = calculate_order_total(order)
    total = apply_discounts(total, order)

    return false unless process_payment(order.customer, total)

    update_inventory(order.items)
    send_notifications(order)

    Logger.info("Order #{order.id} processed successfully")
    true
end

private

def valid_order?(order)
    return false if order.nil? || order.items.empty?
    order.items.all? { |item| item.quantity > 0 && item.price > 0 }
end

def calculate_order_total(order)
    subtotal = order.items.sum { |item| item.price * item.quantity }
    tax = subtotal * TAX_RATE
    shipping = order.items.length > FREE_SHIPPING_THRESHOLD ? 0 : SHIPPING_COST
    subtotal + tax + shipping
end

def apply_discounts(total, order)
    total *= PREMIUM_DISCOUNT if order.customer.is_premium?
    total -= COUPON_VALUE if order.coupon_code == COUPON_CODE
    total
end

def process_payment(customer, total)
    payment_gateway.charge(customer.card, total).success?
end

def update_inventory(items)
    items.each do |item|
        product = Product.find(item.product_id)
        product.decrement_stock(item.quantity)
    end
end

def send_notifications(order)
    EmailService.send_confirmation(order.customer.email, order)
    SMSService.send_confirmation(order.customer.phone, order)
end
```

## How to Fix

1. **Extract Method**: Pull out logical chunks into named methods
2. **Replace Temp with Query**: Convert temporary variables to methods
3. **Decompose Conditional**: Extract complex conditions into methods
4. **Replace Method with Method Object**: For very complex methods

## Detection

- Method doesn't fit on one screen
- You need to scroll to understand it
- Comments marking "sections" within the method
- Multiple levels of nesting
- Many local variables
