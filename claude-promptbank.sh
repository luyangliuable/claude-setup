#!/usr/bin/env bash
# Claude Promptbank CLI - Quick access to common patterns

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPTBANK_DIR="$SCRIPT_DIR/promptbank"

show_usage() {
    cat << EOF
Claude Promptbank - Quick access to common patterns

Usage: pb [command] [args]

Commands:
  (no args)         Interactive selection menu (numbered list)
  list              List all available prompts
  show <name>       Display prompt content
  copy <name>       Copy prompt to clipboard (pbcopy)
  edit <name>       Open prompt in \$EDITOR

Examples:
  pb                                    # Interactive menu
  pb list
  pb show git/commit-message
  pb copy testing/test-boilerplate
  pb edit code-review/lgtm-template

Categories:
  git/              Git workflows (commit-message, pr-description, branch-workflow)
  testing/          Test patterns (test-boilerplate, coverage-request, pre-push-checklist)
  code-review/      Review templates (review-checklist, lgtm-template, nitpick-template)
  debugging/        Debug helpers (error-analysis, rca-template, common-commands)
  workflow/         Quality prompts (clean-solution, thorough-exploration, concise-plan, pipeline-monitoring, use-skills)
EOF
}

list_prompts() {
    echo "Available prompts:"
    echo ""
    find "$PROMPTBANK_DIR" -type f -name "*.txt" | while read -r file; do
        rel_path="${file#$PROMPTBANK_DIR/}"
        rel_path="${rel_path%.txt}"
        echo "  $rel_path"
    done
}

show_prompt() {
    local prompt_path="$PROMPTBANK_DIR/$1.txt"

    if [ ! -f "$prompt_path" ]; then
        echo "Error: Prompt '$1' not found"
        echo "Run 'pb list' to see available prompts"
        exit 1
    fi

    cat "$prompt_path"
}

copy_prompt() {
    local prompt_path="$PROMPTBANK_DIR/$1.txt"

    if [ ! -f "$prompt_path" ]; then
        echo "Error: Prompt '$1' not found"
        echo "Run 'pb list' to see available prompts"
        exit 1
    fi

    cat "$prompt_path" | pbcopy
    echo "✓ Copied '$1' to clipboard"
}

edit_prompt() {
    local prompt_path="$PROMPTBANK_DIR/$1.txt"

    if [ ! -f "$prompt_path" ]; then
        echo "Error: Prompt '$1' not found"
        echo "Run 'pb list' to see available prompts"
        exit 1
    fi

    ${EDITOR:-vim} "$prompt_path"
}

interactive_select() {
    echo "Claude Promptbank - Select a prompt:"
    echo ""

    # Build array of prompts
    local prompts=()
    while IFS= read -r file; do
        rel_path="${file#$PROMPTBANK_DIR/}"
        rel_path="${rel_path%.txt}"
        prompts+=("$rel_path")
    done < <(find "$PROMPTBANK_DIR" -type f -name "*.txt" | sort)

    # Display numbered list
    local i=1
    for prompt in "${prompts[@]}"; do
        printf "%2d. %s\n" "$i" "$prompt"
        ((i++))
    done

    echo ""
    read -p "Enter number (or 'q' to quit): " selection

    if [[ "$selection" == "q" ]]; then
        exit 0
    fi

    if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le "${#prompts[@]}" ]; then
        local selected="${prompts[$((selection-1))]}"
        cat "$PROMPTBANK_DIR/$selected.txt" | pbcopy
        echo "✓ Copied '$selected' to clipboard"
    else
        echo "Error: Invalid selection"
        exit 1
    fi
}

# Main command dispatcher
case "${1:-}" in
    "")
        interactive_select
        ;;
    list)
        list_prompts
        ;;
    show)
        if [ -z "${2:-}" ]; then
            echo "Error: Missing prompt name"
            echo "Usage: pb show <name>"
            exit 1
        fi
        show_prompt "$2"
        ;;
    copy)
        if [ -z "${2:-}" ]; then
            echo "Error: Missing prompt name"
            echo "Usage: pb copy <name>"
            exit 1
        fi
        copy_prompt "$2"
        ;;
    edit)
        if [ -z "${2:-}" ]; then
            echo "Error: Missing prompt name"
            echo "Usage: pb edit <name>"
            exit 1
        fi
        edit_prompt "$2"
        ;;
    -h|--help|help)
        show_usage
        ;;
    *)
        echo "Error: Unknown command '$1'"
        echo ""
        show_usage
        exit 1
        ;;
esac
