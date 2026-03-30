# Claude Promptbank

Quick access to common patterns and templates for Claude Code workflows.

## Installation

The `pb` command is automatically available after running `install.sh`. To use it manually:

```bash
# Make executable
chmod +x ~/claude-setup/claude-promptbank.sh

# Add to PATH (optional - or use full path)
alias pb='~/claude-setup/claude-promptbank.sh'
```

## Usage

### Interactive Mode (Easy!)

```bash
pb                   # Shows numbered selection menu
# 1. git/commit-message
# 2. git/pr-description
# ...
# Enter number: 1
# ✓ Copied 'git/commit-message' to clipboard
```

### Direct Commands

```bash
pb list              # List all available prompts
pb show <name>       # Display prompt content
pb copy <name>       # Copy prompt to clipboard (pbcopy)
pb edit <name>       # Open prompt in $EDITOR
```

## Available Prompts

### Git Workflows

- **git/commit-message** - Template for single-line commit messages
- **git/pr-description** - Template for pull request descriptions
- **git/branch-workflow** - Common git branch commands

### Testing

- **testing/test-boilerplate** - Vitest test structure with Arrange/Act/Assert pattern
- **testing/coverage-request** - Commands for running tests with coverage
- **testing/pre-push-checklist** - Pre-push verification checklist for all languages
- **testing/meaningful-unit-tests** - Standards for writing meaningful unit tests (no trivial/duplicate tests, positive/negative coverage)

### Code Review

- **code-review/review-checklist** - Comprehensive PR review checklist
- **code-review/lgtm-template** - Template for approval comments
- **code-review/nitpick-template** - Template for minor suggestions
- **code-review/resolve-pr-comments** - Systematic workflow for resolving PR review comments
- **code-review/auto-resolve-pr-comments-loop** - Continuous monitoring system that auto-detects and fixes PR comments with /loop
- **code-review/autonomous-pr-comment-resolution** - FULLY AUTONOMOUS system with ZERO human in loop (auto-fetch, auto-spawn N agents, auto-fix, auto-verify, auto-reply, auto-resolve)

### Debugging

- **debugging/error-analysis** - Template for bug reports
- **debugging/rca-template** - Root cause analysis template
- **debugging/common-commands** - Common debugging commands

### Workflow & Quality

- **workflow/clean-solution** - Ensure clean, robust, and simple solutions
- **workflow/thorough-exploration** - Explore codebase thoroughly before changes
- **workflow/concise-plan** - Guidelines for concise plan creation
- **workflow/pipeline-monitoring** - Monitor GitHub Actions until all pass (simple sequential)
- **workflow/parallel-pipeline-monitoring** - Monitor multiple GitHub Actions pipelines in parallel for faster feedback
- **workflow/use-skills** - Invoke appropriate agent skills for tasks

## Examples

### Interactive Mode (Easiest)

```bash
# Just type pb - no need to remember paths!
pb
# Shows numbered list, select by number
```

### Direct Commands

```bash
# Copy commit message template to clipboard
pb copy git/commit-message

# View test boilerplate
pb show testing/test-boilerplate

# Copy workflow quality prompt
pb copy workflow/clean-solution

# Edit PR description template
pb edit git/pr-description

# List all prompts
pb list
```

## Adding Custom Prompts

Create a new `.txt` file in the appropriate category directory:

```bash
nano ~/claude-setup/promptbank/git/my-custom-prompt.txt
```

The prompt will be immediately available via:

```bash
pb copy git/my-custom-prompt
```

## Directory Structure

```
promptbank/
├── git/
│   ├── commit-message.txt
│   ├── pr-description.txt
│   └── branch-workflow.txt
├── testing/
│   ├── test-boilerplate.txt
│   ├── coverage-request.txt
│   └── pre-push-checklist.txt
├── code-review/
│   ├── review-checklist.txt
│   ├── lgtm-template.txt
│   ├── nitpick-template.txt
│   ├── resolve-pr-comments.txt
│   ├── auto-resolve-pr-comments-loop.txt
│   └── autonomous-pr-comment-resolution.txt
├── debugging/
│   ├── error-analysis.txt
│   ├── rca-template.txt
│   └── common-commands.txt
└── workflow/
    ├── clean-solution.txt
    ├── thorough-exploration.txt
    ├── concise-plan.txt
    ├── pipeline-monitoring.txt
    ├── parallel-pipeline-monitoring.txt
    └── use-skills.txt
```

## Tips

- All prompts are plain text for easy clipboard integration
- Use `pb copy` to quickly paste templates into commit messages, PRs, or issues
- Customize templates by editing the `.txt` files directly
- Add project-specific prompts in your own category directories
