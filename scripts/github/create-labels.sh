#!/bin/bash
# Create GitHub labels for issue categorization

set -euo pipefail

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}Creating GitHub labels...${NC}"

# Check prerequisites
if ! command -v gh &> /dev/null; then
    echo -e "${RED}Error: GitHub CLI (gh) not found.${NC}"
    exit 1
fi

# Verify GitHub authentication
if ! gh auth status &> /dev/null; then
    echo -e "${RED}Error: Not authenticated with GitHub.${NC}"
    exit 1
fi

# Topic labels
TOPICS=(
    "spark-sql:Train learning topic - Spark SQL"
    "delta:Train learning topic - Delta Lake"
    "unity-catalog:Train learning topic - Unity Catalog"
    "jobs:Train learning topic - Databricks Jobs"
    "perf-cost:Train learning topic - Performance & Cost"
    "governance:Train learning topic - Data Governance"
    "cluster-mgmt:Train learning topic - Cluster Management"
    "ml-feature-store:Train learning topic - ML & Feature Store"
)

# Type labels
TYPES=(
    "study:Type - Study material review"
    "handson:Type - Hands-on exercise"
    "deliverable:Type - Deliverable output"
    "review:Type - Review and consolidation"
)

# Create topic labels
echo -e "${BLUE}Creating topic labels...${NC}"
for label in "${TOPICS[@]}"; do
    IFS=':' read -r name description <<< "$label"

    if gh label create "$name" --description "$description" 2>/dev/null; then
        echo -e "${GREEN}✓ Created label: $name${NC}"
    else
        # Label might already exist
        echo "  (Label '$name' may already exist)"
    fi
done

echo ""

# Create type labels
echo -e "${BLUE}Creating type labels...${NC}"
for label in "${TYPES[@]}"; do
    IFS=':' read -r name description <<< "$label"

    if gh label create "$name" --description "$description" 2>/dev/null; then
        echo -e "${GREEN}✓ Created label: $name${NC}"
    else
        # Label might already exist
        echo "  (Label '$name' may already exist)"
    fi
done

echo ""
echo -e "${GREEN}✓ Label setup completed${NC}"
echo ""
echo "Available labels:"
gh label list --limit 100
