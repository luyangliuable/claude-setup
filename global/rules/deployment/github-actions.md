# GitHub Actions

**MANDATORY:** Always use `runs-on: default` (NEVER ubuntu-latest)

**MANDATORY: After every push, monitor GitHub Actions pipelines**

- Use `gh run list` to check pipeline status
- Use `gh run watch` to monitor running pipelines
- Ensure ALL pipelines pass before finishing task
- If pipelines fail, fix issues and push again
- Never complete task with failing pipelines
