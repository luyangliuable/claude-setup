#!/bin/bash
# claude-toggle.sh - Session-only toggle system for rules and skills
# Usage: claude-toggle <command> [args]

# Environment
export CLAUDE_RULES_SOURCE="${HOME}/claude-setup/global/rules"
export CLAUDE_RULES_TARGET="${HOME}/.claude/rules/global"
export CLAUDE_SKILLS_SOURCE="${HOME}/claude-setup/.agents/skills"
export CLAUDE_SKILLS_TARGET="${HOME}/.claude/skills"

# State tracking (session-only via environment variables)
# Format: CLAUDE_TOGGLE_DISABLED_RULES_<PROFILE>="path1 path2 ..."
# Format: CLAUDE_TOGGLE_DISABLED_SKILLS_<PROFILE>="skill1 skill2 ..."

declare -g CLAUDE_TOGGLE_CURRENT_PROFILE=""

# Detect current profile from environment or command history
_claude_toggle_detect_profile() {
    # Check if explicitly set
    if [[ -n "$CLAUDE_TOGGLE_CURRENT_PROFILE" ]]; then
        echo "$CLAUDE_TOGGLE_CURRENT_PROFILE"
        return
    fi

    # Try to detect from shell history (last 5 commands)
    # fc may fail in non-interactive shells or when history is empty
    local recent_cmds
    if recent_cmds=$(fc -ln -5 2>/dev/null); then
        # History available - try to detect profile
        if echo "$recent_cmds" | grep -q "^[[:space:]]*cpa"; then
            echo "CPA"
            return
        elif echo "$recent_cmds" | grep -q "^[[:space:]]*cpb"; then
            echo "CPB"
            return
        elif echo "$recent_cmds" | grep -q "^[[:space:]]*cmy"; then
            echo "CMY"
            return
        fi
    fi

    # Default profile if fc fails or no profile detected
    echo "DEFAULT"
}

# Initialize rules directory: convert directory symlink to file symlinks
_claude_toggle_init_rules() {
    # Check if already initialized (contains regular files/links, not a directory symlink)
    if [[ ! -L "$CLAUDE_RULES_TARGET" ]]; then
        # Already initialized or is a real directory
        return 0
    fi

    echo "Converting rules directory to file symlinks..."

    # Remove directory symlink
    rm "$CLAUDE_RULES_TARGET"

    # Create target directory
    mkdir -p "$CLAUDE_RULES_TARGET"

    # Create symlinks for all rule files
    (
        cd "$CLAUDE_RULES_SOURCE" || return 1
        find . -type f -name "*.md" | while IFS= read -r file; do
            local rel_path="${file#./}"
            local dir=$(dirname "$rel_path")
            local target_dir="$CLAUDE_RULES_TARGET/$dir"

            mkdir -p "$target_dir"
            ln -sf "$CLAUDE_RULES_SOURCE/$rel_path" "$CLAUDE_RULES_TARGET/$rel_path"
        done
    )

    echo "Rules directory initialized ($(find "$CLAUDE_RULES_TARGET" -type l | wc -l | xargs) symlinks created)"
}

# First-time initialization: convert to file symlinks and disable everything
_claude_toggle_first_time_init() {
    # Convert directory symlink to file symlinks (if needed)
    _claude_toggle_init_rules >/dev/null 2>&1

    # Disable everything
    _claude_toggle_disable_all_rules >/dev/null 2>&1

    # Create marker file
    touch "$HOME/.claude/.toggle-initialized"

    # Show message (only in interactive shells)
    if [[ -t 0 ]]; then
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "  Claude Toggle Initialized"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "  All skills and rules are DISABLED by default."
        echo ""
        echo "  To enable skills/rules:"
        echo "    claude-toggle ui       # Interactive selection"
        echo "    claude-toggle list     # View current state"
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
    fi
}

# Get state variable name for current profile
# Optional parameter: profile (if not provided, will detect)
_claude_toggle_get_rules_var() {
    local profile="${1:-$(_claude_toggle_detect_profile)}"
    echo "CLAUDE_TOGGLE_DISABLED_RULES_${profile}"
}

_claude_toggle_get_skills_var() {
    local profile="${1:-$(_claude_toggle_detect_profile)}"
    echo "CLAUDE_TOGGLE_DISABLED_SKILLS_${profile}"
}

# Check if a rule is currently disabled
# Optional parameter: profile (if not provided, will detect)
_claude_toggle_is_rule_disabled() {
    local rule_path=$1
    local profile=$2

    # Check if symlink exists - if not, rule is disabled
    local target_file="$CLAUDE_RULES_TARGET/$rule_path"
    if [[ ! -e "$target_file" ]] && [[ ! -L "$target_file" ]]; then
        return 0  # Rule is disabled (symlink doesn't exist)
    fi

    # Symlink exists - rule is enabled
    return 1
}

# Check if a skill is currently disabled
# Optional parameter: profile (if not provided, will detect)
_claude_toggle_is_skill_disabled() {
    local skill_name=$1
    local profile=$2

    # Check if symlink exists - if not, skill is disabled
    local target_dir="$CLAUDE_SKILLS_TARGET/$skill_name"
    if [[ ! -e "$target_dir" ]] && [[ ! -L "$target_dir" ]]; then
        return 0  # Skill is disabled (symlink doesn't exist)
    fi

    # Symlink exists - skill is enabled
    return 1
}

