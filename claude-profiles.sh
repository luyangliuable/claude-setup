#!/bin/bash
# claude-profiles.sh
# Extensible profile management system for Claude Code
# Source this file in your .zshrc: source ~/claude-setup/claude-profiles.sh

# Configuration
export CLAUDE_PROFILES_DIR="${HOME}/claude-setup/profiles"
export CLAUDE_SYSTEM_PROMPT='After pushing code, ALWAYS monitor GitHub Actions pipelines until they pass. Use gh run list to check status and gh run watch to monitor. If pipelines fail, fix and push again. Create feature branches with Jira ticket ID prefix (e.g., PROJ-123-feature-name). Use appropriate Skills() when consolidating plans and writing code.'
export CLAUDE_LOOP_DEFAULT_TASK='Monitor the current PR using gh pr view. Run npm build, test, lint and format. Fix any failures and push. Use the code-quality skill when fixing code. Iterate until all checks pass.'

# macOS-compatible timeout function using perl
_run_with_timeout() {
    local timeout_sec=$1
    shift
    perl -e 'alarm shift; exec @ARGV' "$timeout_sec" "$@"
}

# Core profile execution function
# Usage: _claude_profile_exec <profile_name> [args...]
_claude_profile_exec() {
    local profile_name=$1
    shift
    local profile_file="${CLAUDE_PROFILES_DIR}/${profile_name}.json"

    if [[ ! -f "$profile_file" ]]; then
        echo "Error: Profile '${profile_name}' not found at ${profile_file}"
        return 1
    fi

    # Parse model flags (-h for Haiku, -c/-g for other models)
    local model_flag=""
    if [[ "$1" == "-h" ]]; then
        model_flag='--model "claude-3-5-haiku-20241022"'
        shift
    elif [[ "$1" == "-c" ]]; then
        model_flag='--model "claude-4-5-sonnet"'
        shift
    elif [[ "$1" == "-g" ]]; then
        model_flag='--model "gpt-5.2_v2025-12-11_EASTUS2"'
        shift
    fi

    # Check if profile requires auth token override (e.g., GenAI Studio)
    local auth_override=""
    if grep -q "api.studio.genai.cba" "$profile_file" 2>/dev/null; then
        auth_override="ANTHROPIC_AUTH_TOKEN=\"\$OPENAI_API_KEY\" "
    fi

    # Execute Claude with profile settings
    eval "${auth_override}claude --dangerously-skip-permissions $model_flag \\
        --settings \"$profile_file\" \\
        --append-system-prompt \"\$CLAUDE_SYSTEM_PROMPT\" \"\$@\""
}

# Loop execution function for continuous tasks
# Usage: _claude_loop_exec <profile_name> [timeout_minutes] ["task description"]
_claude_loop_exec() {
    local profile_name=$1
    shift
    local timeout_min="${1:-1}"
    local task="${2:-$CLAUDE_LOOP_DEFAULT_TASK}"
    local timeout_sec=$((timeout_min * 60))
    local profile_file="${CLAUDE_PROFILES_DIR}/${profile_name}.json"

    if [[ ! -f "$profile_file" ]]; then
        echo "Error: Profile '${profile_name}' not found at ${profile_file}"
        return 1
    fi

    echo "Starting loop with ${profile_name} profile, ${timeout_min} minute timeout..."

    # Check if profile requires auth token override
    local auth_override=""
    if grep -q "api.studio.genai.cba" "$profile_file" 2>/dev/null; then
        auth_override="ANTHROPIC_AUTH_TOKEN=\"\$OPENAI_API_KEY\" "
    fi

    while true; do
        (
            eval "${auth_override}_run_with_timeout $timeout_sec claude --dangerously-skip-permissions \\
                --settings \"$profile_file\" \\
                --append-system-prompt \"\$CLAUDE_SYSTEM_PROMPT\" \\
                \"Your PID is \$\$. $task When fully complete, kill this session by running: kill \$\$\""
        )
        echo "Task complete, restarting in 2 seconds..."
        sleep 2
    done
}

