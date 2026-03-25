# PR Suggestion Fixes (CRITICAL)

**When fixing a PR review suggestion, apply the fix EVERYWHERE in the codebase:**

- Search for ALL occurrences of the pattern being fixed
- Apply the same fix consistently across all files
- Never fix just one instance if the same issue exists elsewhere
- Use Grep to find all occurrences before making changes
- Example: If reviewer says "use absolute imports", fix ALL relative imports, not just the one they commented on
