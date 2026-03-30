# Pipeline Monitoring

**MANDATORY: After every push, monitor GitHub Actions pipelines**

## Two Approaches

### Simple Sequential Monitoring
**Use when:** Single workflow or straightforward monitoring needs

**Location:** `promptbank/workflow/pipeline-monitoring.txt`

**Pattern:**
- Push code changes
- List recent runs: `gh run list --limit 5`
- Watch in real-time: `gh run watch`
- On failure: investigate, fix, push, repeat
- Continue until all pipelines pass

### Parallel Pipeline Monitoring (Enhanced)
**Use when:** Multiple workflows run simultaneously (build, test, lint, security)

**Location:** `promptbank/workflow/parallel-pipeline-monitoring.txt`

**Pattern:**
- Push code changes
- List all running workflows: `gh run list --limit 10 --json status,name,databaseId,workflowName`
- Spawn one Agent tool per workflow with `run_in_background: true`
- Each agent monitors assigned workflow: `gh run watch <run_id>`
- Immediate failure detection: when ANY agent detects failure
  - Stop all other monitoring agents (TaskStop)
  - Investigate failure logs: `gh run view <run_id> --log`
  - Fix issue and push
  - Restart monitoring process
- Success when ALL agents report success

## Benefits of Parallel Approach

- **Faster feedback:** Detect failures immediately, not sequentially
- **Time savings:** Monitor 3+ pipelines simultaneously (saves ~10 min vs sequential)
- **Better visibility:** See all pipeline statuses at once
- **Proactive:** Stop and fix first failure, don't wait for all to complete

## Failure Handling Protocol

1. When any pipeline fails:
   - STOP all monitoring immediately
   - Get full logs: `gh run view <run_id> --log`
   - Analyze root cause
   - Apply fix
   - Push changes
   - Restart monitoring from scratch

2. Never complete task with failing pipelines

## Agent Coordination (Parallel Mode)

- Each agent is independent and monitors single workflow
- Agents run concurrently in background
- Main process coordinates agents and detects failures
- On failure: main process stops all agents via TaskStop
- On success: all agents complete and report success

## References

- Simple monitoring: `promptbank/workflow/pipeline-monitoring.txt`
- Parallel monitoring: `promptbank/workflow/parallel-pipeline-monitoring.txt`
