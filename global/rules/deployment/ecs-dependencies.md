# ECS Deployment - Code Changes and Dependencies

**Key considerations:**

- All dependencies imported by runtime config files must be in package.json
- Example: If `drizzle.config.ts` imports `dotenv/config`, add `"dotenv": "^16.5.0"` to dependencies
- Runtime dependencies ≠ build-time dependencies (ECS container needs runtime deps)
- Dockerfile copies node_modules to release stage - missing deps cause runtime failures
