#!/bin/bash
# Sync learning progress from local Markdown to GitHub Issue

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

# Source libraries
source "$REPO_ROOT/scripts/github/lib/graphql.sh"
source "$REPO_ROOT/scripts/github/lib/fields.sh"

# Check arguments
if [ $# -eq 0 ]; then
    echo "Usage: update-progress <path-to-task.md>"
    echo ""
    echo "Example:"
    echo "  /update-progress tasks/week01/task-01-spark-basics.md"
    exit 1
fi

TASK_FILE="$1"

# Resolve absolute path
if [[ "$TASK_FILE" != /* ]]; then
    TASK_FILE="$REPO_ROOT/$TASK_FILE"
fi

echo ""
echo -e "${BLUE}=== Syncing Progress ===${NC}"
echo "File: $TASK_FILE"
echo ""

# Check file exists
if [ ! -f "$TASK_FILE" ]; then
    echo -e "${RED}✗ File not found: $TASK_FILE${NC}"
    exit 1
fi

# Extract YAML frontmatter
yaml_section=$(sed -n '/^---$/,/^---$/p' "$TASK_FILE" | sed '1d;$d')

# Get github_issue URL
github_issue=$(echo "$yaml_section" | grep "^github_issue:" | sed 's/^github_issue: *//' | tr -d '"' || true)

if [ -z "$github_issue" ]; then
    echo -e "${RED}✗ No github_issue URL found in frontmatter${NC}"
    echo "   Please run /register-task first"
    exit 1
fi

# Extract issue number from URL
ISSUE_NUMBER=$(echo "$github_issue" | grep -oE '[0-9]+$')

echo -e "${GREEN}✓ Found Issue: #$ISSUE_NUMBER${NC}"
echo ""

# Extract current status and outcome from local file
current_status=$(echo "$yaml_section" | grep "^status:" | sed 's/^status: *//' | tr -d ' "' || echo "Todo")
current_outcome=$(echo "$yaml_section" | grep "^outcome:" | sed 's/^outcome: *//' | tr -d ' "' || true)

echo -e "${BLUE}Current state:${NC}"
echo "  Status: $current_status"
if [ -n "$current_outcome" ]; then
    echo "  Outcome: ${current_outcome:0:50}..."
fi
echo ""

# Extract learning records (학習記録 section)
echo -e "${BLUE}Extracting progress notes...${NC}"

# Find the 학習記録 section and extract content until next section or end
progress_content=$(awk '/^# 学習記録/,/^# / {if (!/^# / || NR==1) print}' "$TASK_FILE" | \
    sed '1d' | \
    sed '/^# /d' | \
    sed '/^$/d' | \
    head -20)

if [ -z "$progress_content" ]; then
    echo -e "${YELLOW}⚠ No progress notes found${NC}"
    echo ""
else
    # Create progress comment
    progress_comment="## 進捗報告

\`\`\`
$progress_content
\`\`\`

*更新: $(date '+%Y-%m-%d %H:%M:%S')*"

    echo -e "${GREEN}✓ Found progress notes${NC}"
    echo ""

    echo -e "${BLUE}Posting comment to Issue #$ISSUE_NUMBER...${NC}"

    # Post comment to issue
    gh issue comment "$ISSUE_NUMBER" --body "$progress_comment"

    echo -e "${GREEN}✓ Comment posted${NC}"
    echo ""
fi

# Update GitHub Issue fields if status changed
echo -e "${BLUE}Checking for field updates...${NC}"

# Get project ID from cache
CACHE_FILE="$REPO_ROOT/.claude/github-field-cache.json"
if [ ! -f "$CACHE_FILE" ]; then
    echo -e "${YELLOW}⚠ Field cache not found. Skipping field updates.${NC}"
    echo "   Run /register-task to create cache.${NC}"
else
    PROJECT_ID=$(jq -r '.project_id' "$CACHE_FILE")

    # Get Issue node ID
    issue_node_id=$(get_issue_node_id "$ISSUE_NUMBER")

    # Get project item ID
    item_id=$(get_project_item_id "$PROJECT_ID" "$ISSUE_NUMBER")

    if [ -n "$item_id" ] && [ "$item_id" != "null" ]; then
        # Get field IDs from cache
        STATUS_FIELD=$(get_cached_field_id "Status")
        OUTCOME_FIELD=$(get_cached_field_id "Outcome")

        # Update Status if changed
        if [ -n "$STATUS_FIELD" ]; then
            status_option=$(get_cached_option_id "Status" "$current_status")
            if [ -n "$status_option" ] && [ "$status_option" != "null" ]; then
                update_field "$PROJECT_ID" "$item_id" "$STATUS_FIELD" "$status_option" "singleSelectField" > /dev/null 2>&1
                echo -e "${GREEN}✓ Status updated: $current_status${NC}"
            fi
        fi

        # Update Outcome if present
        if [ -n "$current_outcome" ] && [ -n "$OUTCOME_FIELD" ]; then
            # Truncate to 255 chars for text field
            outcome_short="${current_outcome:0:255}"
            update_field "$PROJECT_ID" "$item_id" "$OUTCOME_FIELD" "$outcome_short" "textField" > /dev/null 2>&1
            echo -e "${GREEN}✓ Outcome updated${NC}"
        fi
    else
        echo -e "${YELLOW}⚠ Could not find Issue in Project. Fields not updated.${NC}"
    fi
fi

echo ""

# Update sync timestamp in Markdown (optional)
if ! echo "$yaml_section" | grep -q "^last_sync:"; then
    # Add last_sync field
    timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    sed -i.bak '2i\
last_sync: "'$timestamp'"' "$TASK_FILE"
    rm -f "$TASK_FILE.bak"
    echo -e "${GREEN}✓ Added sync timestamp${NC}"
fi

echo ""

# Final summary
echo -e "${BLUE}=== Progress Sync Complete ===${NC}"
echo ""
echo -e "${GREEN}✓ Issue #$ISSUE_NUMBER updated${NC}"
echo "  URL: $github_issue"
echo ""