# Disable a rule
_claude_toggle_disable_rule() {
    local rule_path=$1
    local profile=$(_claude_toggle_detect_profile)
    local var_name=$(_claude_toggle_get_rules_var)

    # Validate rule path (no leading /)
    if [[ "$rule_path" == /* ]]; then
        echo "Error: Rule path must be relative (e.g., core/working-philosophy.md)"
        return 1
    fi

    # Initialize rules directory if needed
    _claude_toggle_init_rules

    # Check if already disabled
    if _claude_toggle_is_rule_disabled "$rule_path"; then
        echo "Rule already disabled: $rule_path"
        return 0
    fi

    # Check if file exists
    local full_path="$CLAUDE_RULES_TARGET/$rule_path"
    if [[ ! -e "$full_path" ]] && [[ ! -L "$full_path" ]]; then
        echo "Error: Rule not found: $rule_path"
        echo "Available rules:"
        find "$CLAUDE_RULES_SOURCE" -type f -name "*.md" -exec bash -c 'echo "  ${1#'"$CLAUDE_RULES_SOURCE"'/}"' _ {} \; | head -10
        echo "  ... (use 'claude-toggle list' to see all)"
        return 1
    fi

    # Remove symlink
    rm "$full_path"

    # Store in environment variable
    local current_disabled=$(eval echo \$${var_name})
    if [[ -z "$current_disabled" ]]; then
        export "$var_name"="$rule_path"
    else
        export "$var_name"="$current_disabled $rule_path"
    fi

    echo "✓ Disabled rule: $rule_path (profile: $profile)"
}

# Enable a rule
_claude_toggle_enable_rule() {
    local rule_path=$1
    local profile=$(_claude_toggle_detect_profile)
    local var_name=$(_claude_toggle_get_rules_var)

    # Validate rule path
    if [[ "$rule_path" == /* ]]; then
        echo "Error: Rule path must be relative (e.g., core/working-philosophy.md)"
        return 1
    fi

    # Check if already enabled
    if ! _claude_toggle_is_rule_disabled "$rule_path"; then
        echo "Rule already enabled: $rule_path"
        return 0
    fi

    # Recreate symlink
    local source_file="$CLAUDE_RULES_SOURCE/$rule_path"
    local target_file="$CLAUDE_RULES_TARGET/$rule_path"

    if [[ ! -f "$source_file" ]]; then
        echo "Error: Source rule not found: $source_file"
        return 1
    fi

    mkdir -p "$(dirname "$target_file")"
    ln -sf "$source_file" "$target_file"

    # Remove from environment variable
    local current_disabled=$(eval echo \$${var_name})
    local new_disabled=$(echo "$current_disabled" | sed "s|$rule_path||g" | xargs)
    export "$var_name"="$new_disabled"

    echo "✓ Enabled rule: $rule_path (profile: $profile)"
}

# Disable a skill
_claude_toggle_disable_skill() {
    local skill_name=$1
    local profile=$(_claude_toggle_detect_profile)
    local var_name=$(_claude_toggle_get_skills_var)

    # Check if already disabled
    if _claude_toggle_is_skill_disabled "$skill_name"; then
        echo "Skill already disabled: $skill_name"
        return 0
    fi

    # Check if skill exists
    local skill_link="$CLAUDE_SKILLS_TARGET/$skill_name"
    if [[ ! -e "$skill_link" ]] && [[ ! -L "$skill_link" ]]; then
        echo "Error: Skill not found: $skill_name"
        echo "Available skills:"
        ls -1 "$CLAUDE_SKILLS_TARGET" | head -10
        echo "  ... (use 'claude-toggle list' to see all)"
        return 1
    fi

    # Remove symlink
    rm "$skill_link"

    # Store in environment variable
    local current_disabled=$(eval echo \$${var_name})
    if [[ -z "$current_disabled" ]]; then
        export "$var_name"="$skill_name"
    else
        export "$var_name"="$current_disabled $skill_name"
    fi

    echo "✓ Disabled skill: $skill_name (profile: $profile)"
}

# Enable a skill
_claude_toggle_enable_skill() {
    local skill_name=$1
    local profile=$(_claude_toggle_detect_profile)
    local var_name=$(_claude_toggle_get_skills_var)

    # Check if already enabled
    if ! _claude_toggle_is_skill_disabled "$skill_name"; then
        echo "Skill already enabled: $skill_name"
        return 0
    fi

    # Recreate symlink
    local source_dir="$CLAUDE_SKILLS_SOURCE/$skill_name"
    local target_link="$CLAUDE_SKILLS_TARGET/$skill_name"

    if [[ ! -d "$source_dir" ]]; then
        echo "Error: Source skill not found: $source_dir"
        return 1
    fi

    ln -sf "$source_dir" "$target_link"

    # Remove from environment variable
    local current_disabled=$(eval echo \$${var_name})
    local new_disabled=$(echo "$current_disabled" | sed "s|$skill_name||g" | xargs)
    export "$var_name"="$new_disabled"

    echo "✓ Enabled skill: $skill_name (profile: $profile)"
}

# List all rules and skills with status
_claude_toggle_list() {
    local profile=$(_claude_toggle_detect_profile)
    echo "Profile: $profile"
    echo ""

    # Initialize rules if needed
    _claude_toggle_init_rules

    # List rules
    echo "Rules:"
    local rule_count=0
    local disabled_count=0

    (
        cd "$CLAUDE_RULES_SOURCE" || return 1
        find . -type f -name "*.md" | sort | while IFS= read -r file; do
            local rel_path="${file#./}"
            rule_count=$((rule_count + 1))

            # Pass profile to avoid repeated detection (performance optimization)
            if _claude_toggle_is_rule_disabled "$rel_path" "$profile"; then
                echo "  [✗] $rel_path (disabled)"
                disabled_count=$((disabled_count + 1))
            else
                echo "  [✓] $rel_path"
            fi
        done
    )

    echo ""

    # List skills
    echo "Skills:"
    local skill_count=0
    local skill_disabled_count=0

    if [[ -d "$CLAUDE_SKILLS_SOURCE" ]]; then
        for skill_dir in "$CLAUDE_SKILLS_SOURCE"/*; do
            if [[ -d "$skill_dir" ]]; then
                local skill_name=$(basename "$skill_dir")
                skill_count=$((skill_count + 1))

                # Pass profile to avoid repeated detection (performance optimization)
                if _claude_toggle_is_skill_disabled "$skill_name" "$profile"; then
                    echo "  [✗] $skill_name (disabled)"
                    skill_disabled_count=$((skill_disabled_count + 1))
                else
                    echo "  [✓] $skill_name"
                fi
            fi
        done
    fi

    echo ""
    echo "Total: $(find "$CLAUDE_RULES_SOURCE" -type f -name "*.md" | wc -l | xargs) rules, $(ls -1 "$CLAUDE_SKILLS_SOURCE" | wc -l | xargs) skills"
}

# Show status for current profile
_claude_toggle_status() {
    local profile=$(_claude_toggle_detect_profile)

    echo "Profile: $profile"
    echo "Default Behavior: All rules and skills are DISABLED by default"
    echo ""

    # Check for enabled rules
    _claude_toggle_init_rules
    local has_enabled_rules=false
    echo "Enabled Rules:"
    (
        cd "$CLAUDE_RULES_SOURCE" || return 1
        find . -type f -name "*.md" | sort | while IFS= read -r file; do
            local rel_path="${file#./}"
            if ! _claude_toggle_is_rule_disabled "$rel_path" "$profile"; then
                echo "  ✓ $rel_path"
                has_enabled_rules=true
            fi
        done
        if [[ "$has_enabled_rules" == false ]]; then
            echo "  None"
        fi
    )
    echo ""

    # Check for enabled skills
    echo "Enabled Skills:"
    local has_enabled_skills=false
    if [[ -d "$CLAUDE_SKILLS_SOURCE" ]]; then
        for skill_dir in "$CLAUDE_SKILLS_SOURCE"/*; do
            if [[ -d "$skill_dir" ]]; then
                local skill_name=$(basename "$skill_dir")
                if ! _claude_toggle_is_skill_disabled "$skill_name" "$profile"; then
                    echo "  ✓ $skill_name"
                    has_enabled_skills=true
                fi
            fi
        done
    fi
    if [[ "$has_enabled_skills" == false ]]; then
        echo "  None"
    fi
    echo ""

    echo "Usage:"
    echo "  claude-toggle ui          # Interactive UI to enable rules/skills"
    echo "  claude-toggle enable rule <path>"
    echo "  claude-toggle enable skill <name>"
}

# Reset all toggles (re-enable everything)
_claude_toggle_reset() {
    local profile=$(_claude_toggle_detect_profile)

    echo "Resetting to default state (disabling all rules and skills) for profile: $profile"

    # Disable all rules (reset to default state)
    _claude_toggle_disable_all_rules

    # Disable all skills
    if [[ -d "$CLAUDE_SKILLS_SOURCE" ]]; then
        for skill_dir in "$CLAUDE_SKILLS_SOURCE"/*; do
            if [[ -d "$skill_dir" ]]; then
                local skill_name=$(basename "$skill_dir")
                _claude_toggle_disable_skill "$skill_name" >/dev/null
            fi
        done
    fi

    echo "✓ Reset complete - all rules and skills disabled"
    echo "Use 'claude-toggle ui' to enable the rules/skills you want"
}

# Disable all rules on session initialization
_claude_toggle_disable_all_rules() {
    # Ensure target directories exist
    mkdir -p "$CLAUDE_RULES_TARGET"
    mkdir -p "$CLAUDE_SKILLS_TARGET"

    # If it's a directory symlink, remove it and create real directory
    if [[ -L "$CLAUDE_RULES_TARGET" ]]; then
        rm "$CLAUDE_RULES_TARGET"
        mkdir -p "$CLAUDE_RULES_TARGET"

        # Create directory structure (empty)
        (
            cd "$CLAUDE_RULES_SOURCE" || return 1
            find . -type d | while IFS= read -r dir; do
                mkdir -p "$CLAUDE_RULES_TARGET/$dir"
            done
        )
    fi

    # Remove ALL .md files and symlinks (disable everything)
    find "$CLAUDE_RULES_TARGET" -type l -name "*.md" -delete 2>/dev/null
    find "$CLAUDE_RULES_TARGET" -type f -name "*.md" -delete 2>/dev/null

    # Remove all skill symlinks
    if [[ -d "$CLAUDE_SKILLS_TARGET" ]]; then
        find "$CLAUDE_SKILLS_TARGET" -type l -delete 2>/dev/null
    fi
}

# Interactive UI - Main entry point
_claude_toggle_ui() {
    if ! command -v fzf >/dev/null 2>&1; then
        echo "Error: fzf is required for interactive UI"
        echo "Install with: brew install fzf"
        return 1
    fi

    local choice=$(echo -e "Rules\nSkills\nExit" | fzf --prompt="Select category: " --height=10 --reverse)

    case "$choice" in
        "Rules")
            _claude_toggle_ui_rules_fzf
            ;;
        "Skills")
            _claude_toggle_ui_skills_fzf
            ;;
        "Exit"|"")
            return 0
            ;;
    esac
}

# FZF-based UI - Rules selection with multi-select
_claude_toggle_ui_rules_fzf() {
    local profile=$(_claude_toggle_detect_profile)
    _claude_toggle_init_rules

    # Get all rules with status markers
    local all_rules=()
    local marked_rules=()
    while IFS= read -r rule_path; do
        all_rules+=("$rule_path")
        if ! _claude_toggle_is_rule_disabled "$rule_path" "$profile"; then
            marked_rules+=("[✓] $rule_path")
        else
            marked_rules+=("[ ] $rule_path")
        fi
    done < <(cd "$CLAUDE_RULES_SOURCE" && find . -type f -name "*.md" | sed 's|^\./||' | sort)

    # Use fzf with multi-select showing current state
    local selected=$(printf '%s\n' "${marked_rules[@]}" | \
        FZF_DEFAULT_OPTS="--height=80% --reverse --multi --cycle \
            --prompt='Toggle rules (TAB to select/deselect, ENTER when done): ' \
            --header='[✓]=currently enabled [ ]=disabled | Select items to ENABLE' \
            --bind='tab:toggle+down'" \
        fzf --print-query | tail -n +2)

    # Apply changes
    echo ""
    echo "Applying changes in parallel..."
    echo ""

    local changes_made=false
    local temp_dir=$(mktemp -d)
    local enabled_log="$temp_dir/enabled.log"
    local disabled_log="$temp_dir/disabled.log"

    # Build array of selected rules (strip markers)
    local selected_array=()
    while IFS= read -r rule; do
        if [[ -n "$rule" ]]; then
            # Strip "[✓] " or "[ ] " prefix
            rule="${rule#\[✓\] }"
            rule="${rule#\[ \] }"
            selected_array+=("$rule")
        fi
    done <<< "$selected"

    # Disable job control to suppress background job messages
    set +m

    # Enable selected rules in parallel
    for rule in "${selected_array[@]}"; do
        if _claude_toggle_is_rule_disabled "$rule" "$profile"; then
            (
                _claude_toggle_enable_rule "$rule" "$profile" >/dev/null 2>&1 && \
                echo "  ✓ Enabled: $rule" >> "$enabled_log"
            ) &
        fi
    done

    # Disable unselected rules in parallel
    for rule in "${all_rules[@]}"; do
        local is_selected=false
        for selected_rule in "${selected_array[@]}"; do
            if [[ "$rule" == "$selected_rule" ]]; then
                is_selected=true
                break
            fi
        done

        if [[ $is_selected == false ]]; then
            if ! _claude_toggle_is_rule_disabled "$rule" "$profile"; then
                (
                    _claude_toggle_disable_rule "$rule" "$profile" >/dev/null 2>&1 && \
                    echo "  ✓ Disabled: $rule" >> "$disabled_log"
                ) &
            fi
        fi
    done

    # Wait for all background jobs
    wait

    # Re-enable job control
    set -m

    # Display results
    if [[ -f "$enabled_log" ]]; then
        cat "$enabled_log"
        changes_made=true
    fi
    if [[ -f "$disabled_log" ]]; then
        cat "$disabled_log"
        changes_made=true
    fi

    # Cleanup
    rm -rf "$temp_dir"

    if [[ $changes_made == false ]]; then
        echo "No changes made."
    else
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "  ⚠️  IMPORTANT: Restart Claude Code for changes to take effect"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "  Claude Code caches skills/rules at startup."
        echo "  To see your changes:"
        echo ""
        echo "    1. Exit Claude (Ctrl+D or /exit)"
        echo "    2. Start new session: cgs"
        echo ""
    fi

    echo ""
}

# FZF-based UI - Skills selection with multi-select
_claude_toggle_ui_skills_fzf() {
    local profile=$(_claude_toggle_detect_profile)

    # Get all skills with status markers
    local all_skills=()
    local marked_skills=()
    while IFS= read -r skill_dir; do
        local skill_name="$(basename "$skill_dir")"
        all_skills+=("$skill_name")
        if ! _claude_toggle_is_skill_disabled "$skill_name" "$profile"; then
            marked_skills+=("[✓] $skill_name")
        else
            marked_skills+=("[ ] $skill_name")
        fi
    done < <(find "$CLAUDE_SKILLS_SOURCE" -maxdepth 1 -type d -not -name "$(basename "$CLAUDE_SKILLS_SOURCE")" | sort)

    # Use fzf with multi-select showing current state
    local selected=$(printf '%s\n' "${marked_skills[@]}" | \
        FZF_DEFAULT_OPTS="--height=80% --reverse --multi --cycle \
            --prompt='Toggle skills (TAB to select/deselect, ENTER when done): ' \
            --header='[✓]=currently enabled [ ]=disabled | Select items to ENABLE' \
            --bind='tab:toggle+down'" \
        fzf --print-query | tail -n +2)

    # Apply changes
    echo ""
    echo "Applying changes in parallel..."
    echo ""

    local changes_made=false
    local temp_dir=$(mktemp -d)
    local enabled_log="$temp_dir/enabled.log"
    local disabled_log="$temp_dir/disabled.log"

    # Build array of selected skills (strip markers)
    local selected_array=()
    while IFS= read -r skill; do
        if [[ -n "$skill" ]]; then
            # Strip "[✓] " or "[ ] " prefix
            skill="${skill#\[✓\] }"
            skill="${skill#\[ \] }"
            selected_array+=("$skill")
        fi
    done <<< "$selected"

    # Disable job control to suppress background job messages
    set +m

    # Enable selected skills in parallel
    for skill in "${selected_array[@]}"; do
        if _claude_toggle_is_skill_disabled "$skill" "$profile"; then
            (
                _claude_toggle_enable_skill "$skill" "$profile" >/dev/null 2>&1 && \
                echo "  ✓ Enabled: $skill" >> "$enabled_log"
            ) &
        fi
    done

    # Disable unselected skills in parallel
    for skill in "${all_skills[@]}"; do
        local is_selected=false
        for selected_skill in "${selected_array[@]}"; do
            if [[ "$skill" == "$selected_skill" ]]; then
                is_selected=true
                break
            fi
        done

        if [[ $is_selected == false ]]; then
            if ! _claude_toggle_is_skill_disabled "$skill" "$profile"; then
                (
                    _claude_toggle_disable_skill "$skill" "$profile" >/dev/null 2>&1 && \
                    echo "  ✓ Disabled: $skill" >> "$disabled_log"
                ) &
            fi
        fi
    done

    # Wait for all background jobs
    wait

    # Re-enable job control
    set -m

    # Display results
    if [[ -f "$enabled_log" ]]; then
        cat "$enabled_log"
        changes_made=true
    fi
    if [[ -f "$disabled_log" ]]; then
        cat "$disabled_log"
        changes_made=true
    fi

    # Cleanup
    rm -rf "$temp_dir"

    if [[ $changes_made == false ]]; then
        echo "No changes made."
    else
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "  ⚠️  IMPORTANT: Restart Claude Code for changes to take effect"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "  Claude Code caches skills/rules at startup."
        echo "  To see your changes:"
        echo ""
        echo "    1. Exit Claude (Ctrl+D or /exit)"
        echo "    2. Start new session: cgs"
        echo ""
    fi

    echo ""
}

# Dialog-based UI - Category selection
_claude_toggle_ui_dialog() {
    local profile=$(_claude_toggle_detect_profile)
    echo "[DEBUG] Entering _claude_toggle_ui_dialog() with profile: $profile" >&2

    while true; do
        echo "[DEBUG] About to call dialog command..." >&2
        local category=$(dialog --title "Toggle System (Profile: $profile)" \
            --menu "Choose category:" 15 50 3 \
            1 "Rules" \
            2 "Skills" \
            3 "Exit" \
            3>&1 1>&2 2>&3)
        echo "[DEBUG] Dialog returned with category: $category" >&2

        local exit_code=$?
        clear

        if [ $exit_code -ne 0 ] || [ "$category" = "3" ]; then
            return 0
        fi

        case $category in
            1) _claude_toggle_ui_rules_dialog ;;
            2) _claude_toggle_ui_skills_dialog ;;
        esac
    done
}

# Dialog-based UI - Rules checkbox
_claude_toggle_ui_rules_dialog() {
    local profile=$(_claude_toggle_detect_profile)
    _claude_toggle_init_rules

    # Cache find results in array (runs once)
    local rule_list=()
    while IFS= read -r rule_path; do
        rule_list+=("$rule_path")
    done < <(cd "$CLAUDE_RULES_SOURCE" && find . -type f -name "*.md" | sed 's|^\./||' | sort)

    # Build checklist options from cached array (3 params per item: tag, item, status)
    local options=()
    for rule_path in "${rule_list[@]}"; do
        local status="off"
        # Pre-select currently enabled rules
        if ! _claude_toggle_is_rule_disabled "$rule_path" "$profile"; then
            status="on"
        fi
        options+=("$rule_path" "" "$status")
    done

    # Show checklist
    local selected=$(dialog --title "Toggle Rules (Profile: $profile)" \
        --checklist "Select rules to ENABLE (Space=toggle, Enter=apply):" \
        20 80 15 \
        "${options[@]}" \
        3>&1 1>&2 2>&3)

    local exit_code=$?
    clear

    if [ $exit_code -eq 0 ]; then
        echo "Applying changes in parallel..."

        # Parse selected items (space-separated, quoted strings)
        local selected_array=()
        eval "selected_array=($selected)"

        local changes_made=false
        local temp_dir=$(mktemp -d)
        local enabled_log="$temp_dir/enabled.log"
        local disabled_log="$temp_dir/disabled.log"

        # Enable selected rules in parallel
        for rule in "${selected_array[@]}"; do
            if _claude_toggle_is_rule_disabled "$rule" "$profile"; then
                (
                    _claude_toggle_enable_rule "$rule" >/dev/null 2>&1 && \
                    echo "  ✓ Enabled: $rule" >> "$enabled_log"
                ) &
            fi
        done

        # Disable unselected rules in parallel
        for rule in "${rule_list[@]}"; do
            local is_selected=false
            for sel in "${selected_array[@]}"; do
                if [[ "$rule" == "$sel" ]]; then
                    is_selected=true
                    break
                fi
            done

            if [[ "$is_selected" == false ]]; then
                if ! _claude_toggle_is_rule_disabled "$rule" "$profile"; then
                    (
                        _claude_toggle_disable_rule "$rule" >/dev/null 2>&1 && \
                        echo "  ✓ Disabled: $rule" >> "$disabled_log"
                    ) &
                fi
            fi
        done

        # Wait for all background jobs to complete
        wait

        # Display results
        if [[ -f "$enabled_log" ]]; then
            cat "$enabled_log"
            changes_made=true
        fi
        if [[ -f "$disabled_log" ]]; then
            cat "$disabled_log"
            changes_made=true
        fi

        # Cleanup
        rm -rf "$temp_dir"

        if [[ "$changes_made" == false ]]; then
            echo "No changes made."
        fi

        echo ""
    fi
}

# Dialog-based UI - Skills checkbox
_claude_toggle_ui_skills_dialog() {
    local profile=$(_claude_toggle_detect_profile)

    # Cache skill list in array
    local skill_list=()
    if [[ -d "$CLAUDE_SKILLS_SOURCE" ]]; then
        for skill_dir in "$CLAUDE_SKILLS_SOURCE"/*; do
            if [[ -d "$skill_dir" ]]; then
                skill_list+=("$(basename "$skill_dir")")
            fi
        done
    fi

    # Build checklist options from cached array
    local options=()
    for skill_name in "${skill_list[@]}"; do
        local status="off"
        # Pre-select currently enabled skills
        if ! _claude_toggle_is_skill_disabled "$skill_name" "$profile"; then
            status="on"
        fi
        options+=("$skill_name" "" "$status")
    done

    # Show checklist
    local selected=$(dialog --title "Toggle Skills (Profile: $profile)" \
        --checklist "Select skills to ENABLE (Space=toggle, Enter=apply):" \
        20 80 15 \
        "${options[@]}" \
        3>&1 1>&2 2>&3)

    local exit_code=$?
    clear

    if [ $exit_code -eq 0 ]; then
        echo "Applying changes in parallel..."

        # Parse selected items (space-separated, quoted strings)
        local selected_array=()
        eval "selected_array=($selected)"

        local changes_made=false
        local temp_dir=$(mktemp -d)
        local enabled_log="$temp_dir/enabled.log"
        local disabled_log="$temp_dir/disabled.log"

        # Enable selected skills in parallel
        for skill in "${selected_array[@]}"; do
            if _claude_toggle_is_skill_disabled "$skill" "$profile"; then
                (
                    _claude_toggle_enable_skill "$skill" >/dev/null 2>&1 && \
                    echo "  ✓ Enabled: $skill" >> "$enabled_log"
                ) &
            fi
        done

        # Disable unselected skills in parallel
        for skill in "${skill_list[@]}"; do
            local is_selected=false
            for sel in "${selected_array[@]}"; do
                if [[ "$skill" == "$sel" ]]; then
                    is_selected=true
                    break
                fi
            done

            if [[ "$is_selected" == false ]]; then
                if ! _claude_toggle_is_skill_disabled "$skill" "$profile"; then
                    (
                        _claude_toggle_disable_skill "$skill" >/dev/null 2>&1 && \
                        echo "  ✓ Disabled: $skill" >> "$disabled_log"
                    ) &
                fi
            fi
        done

        # Wait for all background jobs to complete
        wait

        # Display results
        if [[ -f "$enabled_log" ]]; then
            cat "$enabled_log"
            changes_made=true
        fi
        if [[ -f "$disabled_log" ]]; then
            cat "$disabled_log"
            changes_made=true
        fi

        # Cleanup
        rm -rf "$temp_dir"

        if [[ "$changes_made" == false ]]; then
            echo "No changes made."
        fi

        echo ""
    fi
}

# Apply selection from checkbox interface
# Parameters:
#   $1: type ("rules" or "skills")
#   $2: selected items (space-separated, quoted strings)
#   $3: profile (optional, for performance optimization)
#   $4+: cached list of all items (to avoid re-scanning filesystem)
_claude_toggle_apply_selection() {
    local type=$1
    local selected=$2
    local profile="${3:-$(_claude_toggle_detect_profile)}"
    shift 3
    local all_items=("$@")  # Receive cached list as positional parameters

    # If no cached list provided, fetch it (fallback for backward compatibility)
    if [[ ${#all_items[@]} -eq 0 ]]; then
        if [[ "$type" == "rules" ]]; then
            while IFS= read -r item; do
                all_items+=("$item")
            done < <(cd "$CLAUDE_RULES_SOURCE" && find . -type f -name "*.md" | sed 's|^\./||')
        else
            if [[ -d "$CLAUDE_SKILLS_SOURCE" ]]; then
                for skill_dir in "$CLAUDE_SKILLS_SOURCE"/*; do
                    if [[ -d "$skill_dir" ]]; then
                        all_items+=("$(basename "$skill_dir")")
                    fi
                done
            fi
        fi
    fi

    # Parse selected items (space-separated, quoted strings)
    local selected_array=()
    eval "selected_array=($selected)"

    local changes_made=false

    # Disable selected items
    for item in "${selected_array[@]}"; do
        if [[ "$type" == "rules" ]]; then
            # Pass profile to avoid repeated detection (performance optimization)
            if ! _claude_toggle_is_rule_disabled "$item" "$profile"; then
                _claude_toggle_disable_rule "$item" >/dev/null
                echo "  ✓ Disabled: $item"
                changes_made=true
            fi
        else
            # Pass profile to avoid repeated detection (performance optimization)
            if ! _claude_toggle_is_skill_disabled "$item" "$profile"; then
                _claude_toggle_disable_skill "$item" >/dev/null
                echo "  ✓ Disabled: $item"
                changes_made=true
            fi
        fi
    done

    # Enable unselected items (iterate cached array, not find)
    for item in "${all_items[@]}"; do
        local is_selected=false
        for sel in "${selected_array[@]}"; do
            if [[ "$item" == "$sel" ]]; then
                is_selected=true
                break
            fi
        done

        if [[ "$is_selected" == false ]]; then
            if [[ "$type" == "rules" ]]; then
                # Pass profile to avoid repeated detection (performance optimization)
                if _claude_toggle_is_rule_disabled "$item" "$profile"; then
                    _claude_toggle_enable_rule "$item" >/dev/null
                    echo "  ✓ Enabled: $item"
                    changes_made=true
                fi
            else
                # Pass profile to avoid repeated detection (performance optimization)
                if _claude_toggle_is_skill_disabled "$item" "$profile"; then
                    _claude_toggle_enable_skill "$item" >/dev/null
                    echo "  ✓ Enabled: $item"
                    changes_made=true
                fi
            fi
        fi
    done

    if [[ "$changes_made" == false ]]; then
        echo "No changes made."
    else
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "  ⚠️  IMPORTANT: Restart Claude Code for changes to take effect"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "  Claude Code caches skills/rules at startup."
        echo "  To see your changes:"
        echo ""
        echo "    1. Exit Claude (Ctrl+D or /exit)"
        echo "    2. Start new session: cgs"
        echo ""
    fi
}

# Fallback bash select UI - Main menu
_claude_toggle_ui_select() {
    local profile=$(_claude_toggle_detect_profile)

    local categories=("Rules" "Skills" "Exit")
    local selected=0
    local total=${#categories[@]}

    # Draw function
    _draw_category_menu() {
        clear
        echo "Interactive Toggle UI (Profile: $profile)"
        echo "Use ↑/↓ to navigate, Enter to select"
        echo ""

        local i=0
        for category in "${categories[@]}"; do
            if [[ $i -eq $selected ]]; then
                # Highlight current selection with reverse video
                echo -e "  \e[7m${category}\e[0m"
            else
                echo "  ${category}"
            fi
            ((i++))
        done
    }

    # Initial draw
    _draw_category_menu

    # Main input loop
    while true; do
        # Read single character
        IFS= read -rsk1 key

        # Handle escape sequences (arrow keys)
        if [[ $key == $'\e' ]]; then
            read -rsk2 key
            case "$key" in
                '[A') # Up arrow
                    ((selected--))
                    [[ $selected -lt 0 ]] && selected=$((total - 1))
                    _draw_category_menu
                    ;;
                '[B') # Down arrow
                    ((selected++))
                    [[ $selected -ge $total ]] && selected=0
                    _draw_category_menu
                    ;;
            esac
        else
            # Debug: show what key was pressed
            echo "DEBUG: key='$key' len=${#key}" >&2

            case "$key" in
                ''|$'\n') # Enter - select current item
                    case "${categories[$selected]}" in
                        "Rules")
                            _claude_toggle_ui_rules_select
                            _draw_category_menu
                            ;;
                        "Skills")
                            _claude_toggle_ui_skills_select
                            _draw_category_menu
                            ;;
                        "Exit")
                            clear
                            return
                            ;;
                    esac
                    ;;
                'q'|'Q') # Quick quit
                    clear
                    return
                    ;;
            esac
        fi
    done
}

# Fallback bash select UI - Rules menu
_claude_toggle_ui_rules_select() {
    local profile=$(_claude_toggle_detect_profile)
    _claude_toggle_init_rules

    # Build list of all rules
    local rule_list=()
    while IFS= read -r rule_path; do
        rule_list+=("$rule_path")
    done < <(cd "$CLAUDE_RULES_SOURCE" && find . -type f -name "*.md" | sed 's|^\./||' | sort)

    # Track which rules are toggled (associative array)
    declare -A toggled
    for rule in "${rule_list[@]}"; do
        if ! _claude_toggle_is_rule_disabled "$rule" "$profile"; then
            toggled["$rule"]=1  # 1 = enabled (checked)
        else
            toggled["$rule"]=0  # 0 = disabled (unchecked)
        fi
    done

    local selected=0
    local total=${#rule_list[@]}

    # Draw function
    _draw_rules_menu() {
        clear
        echo "Rules Toggle (Profile: $profile)"
        echo "Use ↑/↓ to navigate, Space to toggle, Enter to apply, q to quit"
        echo "Checked items will be ENABLED"
        echo ""

        local i=0
        for rule in "${rule_list[@]}"; do
            local checkbox="[ ]"
            [[ ${toggled[$rule]} -eq 1 ]] && checkbox="[X]"

            if [[ $i -eq $selected ]]; then
                # Highlight current selection with reverse video
                echo -e "  \e[7m${checkbox} ${rule}\e[0m"
            else
                echo "  ${checkbox} ${rule}"
            fi
            ((i++))
        done

        echo ""
        echo "Press Enter to apply changes, q to quit without saving"
    }

    # Initial draw
    _draw_rules_menu

    # Main input loop
    while true; do
        # Read single character
        IFS= read -rsk1 key

        # Handle escape sequences (arrow keys)
        if [[ $key == $'\e' ]]; then
            read -rsk2 key
            case "$key" in
                '[A') # Up arrow
                    ((selected--))
                    [[ $selected -lt 0 ]] && selected=$((total - 1))
                    _draw_rules_menu
                    ;;
                '[B') # Down arrow
                    ((selected++))
                    [[ $selected -ge $total ]] && selected=0
                    _draw_rules_menu
                    ;;
            esac
        else
            case "$key" in
                ' ') # Space - toggle current item
                    local current_rule="${rule_list[$selected]}"
                    if [[ ${toggled[$current_rule]} -eq 1 ]]; then
                        toggled[$current_rule]=0
                    else
                        toggled[$current_rule]=1
                    fi
                    _draw_rules_menu
                    ;;
                ''|$'\n') # Enter - apply changes
                    clear
                    echo "Applying changes..."
                    echo ""

                    local changes_made=false
                    for rule in "${rule_list[@]}"; do
                        local should_be_enabled=${toggled[$rule]}
                        local is_disabled=0
                        _claude_toggle_is_rule_disabled "$rule" "$profile" && is_disabled=1

                        if [[ $should_be_enabled -eq 1 ]] && [[ $is_disabled -eq 1 ]]; then
                            _claude_toggle_enable_rule "$rule" "$profile"
                            echo "  ✓ Enabled: $rule"
                            changes_made=true
                        elif [[ $should_be_enabled -eq 0 ]] && [[ $is_disabled -eq 0 ]]; then
                            _claude_toggle_disable_rule "$rule" "$profile"
                            echo "  ✓ Disabled: $rule"
                            changes_made=true
                        fi
                    done

                    if [[ $changes_made == false ]]; then
                        echo "No changes made."
                    fi

                    echo ""
                    return
                    ;;
                'q'|'Q') # Quit without saving
                    clear
                    echo "Cancelled - no changes applied."
                    echo ""
                    return
                    ;;
            esac
        fi
    done
}

_claude_toggle_ui_skills_select() {
    local profile=$(_claude_toggle_detect_profile)

    # Build list of all skills
    local skill_list=()
    if [[ -d "$CLAUDE_SKILLS_SOURCE" ]]; then
        for skill_dir in "$CLAUDE_SKILLS_SOURCE"/*; do
            if [[ -d "$skill_dir" ]]; then
                local skill_name=$(basename "$skill_dir")
                skill_list+=("$skill_name")
            fi
        done
    fi

    # Track which skills are toggled (associative array)
    declare -A toggled
    for skill in "${skill_list[@]}"; do
        if ! _claude_toggle_is_skill_disabled "$skill" "$profile"; then
            toggled["$skill"]=1  # 1 = enabled (checked)
        else
            toggled["$skill"]=0  # 0 = disabled (unchecked)
        fi
    done

    local selected=0
    local total=${#skill_list[@]}

    # Draw function
    _draw_skills_menu() {
        clear
        echo "Skills Toggle (Profile: $profile)"
        echo "Use ↑/↓ to navigate, Space to toggle, Enter to apply, q to quit"
        echo "Checked items will be ENABLED"
        echo ""

        local i=0
        for skill in "${skill_list[@]}"; do
            local checkbox="[ ]"
            [[ ${toggled[$skill]} -eq 1 ]] && checkbox="[X]"

            if [[ $i -eq $selected ]]; then
                # Highlight current selection with reverse video
                echo -e "  \e[7m${checkbox} ${skill}\e[0m"
            else
                echo "  ${checkbox} ${skill}"
            fi
            ((i++))
        done

        echo ""
        echo "Press Enter to apply changes, q to quit without saving"
    }

    # Initial draw
    _draw_skills_menu

    # Main input loop
    while true; do
        # Read single character
        IFS= read -rsk1 key

        # Handle escape sequences (arrow keys)
        if [[ $key == $'\e' ]]; then
            read -rsk2 key
            case "$key" in
                '[A') # Up arrow
                    ((selected--))
                    [[ $selected -lt 0 ]] && selected=$((total - 1))
                    _draw_skills_menu
                    ;;
                '[B') # Down arrow
                    ((selected++))
                    [[ $selected -ge $total ]] && selected=0
                    _draw_skills_menu
                    ;;
            esac
        else
            case "$key" in
                ' ') # Space - toggle current item
                    local current_skill="${skill_list[$selected]}"
                    if [[ ${toggled[$current_skill]} -eq 1 ]]; then
                        toggled[$current_skill]=0
                    else
                        toggled[$current_skill]=1
                    fi
                    _draw_skills_menu
                    ;;
                ''|$'\n') # Enter - apply changes
                    clear
                    echo "Applying changes..."
                    echo ""

                    local changes_made=false
                    for skill in "${skill_list[@]}"; do
                        local should_be_enabled=${toggled[$skill]}
                        local is_disabled=0
                        _claude_toggle_is_skill_disabled "$skill" "$profile" && is_disabled=1

                        if [[ $should_be_enabled -eq 1 ]] && [[ $is_disabled -eq 1 ]]; then
                            _claude_toggle_enable_skill "$skill" "$profile"
                            echo "  ✓ Enabled: $skill"
                            changes_made=true
                        elif [[ $should_be_enabled -eq 0 ]] && [[ $is_disabled -eq 0 ]]; then
                            _claude_toggle_disable_skill "$skill" "$profile"
                            echo "  ✓ Disabled: $skill"
                            changes_made=true
                        fi
                    done

                    if [[ $changes_made == false ]]; then
                        echo "No changes made."
                    fi

                    echo ""
                    return
                    ;;
                'q'|'Q') # Quit without saving
                    clear
                    echo "Cancelled - no changes applied."
                    echo ""
                    return
                    ;;
            esac
        fi
    done
}

# Main CLI function
claude-toggle() {
    local action=$1
    local type=$2
    local name=$3

    case "$action" in
        ui|interactive)
            _claude_toggle_ui
            ;;
        disable)
            case "$type" in
                rule)
                    if [[ -z "$name" ]]; then
                        echo "Error: Rule path required"
                        echo "Usage: claude-toggle disable rule <path>"
                        echo "Example: claude-toggle disable rule core/working-philosophy.md"
                        return 1
                    fi
                    _claude_toggle_disable_rule "$name"
                    ;;
                skill)
                    if [[ -z "$name" ]]; then
                        echo "Error: Skill name required"
                        echo "Usage: claude-toggle disable skill <name>"
                        echo "Example: claude-toggle disable skill code-reviewer"
                        return 1
                    fi
                    _claude_toggle_disable_skill "$name"
                    ;;
                *)
                    echo "Usage: claude-toggle disable {rule|skill} <name>"
                    return 1
                    ;;
            esac
            ;;
        enable)
            case "$type" in
                rule)
                    if [[ -z "$name" ]]; then
                        echo "Error: Rule path required"
                        echo "Usage: claude-toggle enable rule <path>"
                        echo "Example: claude-toggle enable rule core/working-philosophy.md"
                        return 1
                    fi
                    _claude_toggle_enable_rule "$name"
                    ;;
                skill)
                    if [[ -z "$name" ]]; then
                        echo "Error: Skill name required"
                        echo "Usage: claude-toggle enable skill <name>"
                        echo "Example: claude-toggle enable skill code-reviewer"
                        return 1
                    fi
                    _claude_toggle_enable_skill "$name"
                    ;;
                *)
                    echo "Usage: claude-toggle enable {rule|skill} <name>"
                    return 1
                    ;;
            esac
            ;;
        list)
            _claude_toggle_list
            ;;
        status)
            _claude_toggle_status
            ;;
        reset)
            _claude_toggle_reset
            ;;
        help|--help|-h|"")
            cat <<EOF
Usage: claude-toggle <command> [args]

Commands:
  ui, interactive          Interactive checkbox UI (select items to ENABLE)
  disable rule <path>      Disable a rule file (relative path)
  disable skill <name>     Disable a skill by name
  enable rule <path>       Enable a rule file
  enable skill <name>      Enable a skill
  list                     List all rules and skills with status
  status                   Show enabled items for current profile
  reset                    Reset all toggles (disable everything)
  help                     Show this help message

Examples:
  claude-toggle ui                                      # Interactive UI (select to enable)
  claude-toggle interactive                             # Interactive UI (alias)
  claude-toggle disable rule core/working-philosophy.md
  claude-toggle disable skill animate
  claude-toggle enable rule testing/pre-push-verification.md
  claude-toggle enable skill code-reviewer
  claude-toggle list
  claude-toggle status
  claude-toggle reset

Default Behavior:
  - All rules and skills are DISABLED by default on session start
  - Use 'claude-toggle ui' to select and enable the rules/skills you want
  - Then run Claude with only your selected rules/skills enabled

Profile Detection:
  The system detects your current profile automatically.
  To explicitly set a profile:
    export CLAUDE_TOGGLE_CURRENT_PROFILE="CPA"

Note: Toggle state is session-only (lost when shell exits)
EOF
            ;;
        *)
            echo "Error: Unknown command: $action"
            echo "Run 'claude-toggle help' for usage information"
            return 1
            ;;
    esac
}

# Export functions for use in subshells
export -f _claude_toggle_detect_profile
export -f _claude_toggle_init_rules
export -f _claude_toggle_first_time_init
export -f _claude_toggle_get_rules_var
export -f _claude_toggle_get_skills_var
export -f _claude_toggle_is_rule_disabled
export -f _claude_toggle_is_skill_disabled
export -f _claude_toggle_disable_rule
export -f _claude_toggle_enable_rule
export -f _claude_toggle_disable_skill
export -f _claude_toggle_enable_skill
export -f _claude_toggle_list
export -f _claude_toggle_status
export -f _claude_toggle_reset
export -f _claude_toggle_ui
export -f _claude_toggle_ui_dialog
export -f _claude_toggle_ui_rules_dialog
export -f _claude_toggle_ui_skills_dialog
export -f _claude_toggle_apply_selection
export -f _claude_toggle_ui_select
export -f _claude_toggle_ui_rules_select
export -f _claude_toggle_ui_skills_select
export -f claude-toggle

# Initialize: convert directory symlink to file symlinks on session startup (run once per session)
# This preserves enabled state while allowing toggle control
if [[ -z "$CLAUDE_TOGGLE_INITIALIZED" ]]; then
    export CLAUDE_TOGGLE_INITIALIZED=1

    # First-time initialization: disable everything
    if [[ ! -f "$HOME/.claude/.toggle-initialized" ]]; then
        _claude_toggle_first_time_init
    else
        # Subsequent shells: just ensure rules directory is initialized
        _claude_toggle_init_rules
    fi
fi
