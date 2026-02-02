#!/bin/bash
# Setup GitHub Project and custom fields for Databricks study management

set -euo pipefail

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}Setting up GitHub Project for Databricks study...${NC}"

# Check prerequisites
if ! command -v gh &> /dev/null; then
    echo -e "${RED}Error: GitHub CLI (gh) not found. Install it first.${NC}"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo -e "${RED}Error: jq not found. Install it first.${NC}"
    exit 1
fi

# Verify GitHub authentication
if ! gh auth status &> /dev/null; then
    echo -e "${RED}Error: Not authenticated with GitHub. Run 'gh auth login' first.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Prerequisites check passed${NC}"
echo ""

# Create Project
echo -e "${BLUE}Creating GitHub Project...${NC}"
PROJECT_RESPONSE=$(gh project create \
    --title "Databricks DE Professional Roadmap" \
    --owner "@me" \
    --format json 2>/dev/null || true)

if [ -z "$PROJECT_RESPONSE" ]; then
    # Project might already exist, try to get it
    echo "Attempting to retrieve existing project..."
    PROJECT_ID=$(gh project list --format json | \
        jq -r '.[] | select(.title == "Databricks DE Professional Roadmap") | .id' 2>/dev/null || true)

    if [ -z "$PROJECT_ID" ]; then
        echo -e "${RED}Error: Could not create or find project${NC}"
        exit 1
    fi
else
    PROJECT_ID=$(echo "$PROJECT_RESPONSE" | jq -r '.id')
fi

echo -e "${GREEN}✓ Project ID: $PROJECT_ID${NC}"
echo ""

# Source field management library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/graphql.sh"
source "$SCRIPT_DIR/lib/fields.sh"

# Initialize cache
init_cache_dir

# Cache project ID and refresh fields
echo -e "${BLUE}Caching field IDs...${NC}"
refresh_field_cache "$PROJECT_ID"
echo -e "${GREEN}✓ Field cache created${NC}"
echo ""

# Show instructions for manual field creation
echo -e "${BLUE}Next Steps:${NC}"
echo "1. Open GitHub Project: gh project view $PROJECT_ID --web"
echo ""
echo "2. Create the following custom fields manually in the Project settings:"
echo ""
echo "   Single Select Fields:"
echo "   ├─ Status: Todo, Doing, Done, Blocked"
echo "   ├─ Week: W1, W2, W3, W4, W5, W6, W7, W8, W9, W10, W11, W12"
echo "   ├─ Track: Common, DE, ML"
echo "   └─ Priority: P0, P1, P2"
echo ""
echo "   Number Field:"
echo "   └─ Estimate (hours)"
echo ""
echo "   Text Field:"
echo "   └─ Outcome"
echo ""
echo "3. After creating fields, run: $SCRIPT_DIR/create-labels.sh"
echo ""
echo -e "${GREEN}✓ Project setup initiated${NC}"
