# Unit Test Standards

## Best Practices

- **NEVER add new mocks in PRs** - Fix root cause via config (vitest alias, etc.)
- **Test descriptions must be complete sentences** - Use descriptive sentences (e.g., "adds key-value pair to message context") not vague phrases (e.g., "works correctly", "handles correctly")
- Test success/failure scenarios
- **Aim for 70% minimum line coverage per file**
- <5s execution per test file

## What NOT to Test

- **NEVER write unit tests solely for testing CSS classes or styling**
- **NEVER write redundant or trivial tests** (e.g., testing that a component renders)
- **NEVER write duplicate tests** covering the same code path

## What to Focus On

- Business logic
- Edge cases
- Error handling
- State transitions

## What to Skip

- Visual styling
- Static text content
- Simple prop passing
