# PR Review Standards

**MANDATORY: Before performing PR reviews, reference ~/pr_review_example.json**

- Review actual examples from team reviewers
- Follow established review patterns and coding standards

## Key Patterns to Check

### Code Quality

- Prefer absolute imports over relative imports
- Use nullish coalescing operator (??) over logical OR (||) for default values
- Question purpose of unclear or test files
- Check for unused mocks in tests
- Follow team conventions for prompt structure in agent files
- Enable JSON structured output for agent responses
- Always include error handling with try/except blocks and logging
- Keep operation types as strings for UI compatibility
