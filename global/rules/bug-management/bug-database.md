# Bug Database (CRITICAL)

**MANDATORY: Update ~/bug-database/bug_database.json after every bug resolution**

- Create/update ~/bug-database/bug_database.json after resolving any bug
- This is a GLOBAL file across ALL projects in the bug-database repository
- Document all issues, solutions, and prevention measures
- This is CRITICAL for learning and preventing regressions

## Format

```json
[
    {
        "bug_description": "Description of the issue",
        "date": "YYYY-MM-DD",
        "type": "category (workflow, config, logic, etc)",
        "location": "GitHub repository link to file/component (not local computer path)",
        "solution": "what was done to fix it",
        "code_example": "relevant code snippet showing the fix or before/after",
        "language": "programming language (bash, javascript, yaml, etc)"
    }
]
```

**IMPORTANT:** For location field, always use GitHub repository links (e.g. https://github.com/user/repo/blob/main/path/to/file.js) instead of local computer paths so others can access the referenced files.
