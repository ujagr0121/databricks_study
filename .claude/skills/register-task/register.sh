#!/bin/bash
# Register a learning task from local Markdown to GitHub Issue + Project

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
source "$REPO_ROOT/scripts/validation/validate-task.sh"

# Check arguments
if [ $# -eq 0 ]; then
    echo "Usage: register-task <path-to-task.md>"
    echo ""
    echo "Example:"
    echo "  /register-task tasks/week01/task-01-spark-basics.md"
    exit 1
fi

TASK_FILE="$1"

# Resolve absolute path
if [[ "$TASK_FILE" != /* ]]; then
    TASK_FILE="$REPO_ROOT/$TASK_FILE"
fi

echo ""
echo -e "${BLUE}=== Registering Task ===${NC}"
echo "File: $TASK_FILE"
echo ""

# Validate task file
if ! validate_task "$TASK_FILE" > /dev/null 2>&1; then
    echo -e "${RED}✗ Task validation failed. Please fix errors above.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Task validation passed${NC}"
echo ""

# Extract YAML frontmatter
yaml_section=$(sed -n '/^---$/,/^---$/p' "$TASK_FILE" | sed '1d;$d')

# Parse required fields
title=$(echo "$yaml_section" | grep "^title:" | sed 's/^title: *//' | tr -d '"' | sed "s/'//g")
week=$(echo "$yaml_section" | grep "^week:" | sed 's/^week: *//' | tr -d ' "')
track=$(echo "$yaml_section" | grep "^track:" | sed 's/^track: *//' | tr -d ' "')
estimate=$(echo "$yaml_section" | grep "^estimate:" | sed 's/^estimate: *//' | tr -d ' "')
priority=$(echo "$yaml_section" | grep "^priority:" | sed 's/^priority: *//' | tr -d ' "' || echo "P1")
status=$(echo "$yaml_section" | grep "^status:" | sed 's/^status: *//' | tr -d ' "' || echo "Todo")
labels=$(echo "$yaml_section" | grep "^labels:" | sed 's/^labels: *//' | tr -d '[]"' | sed 's/, / /g' || true)

echo -e "${BLUE}Task Details:${NC}"
echo "  Title: $title"
echo "  Week: $week"
echo "  Track: $track"
echo "  Estimate: $estimate hours"
echo "  Priority: $priority"
echo "  Status: $status"
if [ -n "$labels" ]; then
    echo "  Labels: $labels"
fi
echo ""

# Create GitHub Issue
echo -e "${BLUE}Creating GitHub Issue...${NC}"

label_args=""
if [ -n "$labels" ]; then
    label_args="--label $labels"
fi

issue_response=$(gh issue create \
    --title "$title" \
    --body "📋 **Week:** $week
🎯 **Track:** $track
⏱️ **Estimate:** $estimate hours
🔴 **Priority:** $priority

## Learning Objectives
(See linked Markdown file)

---
*Managed by learning management system - edit local Markdown file*" \
    --label "study" \
    $label_args \
    --format json)

ISSUE_NUMBER=$(echo "$issue_response" | jq -r '.number')
ISSUE_ID=$(echo "$issue_response" | jq -r '.id')

echo -e "${GREEN}✓ Issue created: #$ISSUE_NUMBER${NC}"
echo ""

# Get or create field cache
CACHE_FILE="$REPO_ROOT/.claude/github-field-cache.json"
if [ ! -f "$CACHE_FILE" ]; then
    echo -e "${BLUE}Initializing field cache...${NC}"

    # Get project ID
    project_id=$(get_project_id "Databricks DE Professional Roadmap")
    if [ -z "$project_id" ]; then
        echo -e "${RED}✗ Could not find Project. Run setup-project.sh first.${NC}"
        exit 1
    fi

    # Refresh cache
    refresh_field_cache "$project_id"
fi

# Load project ID from cache
PROJECT_ID=$(jq -r '.project_id' "$CACHE_FILE")

# Add issue to project
echo -e "${BLUE}Adding to Project...${NC}"

add_response=$(add_to_project "$PROJECT_ID" "$ISSUE_ID")
ITEM_ID=$(echo "$add_response" | jq -r '.data.addProjectV2ItemById.item.id')

if [ -z "$ITEM_ID" ] || [ "$ITEM_ID" = "null" ]; then
    echo -e "${RED}✗ Failed to add to Project${NC}"
    echo "$add_response" | jq '.'
    exit 1
fi

echo -e "${GREEN}✓ Added to Project${NC}"
echo ""

# Configure custom fields
echo -e "${BLUE}Configuring custom fields...${NC}"

# Get field IDs from cache
STATUS_FIELD=$(get_cached_field_id "Status")
WEEK_FIELD=$(get_cached_field_id "Week")
TRACK_FIELD=$(get_cached_field_id "Track")
ESTIMATE_FIELD=$(get_cached_field_id "Estimate")
PRIORITY_FIELD=$(get_cached_field_id "Priority")

# Get option IDs
STATUS_OPTION=$(get_cached_option_id "Status" "$status")
WEEK_OPTION=$(get_cached_option_id "Week" "$week")
TRACK_OPTION=$(get_cached_option_id "Track" "$track")
PRIORITY_OPTION=$(get_cached_option_id "Priority" "$priority")

# Update Status
if [ -n "$STATUS_FIELD" ] && [ -n "$STATUS_OPTION" ]; then
    update_field "$PROJECT_ID" "$ITEM_ID" "$STATUS_FIELD" "$STATUS_OPTION" "singleSelectField" > /dev/null
    echo -e "${GREEN}✓ Status: $status${NC}"
fi

# Update Week
if [ -n "$WEEK_FIELD" ] && [ -n "$WEEK_OPTION" ]; then
    update_field "$PROJECT_ID" "$ITEM_ID" "$WEEK_FIELD" "$WEEK_OPTION" "singleSelectField" > /dev/null
    echo -e "${GREEN}✓ Week: $week${NC}"
fi

# Update Track
if [ -n "$TRACK_FIELD" ] && [ -n "$TRACK_OPTION" ]; then
    update_field "$PROJECT_ID" "$ITEM_ID" "$TRACK_FIELD" "$TRACK_OPTION" "singleSelectField" > /dev/null
    echo -e "${GREEN}✓ Track: $track${NC}"
fi

# Update Estimate (number field)
if [ -n "$ESTIMATE_FIELD" ]; then
    update_field "$PROJECT_ID" "$ITEM_ID" "$ESTIMATE_FIELD" "$estimate" "numberField" > /dev/null
    echo -e "${GREEN}✓ Estimate: $estimate hours${NC}"
fi

# Update Priority
if [ -n "$PRIORITY_FIELD" ] && [ -n "$PRIORITY_OPTION" ]; then
    update_field "$PROJECT_ID" "$ITEM_ID" "$PRIORITY_FIELD" "$PRIORITY_OPTION" "singleSelectField" > /dev/null
    echo -e "${GREEN}✓ Priority: $priority${NC}"
fi

echo ""

# Update markdown file with github_issue URL
echo -e "${BLUE}Updating Markdown file...${NC}"

ISSUE_URL="https://github.com/ujagr0121/databricks_study/issues/$ISSUE_NUMBER"

# Check if github_issue field exists
if grep -q "^github_issue:" "$TASK_FILE"; then
    # Update existing field
    sed -i.bak "s|^github_issue: .*|github_issue: \"$ISSUE_URL\"|" "$TASK_FILE"
else
    # Add github_issue field after the first line
    sed -i.bak '2i\
github_issue: "'$ISSUE_URL'"' "$TASK_FILE"
fi

rm -f "$TASK_FILE.bak"

echo -e "${GREEN}✓ Updated: $TASK_FILE${NC}"
echo ""

# Final summary
echo -e "${BLUE}=== Task Registration Complete ===${NC}"
echo ""
echo -e "${GREEN}✓ Issue: #$ISSUE_NUMBER${NC}"
echo "  URL: $ISSUE_URL"
echo ""
echo -e "${GREEN}✓ Project fields configured${NC}"
echo ""
echo "📝 Next steps:"
echo "  1. Add learning content to: $TASK_FILE"
echo "  2. Track progress by updating the Markdown file"
echo "  3. Run: /update-progress $TASK_FILE"
echo ""
