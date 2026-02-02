#!/bin/bash
# Validate Markdown task files

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

validate_task() {
    local task_file="$1"
    local errors=0

    if [ ! -f "$task_file" ]; then
        echo -e "${RED}✗ File not found: $task_file${NC}"
        return 1
    fi

    echo "Validating: $task_file"

    # Check for YAML frontmatter
    if ! head -1 "$task_file" | grep -q "^---$"; then
        echo -e "${RED}✗ Missing YAML frontmatter (must start with ---)${NC}"
        ((errors++))
    fi

    # Extract YAML frontmatter
    local yaml_section=$(sed -n '/^---$/,/^---$/p' "$task_file" | sed '1d;$d')

    # Check required fields
    local required_fields=("week" "track" "title" "estimate")
    for field in "${required_fields[@]}"; do
        if ! echo "$yaml_section" | grep -q "^$field:"; then
            echo -e "${RED}✗ Missing required field: $field${NC}"
            ((errors++))
        fi
    done

    # Validate week format (W1-W12)
    if echo "$yaml_section" | grep -q "^week:"; then
        local week=$(echo "$yaml_section" | grep "^week:" | sed 's/^week: *//' | tr -d ' "')
        if ! [[ $week =~ ^W[0-9]+$ ]]; then
            echo -e "${RED}✗ Invalid week format: $week (should be W1, W2, ..., W12)${NC}"
            ((errors++))
        fi
    fi

    # Validate track (Common, DE, ML)
    if echo "$yaml_section" | grep -q "^track:"; then
        local track=$(echo "$yaml_section" | grep "^track:" | sed 's/^track: *//' | tr -d ' "')
        if ! [[ $track =~ ^(Common|DE|ML)$ ]]; then
            echo -e "${RED}✗ Invalid track: $track (should be Common, DE, or ML)${NC}"
            ((errors++))
        fi
    fi

    # Validate estimate is a number
    if echo "$yaml_section" | grep -q "^estimate:"; then
        local estimate=$(echo "$yaml_section" | grep "^estimate:" | sed 's/^estimate: *//' | tr -d ' "')
        if ! [[ $estimate =~ ^[0-9]+$ ]]; then
            echo -e "${RED}✗ Invalid estimate: $estimate (should be a number)${NC}"
            ((errors++))
        fi
    fi

    # Validate priority if present
    if echo "$yaml_section" | grep -q "^priority:"; then
        local priority=$(echo "$yaml_section" | grep "^priority:" | sed 's/^priority: *//' | tr -d ' "')
        if ! [[ $priority =~ ^P[0-2]$ ]]; then
            echo -e "${RED}✗ Invalid priority: $priority (should be P0, P1, or P2)${NC}"
            ((errors++))
        fi
    fi

    # Validate status if present
    if echo "$yaml_section" | grep -q "^status:"; then
        local status=$(echo "$yaml_section" | grep "^status:" | sed 's/^status: *//' | tr -d ' "')
        if ! [[ $status =~ ^(Todo|Doing|Done|Blocked)$ ]]; then
            echo -e "${RED}✗ Invalid status: $status (should be Todo, Doing, Done, or Blocked)${NC}"
            ((errors++))
        fi
    fi

    # Check for required sections after frontmatter
    if ! grep -q "^# 学習目標" "$task_file"; then
        echo -e "${YELLOW}⚠ Missing recommended section: # 学習目標${NC}"
    fi

    if [ $errors -eq 0 ]; then
        echo -e "${GREEN}✓ Validation passed${NC}"
        return 0
    else
        echo -e "${RED}✗ Validation failed with $errors error(s)${NC}"
        return 1
    fi
}

# If no arguments provided, show usage
if [ $# -eq 0 ]; then
    echo "Usage: validate-task.sh <task-file> [<task-file> ...]"
    echo ""
    echo "Example:"
    echo "  validate-task.sh tasks/week01/task-01-spark-basics.md"
    echo "  validate-task.sh tasks/week01/*.md"
    exit 1
fi

# Validate all provided files
failed=0
for task_file in "$@"; do
    if ! validate_task "$task_file"; then
        ((failed++))
    fi
    echo ""
done

if [ $failed -gt 0 ]; then
    exit 1
fi

exit 0
