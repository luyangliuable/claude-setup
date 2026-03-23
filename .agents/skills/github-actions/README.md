# GitHub Actions Skill

A collection of GitHub Actions examples from official documentation, optimized for Claude Code.

## Overview

This skill provides real-world GitHub Actions examples covering:
- Workflow configuration
- Language setup (Node.js, Swift, Go)
- Build and test automation
- Deployment and Helm operations
- Kubernetes integration
- Self-hosted runners

## Structure

```
github-actions/
├── SKILL.md              # Main skill entry point with metadata
├── README.md             # This file
└── examples/             # Individual example files
    ├── workflow-basics-*.md
    ├── deployment-*.md
    ├── setup-actions-*.md
    └── general-*.md
```

## Usage

The skill is automatically available to Claude Code via the `Skill("github-actions")` tool.

Examples are organized by category:
- **workflow-basics**: Core workflow patterns and configurations
- **deployment**: Deployment-related examples (Helm, Kubernetes)
- **setup-actions**: Environment setup for various languages
- **general**: Miscellaneous examples and outputs

## Adding More Examples

To add more examples from Context7:

1. Download additional content:
   ```bash
   curl -o ~/github-action.txt "https://context7.com/websites/github_en_actions/llms.txt?tokens=50000"
   ```

2. Run the processing script:
   ```bash
   python3 ~/scripts/process-github-actions-docs.py
   ```

The script will:
- Parse examples separated by `--------------------------------` delimiter
- Extract title, source URL, description, and code blocks
- Categorize examples automatically
- Generate individual markdown files
- Update the main SKILL.md with the new examples

## Example Format

Each example file contains:
- **Title**: Descriptive name from documentation
- **Category**: Auto-categorized based on keywords
- **Source**: Link to official GitHub documentation
- **Description**: Explanation of what the example does
- **Example Code**: YAML or text code snippets

## Categories

Examples are automatically categorized based on keywords:
- `workflow-basics`: workflow, trigger, event
- `job-configuration`: job, runs-on, steps
- `service-containers`: service, container, postgres, redis
- `docker-actions`: docker, dockerfile, image
- `matrix-strategy`: matrix, strategy
- `caching`: cache, restore, save
- `deployment`: deploy, release, publish, helm
- `authentication`: oidc, auth, token, credential
- `artifacts`: artifact, upload, download
- `environments`: environment, env
- `secrets`: secret, encrypted
- `reusable-workflows`: reusable, workflow_call
- `setup-actions`: setup, install, node, python, go, swift
- `build-test`: build, test, compile

## Current Statistics

- Total examples: 6
- Categories: 3 (workflow-basics, deployment, general)

## Source

Examples are sourced from:
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- Context7 curated collection: https://context7.com/websites/github_en_actions/llms.txt

## Processing Script

The processing script is located at: `~/scripts/process-github-actions-docs.py`

Key features:
- Parses delimiter-separated examples
- Extracts structured metadata
- Auto-categorizes content
- Generates clean markdown files
- Handles multiple code blocks per example
- Creates sequential numbered filenames