# Load all profiles and create commands dynamically
_claude_load_profiles() {
    if [[ ! -d "$CLAUDE_PROFILES_DIR" ]]; then
        echo "Warning: Profiles directory not found: $CLAUDE_PROFILES_DIR"
        return 1
    fi

    # Create default 'c' command (uses current env settings)
    alias c="claude --dangerously-skip-permissions --append-system-prompt \"\$CLAUDE_SYSTEM_PROMPT\""

    # Create default 'lc' loop command
    lc() {
        local timeout_min="${1:-1}"
        local task="${2:-$CLAUDE_LOOP_DEFAULT_TASK}"
        local timeout_sec=$((timeout_min * 60))
        echo "Starting lc with ${timeout_min} minute timeout..."
        while true; do
            (
                _run_with_timeout $timeout_sec claude --dangerously-skip-permissions \
                    --append-system-prompt "$CLAUDE_SYSTEM_PROMPT" \
                    "Your PID is $$. $task When fully complete, kill this session by running: kill $$"
            )
            echo "Task complete, restarting in 2 seconds..."
            sleep 2
        done
    }

    # Auto-discover profiles and create commands
    for profile_file in "$CLAUDE_PROFILES_DIR"/*.json; do
        # Skip template and local profiles
        if [[ "$profile_file" == *"template.json" ]] || [[ "$profile_file" == *"local.json" ]]; then
            continue
        fi

        if [[ ! -f "$profile_file" ]]; then
            continue
        fi

        local profile_name=$(basename "$profile_file" .json)

        # Generate short command name (first 2 chars after 'c')
        # e.g., genai-studio -> cgs, dhp-opus -> cdh, my-custom -> cmy
        local short_name=$(echo "$profile_name" | sed 's/-//g' | cut -c1-2)
        local cmd_name="c${short_name}"
        local loop_cmd_name="l${cmd_name}"

        # Create profile command
        eval "${cmd_name}() { _claude_profile_exec '$profile_name' \"\$@\"; }"

        # Create loop variant
        eval "${loop_cmd_name}() { _claude_loop_exec '$profile_name' \"\$@\"; }"
    done
}

# Profile management helper
claude-profile() {
    local action=$1
    shift

    case "$action" in
        list|ls)
            echo "Available Claude profiles:"
            echo ""
            for profile_file in "$CLAUDE_PROFILES_DIR"/*.json; do
                if [[ -f "$profile_file" ]] && [[ "$profile_file" != *"template.json" ]]; then
                    local name=$(basename "$profile_file" .json)
                    local short=$(echo "$name" | sed 's/-//g' | cut -c1-2)
                    local base_url=$(jq -r '.env.ANTHROPIC_BASE_URL // "default"' "$profile_file" 2>/dev/null)
                    local model=$(jq -r '.env.ANTHROPIC_MODEL // "default"' "$profile_file" 2>/dev/null)
                    echo "  - $name (c${short}, lc${short})"
                    echo "      API: $base_url"
                    echo "      Model: $model"
                fi
            done
            ;;

        add)
            local name=$1
            if [[ -z "$name" ]]; then
                echo "Usage: claude-profile add <profile-name>"
                return 1
            fi

            local profile_file="${CLAUDE_PROFILES_DIR}/${name}.json"
            if [[ -f "$profile_file" ]]; then
                echo "Error: Profile '${name}' already exists"
                return 1
            fi

            # Copy template
            if [[ -f "${CLAUDE_PROFILES_DIR}/template.json" ]]; then
                cp "${CLAUDE_PROFILES_DIR}/template.json" "$profile_file"
                echo "Created profile: ${name}"
                echo "Edit it with: claude-profile edit ${name}"

                # Reload profiles
                _claude_load_profiles
            else
                echo "Error: Template not found"
                return 1
            fi
            ;;

        edit)
            local name=$1
            if [[ -z "$name" ]]; then
                echo "Usage: claude-profile edit <profile-name>"
                return 1
            fi

            local profile_file="${CLAUDE_PROFILES_DIR}/${name}.json"
            if [[ ! -f "$profile_file" ]]; then
                echo "Error: Profile '${name}' not found"
                return 1
            fi

            ${EDITOR:-nano} "$profile_file"

            # Reload profiles after editing
            _claude_load_profiles
            ;;

        remove|rm)
            local name=$1
            if [[ -z "$name" ]]; then
                echo "Usage: claude-profile remove <profile-name>"
                return 1
            fi

            local profile_file="${CLAUDE_PROFILES_DIR}/${name}.json"
            if [[ ! -f "$profile_file" ]]; then
                echo "Error: Profile '${name}' not found"
                return 1
            fi

            echo "Remove profile '${name}'? (y/N): "
            read -r confirm
            if [[ "$confirm" == "y" ]] || [[ "$confirm" == "Y" ]]; then
                rm "$profile_file"
                echo "Removed profile: ${name}"

                # Reload profiles
                _claude_load_profiles
            fi
            ;;

        reload)
            echo "Reloading profiles..."
            _claude_load_profiles
            echo "Profiles reloaded"
            ;;

        *)
            echo "Usage: claude-profile <command> [args]"
            echo ""
            echo "Commands:"
            echo "  list, ls              List available profiles"
            echo "  add <name>            Create a new profile from template"
            echo "  edit <name>           Edit an existing profile"
            echo "  remove, rm <name>     Remove a profile"
            echo "  reload                Reload all profiles"
            echo ""
            echo "Examples:"
            echo "  claude-profile list"
            echo "  claude-profile add my-custom"
            echo "  claude-profile edit genai-studio"
            ;;
    esac
}

# Initialize: Load all profiles on startup
_claude_load_profiles
