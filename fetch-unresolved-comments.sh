#!/bin/bash
# Fetch unresolved PR review comments using GitHub GraphQL API

set -euo pipefail

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed" >&2
    exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed (brew install jq)" >&2
    exit 1
fi

# Usage
if [ $# -eq 0 ]; then
    echo "Usage: $0 <pr_url>" >&2
    echo "Example: $0 https://github.com/owner/repo/pull/123" >&2
    exit 1
fi

PR_URL="$1"

# Parse PR URL to extract owner, repo, and number
if [[ "$PR_URL" =~ github\.com/([^/]+)/([^/]+)/pull/([0-9]+) ]]; then
    OWNER="${BASH_REMATCH[1]}"
    REPO="${BASH_REMATCH[2]}"
    PR_NUMBER="${BASH_REMATCH[3]}"
else
    echo "Error: Invalid PR URL format. Expected: https://github.com/owner/repo/pull/123" >&2
    exit 1
fi

# GraphQL query to fetch unresolved review threads
GRAPHQL_QUERY=$(cat <<'EOF'
query($owner: String!, $repo: String!, $number: Int!) {
  repository(owner: $owner, name: $repo) {
    pullRequest(number: $number) {
      reviewThreads(first: 100) {
        nodes {
          id
          isResolved
          path
          line
          startLine
          diffHunk
          comments(first: 50) {
            nodes {
              id
              databaseId
              body
              author {
                login
              }
              createdAt
            }
          }
        }
      }
    }
  }
}
EOF
)

# Execute GraphQL query
RESULT=$(gh api graphql \
    -f query="$GRAPHQL_QUERY" \
    -F owner="$OWNER" \
    -F repo="$REPO" \
    -F number="$PR_NUMBER" 2>&1)

# Check for API errors
if [ $? -ne 0 ]; then
    echo "Error: Failed to fetch PR data from GitHub API" >&2
    echo "$RESULT" >&2
    exit 1
fi

# Process the results and format output
echo "$RESULT" | jq -r '
  .data.repository.pullRequest.reviewThreads.nodes
  | map(select(.isResolved == false))
  | group_by(.path)
  | map({
      file: .[0].path,
      threads: map({
        thread_id: .id,
        line: .line,
        startLine: .startLine,
        diffHunk: .diffHunk,
        comments: .comments.nodes | map({
          id: .databaseId,
          body: .body,
          author: .author.login,
          createdAt: .createdAt
        })
      })
    })
  | {
      total: (map(.threads | length) | add // 0),
      by_file: (map({(.file): .threads}) | add // {})
    }
'
