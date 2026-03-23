# Setup Node.js Action with Version Configuration

**Category**: workflow-basics
**Source**: https://docs.github.com/en/actions/tutorials/creating-an-example-workflow

## Description

GitHub Actions step that uses the 'actions/setup-node@v4' action to install Node.js version 20 on the runner. This action configures both the 'node' and 'npm' commands in the PATH environment variable, making them available for subsequent workflow steps.

## Example Code

```yaml
- uses: actions/setup-node@v4
  with:
    node-version: '20'
```
