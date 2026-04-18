#!/bin/bash
# claude-functions.sh - Utility functions for Claude Code setup
# Source this file in your .zshrc: source ~/claude-setup/claude-functions.sh

# list_models() - Query API endpoint for available models
# Args: <endpoint_url> <api_key> [auth_type]
# Auth types: "bearer" (default) or "x-api-key"
# Silent on success, error message on failure
list_models() {
    # Input validation
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: list_models <endpoint_url> <api_key> [auth_type]" >&2
        echo "" >&2
        echo "Arguments:" >&2
        echo "  endpoint_url  API base URL (e.g., https://api.openai.com)" >&2
        echo "  api_key       API key for authentication" >&2
        echo "  auth_type     'bearer' (default) or 'x-api-key'" >&2
        return 1
    fi

    local endpoint_url="$1"
    local api_key="$2"
    local auth_type="${3:-bearer}"

    # Remove trailing slash from endpoint
    endpoint_url="${endpoint_url%/}"

    # Construct models URL
    local models_url="${endpoint_url}/v1/models"

    # Make curl request with appropriate auth header
    local response
    if [ "$auth_type" = "x-api-key" ]; then
        response=$(curl -s "$models_url" \
            -H "x-api-key: $api_key" \
            -H "Content-Type: application/json" 2>/dev/null)
    else
        response=$(curl -s "$models_url" \
            -H "Authorization: Bearer $api_key" \
            -H "Content-Type: application/json" 2>/dev/null)
    fi

    # Check for errors
    if [ $? -ne 0 ]; then
        echo "Error: Failed to connect to $models_url" >&2
        return 1
    fi

    if [ -z "$response" ]; then
        echo "Error: Empty response from API" >&2
        return 1
    fi

    # Check for API errors
    if echo "$response" | grep -q '"error"'; then
        echo "Error: API returned error" >&2
        echo "$response" | jq -r '.error.message // .error' 2>/dev/null || echo "$response"
        return 1
    fi

    # Format with jq if available, else raw JSON
    if command -v jq &> /dev/null; then
        echo "$response" | jq -r '.data[] | [.id, .owned_by // "unknown", (.created // 0 | todate)] | @tsv' | \
        awk 'BEGIN {
            printf "%-50s %-20s %-20s\n", "Model ID", "Owner", "Created";
            printf "%-50s %-20s %-20s\n", "--------", "-----", "-------";
        }
        {
            printf "%-50s %-20s %-20s\n", $1, $2, $3;
        }'
    else
        echo "$response"
        echo "" >&2
        echo "Tip: Install jq for formatted output (brew install jq)" >&2
    fi
}

# sync_skills() - Sync skills from .agents/skills/ to .claude/skills/
# Args: [--verbose]
# Default: silent (for .zshrc), --verbose for manual use
sync_skills() {
    local verbose=false

    # Parse --verbose flag
    if [[ "$1" == "--verbose" ]]; then
        verbose=true
    fi

    # Check if we're in the claude-setup directory or can find it
    local setup_dir="${HOME}/claude-setup"
    if [[ ! -d "$setup_dir/.agents/skills" ]]; then
        if $verbose; then
            echo "Error: Skills directory not found: $setup_dir/.agents/skills" >&2
        fi
        return 1
    fi

    # Ensure .claude/skills directory exists
    mkdir -p "$setup_dir/.claude/skills"

    local count=0

    # Loop through .agents/skills/*/
    for skill_dir in "$setup_dir/.agents/skills"/*; do
        if [ -d "$skill_dir" ]; then
            local skill_name=$(basename "$skill_dir")

            # Skip if no SKILL.md
            if [ ! -f "$skill_dir/SKILL.md" ]; then
                if $verbose; then
                    echo "⚠ Skipping $skill_name (no SKILL.md found)"
                fi
                continue
            fi

            # Remove existing symlink/directory
            if [ -e "$setup_dir/.claude/skills/$skill_name" ]; then
                rm -rf "$setup_dir/.claude/skills/$skill_name"
            fi

            # Create new symlink
            (cd "$setup_dir/.claude/skills" && ln -sf "../../.agents/skills/$skill_name" "$skill_name")

            # Output only if --verbose
            if $verbose; then
                echo "→ $skill_name"
            fi

            ((count++))
        fi
    done

    # Only show summary in verbose mode
    if $verbose; then
        echo ""
        echo "✅ Synced $count skills successfully!"
    fi

    return 0
}

# claude_tokens() - Display token usage for current/recent Claude session
# Can be called anytime during or after a session
# Usage: claude_tokens or ct (alias)
claude_tokens() {
    ~/claude-setup/scripts/print-token-usage.sh "$@"
}

# Short alias for quick access
alias ct='claude_tokens'
