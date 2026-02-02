#!/bin/bash
# Batch sync all tasks for a given week

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

# Check arguments
if [ $# -eq 0 ]; then
    echo "Usage: sync-week <week>"
    echo ""
    echo "Example:"
    echo "  /sync-week W1"
    echo "  /sync-week W2"
    exit 1
fi

WEEK="$1"

# Validate week format
if ! [[ "$WEEK" =~ ^W[0-9]{1,2}$ ]]; then
    echo -e "${RED}✗ Invalid week format: $WEEK${NC}"
    echo "   Use format: W1, W2, ..., W12"
    exit 1
fi

# Extract week number
week_num="${WEEK#W}"

# Construct week directory
week_dir="$REPO_ROOT/tasks/week$(printf "%02d" "$week_num")"

echo ""
echo -e "${BLUE}=== Syncing $WEEK ===${NC}"
echo "Directory: $week_dir"
echo ""

# Check if week directory exists
if [ ! -d "$week_dir" ]; then
    echo -e "${RED}✗ Week directory not found: $week_dir${NC}"
    exit 1
fi

# Find all task markdown files in the week
task_files=($(find "$week_dir" -maxdepth 1 -name "*.md" -not -name "template.md" 2>/dev/null || true))

if [ ${#task_files[@]} -eq 0 ]; then
    echo -e "${YELLOW}⚠ No tasks found in $WEEK${NC}"
    echo ""
    exit 0
fi

echo -e "${BLUE}Found ${#task_files[@]} task(s)${NC}"
echo ""

# Initialize counters
total_tasks=0
registered_tasks=0
updated_tasks=0
failed_tasks=0
completed_tasks=0
blocked_tasks=0
total_estimate=0
total_actual=0

# Process each task
for task_file in "${task_files[@]}"; do
    echo -e "${BLUE}Processing: $(basename "$task_file")${NC}"

    # Check if file is valid
    if ! bash "$REPO_ROOT/scripts/validation/validate-task.sh" "$task_file" > /dev/null 2>&1; then
        echo -e "${RED}  ✗ Validation failed${NC}"
        ((failed_tasks++))
        echo ""
        continue
    fi

    ((total_tasks++))

    # Extract fields
    yaml_section=$(sed -n '/^---$/,/^---$/p' "$task_file" | sed '1d;$d')
    github_issue=$(echo "$yaml_section" | grep "^github_issue:" | sed 's/^github_issue: *//' | tr -d '"' || true)
    status=$(echo "$yaml_section" | grep "^status:" | sed 's/^status: *//' | tr -d ' "' || echo "Todo")
    estimate=$(echo "$yaml_section" | grep "^estimate:" | sed 's/^estimate: *//' | tr -d ' "' || echo "0")

    ((total_estimate += ${estimate:-0}))

    # Track status
    if [ "$status" = "Done" ]; then
        ((completed_tasks++))
    elif [ "$status" = "Blocked" ]; then
        ((blocked_tasks++))
    fi

    # Register or update
    if [ -z "$github_issue" ]; then
        echo -e "${YELLOW}  Registering new task...${NC}"

        if bash "$SCRIPT_DIR/../../register-task/register.sh" "$task_file" > /dev/null 2>&1; then
            echo -e "${GREEN}  ✓ Registered${NC}"
            ((registered_tasks++))
        else
            echo -e "${RED}  ✗ Registration failed${NC}"
            ((failed_tasks++))
        fi
    else
        echo -e "${YELLOW}  Updating progress...${NC}"

        if bash "$SCRIPT_DIR/../../update-progress/update.sh" "$task_file" > /dev/null 2>&1; then
            echo -e "${GREEN}  ✓ Updated${NC}"
            ((updated_tasks++))
        else
            echo -e "${RED}  ✗ Update failed${NC}"
            ((failed_tasks++))
        fi
    fi

    echo ""
done

# Generate summary
echo -e "${BLUE}=== Weekly Summary ===${NC}"
echo ""
echo -e "📊 ${GREEN}Tasks:${NC} $total_tasks total"
echo "    • Completed: $completed_tasks"
echo "    • Blocked: $blocked_tasks"
echo "    • In Progress: $((total_tasks - completed_tasks - blocked_tasks))"
echo ""
echo -e "⏱️  ${GREEN}Time Estimate:${NC} $total_estimate hours"
echo ""
echo -e "📝 ${GREEN}Sync Status:${NC}"
echo "    • Registered: $registered_tasks"
echo "    • Updated: $updated_tasks"
echo "    • Failed: $failed_tasks"
echo ""

if [ $failed_tasks -eq 0 ]; then
    echo -e "${GREEN}✓ All tasks synchronized successfully${NC}"
else
    echo -e "${YELLOW}⚠ $failed_tasks task(s) failed${NC}"
fi

echo ""
echo "📋 To view $WEEK on GitHub Project:"
echo "   gh project view 1 --web"
echo ""
