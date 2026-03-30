# Code Smell: Message Chains

**Category:** Code Smells - Couplers
**Impact:** MEDIUM
**Difficulty to fix:** MEDIUM

## Description

You see message chains when a client asks one object for another object, which the client then asks for yet another object, and so on. The client becomes coupled to the entire chain structure.

## Why It's a Problem

- Client depends on the structure of the entire chain
- If any link in the chain changes, client code breaks
- Violates Law of Demeter ("only talk to immediate friends")
- Creates tight coupling to implementation details
- Makes code brittle and hard to refactor

## Bad Example

```ruby
# Client knows too much about the structure
salary = database.get_company(company_name)
                .get_manager(manager_name)
                .get_team_member(employee_name)
                .salary

# If employee storage structure changes, this breaks
address = order.get_customer
              .get_billing_info
              .get_address
              .get_street_name

# Deep navigation into object graph
config_value = app.get_config
                  .get_section('database')
                  .get_subsection('connection')
                  .get_value('timeout')
```

## Good Example

```ruby
# Better: Ask for what you need directly
salary = database.get_employee_salary(employee_name)

# The database can change its internal structure freely
class Database
    def get_employee_salary(employee_name)
        employee = find_employee(employee_name)
        employee&.salary
    end

    private

    def find_employee(name)
        # Internal structure is hidden
        # Can change from company->manager->employee to flat lookup
        @employees[name]
    end
end

# Better: Delegate through meaningful methods
address = order.billing_street_name

class Order
    def billing_street_name
        customer&.billing_address&.street_name
    end
end

# Better: Use a configuration accessor
config_value = app.get_config_value('database.connection.timeout')
```

## Message Chains vs Fluent Interfaces

**Message Chains (BAD)**: Each call returns a *different* object

```ruby
# Each call navigates to a different object
order.customer.address.city  # 4 different objects
```

**Fluent Interface (OK)**: Each call returns the *same* object (or same type)

```ruby
# All calls on the same canvas object
canvas.draw_line(from, to)
      .draw_circle(center, radius)
      .draw_text(position, text)

# Method chaining for configuration (same builder)
query.select('name', 'email')
     .from('users')
     .where('active = true')
     .order_by('name')
     .build()
```

## How to Fix

1. **Hide Delegate**: Add a method that does the navigation
2. **Extract Method**: Move chain into a meaningful method
3. **Move Method**: Put logic closer to the data it needs

## The Law of Demeter

A method should only call methods on:
- `self`
- Parameters passed to it
- Objects it creates
- Its direct component objects

```python
# Violates Law of Demeter
def get_city(order):
    return order.customer.address.city  # 3 dots!

# Follows Law of Demeter
def get_city(order):
    return order.shipping_city()  # Ask order directly

class Order:
    def shipping_city(self):
        return self.customer.shipping_city()

class Customer:
    def shipping_city(self):
        return self.address.city
```

## When Chains Are OK

- Fluent APIs designed for chaining
- Navigating well-known stable structures (like DOM)
- Internal implementation details (not public API)

## Related Smells

- Middle Man (sometimes overcorrection for chains)
- Feature Envy (chains often indicate envy)
- Inappropriate Intimacy
