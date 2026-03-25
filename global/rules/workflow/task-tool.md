# Task Tool

**CRITICAL: NEVER USE EXPLORE()**

- **NEVER use Task tool with subagent_type='Explore'**
- **NEVER call Explore() function - causes API errors**
- **ALWAYS use direct tools instead:**
  - Glob for file pattern matching
  - Grep for content search
  - Read for file reading
- **NO EXCEPTIONS - direct tools only**
