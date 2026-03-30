# PR Size Guidelines (CRITICAL)

**MANDATORY: Keep PRs small and reviewable to ensure they get reviewed promptly**

## Hard Limits

- **Maximum 300 lines changed per PR** (additions + deletions)
- If a feature requires more changes, break it into multiple sequential PRs
- Each PR must be independently reviewable and mergeable

## Why This Matters

- Large PRs (>300 lines) don't get reviewed - reviewers avoid them
- Small PRs get reviewed faster and more thoroughly
- Smaller changes = fewer bugs, easier rollbacks, better code quality

## Implementation Strategy

### 1. Break features into phases:
- PR 1: Core infrastructure/types (≤300 lines)
- PR 2: Business logic (≤300 lines)
- PR 3: UI integration (≤300 lines)
- PR 4: Tests and polish (≤300 lines)

### 2. Each PR should:
- Have a clear, single purpose
- Be fully functional (no half-implemented features)
- Include relevant tests
- Be independently deployable when possible

### 3. Before creating PR:
- Run `git diff --stat main` to check line count
- If >300 lines, stop and break into smaller PRs
- Ask user how to split the work if unclear

## Enforcement

- If I suggest changes that would create >300 line PR, user should reject it
- I must proactively suggest breaking work into multiple PRs
- Never create bloated PRs that won't get reviewed
