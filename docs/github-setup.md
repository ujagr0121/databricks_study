# GitHub Projects V2 Configuration Guide

Detailed reference for GitHub Projects V2 setup, custom fields, and GraphQL integration.

## Overview

This system uses GitHub Projects V2 as the visual dashboard for learning tasks. Projects V2 provides:

- Kanban board view (Status columns)
- Custom fields for metadata (Week, Track, Priority, Estimate, Outcome)
- Issue integration
- Filtering and grouping
- GraphQL API access

---

## Manual Field Creation

Since GraphQL API doesn't support field creation, these must be created manually in the GitHub UI.

### Access Project Settings

1. Go to: https://github.com/ujagr0121/databricks_study
2. Click: Projects tab
3. Click: "Databricks DE Professional Roadmap"
4. Click: Settings (gear icon, top right)

### Create Single Select Fields

**Status Field:**
1. Click: "New Field" → "Single select"
2. Name: `Status`
3. Options:
   - `Todo` (color: gray)
   - `Doing` (color: yellow)
   - `Done` (color: green)
   - `Blocked` (color: red)
4. Save

**Week Field:**
1. Click: "New Field" → "Single select"
2. Name: `Week`
3. Options: `W1`, `W2`, `W3`, ..., `W12`
4. Save

**Track Field:**
1. Click: "New Field" → "Single select"
2. Name: `Track`
3. Options:
   - `Common` (applies to all learners)
   - `DE` (Data Engineering focused)
   - `ML` (Machine Learning focused)
4. Save

**Priority Field:**
1. Click: "New Field" → "Single select"
2. Name: `Priority`
3. Options: `P0` (critical), `P1` (high), `P2` (medium)
4. Save

### Create Number Field

**Estimate Field:**
1. Click: "New Field" → "Number"
2. Name: `Estimate`
3. Description: "Estimated hours for this task"
4. Save

### Create Text Field

**Outcome Field:**
1. Click: "New Field" → "Text"
2. Name: `Outcome`
3. Description: "Completion notes and outcomes"
4. Save (limit: 255 characters)

### Field Configuration Complete

Once all fields are created:

1. Return to project board
2. You should see all fields as columns or in task details
3. Run: `bash scripts/github/lib/fields.sh refresh_field_cache`
4. Verify cache updated: `.claude/github-field-cache.json`

---

## Understanding Field IDs

GraphQL uses field IDs (UUIDs) to update custom fields. The system caches these IDs to minimize API calls.

### Field ID Cache Structure

```json
{
  "project_id": "PVT_kwDOBEEX...",
  "last_updated": "2026-02-02T23:30:00Z",
  "fields": {
    "Status": {
      "id": "PVTF_lADOBEEX...",
      "name": "Status",
      "options": {
        "Todo": "PVTSSF_...",
        "Doing": "PVTSSF_...",
        "Done": "PVTSSF_...",
        "Blocked": "PVTSSF_..."
      }
    },
    "Week": {
      "id": "PVTF_...",
      "name": "Week",
      "options": {
        "W1": "PVTSSF_...",
        "W2": "PVTSSF_...",
        ...
      }
    },
    ...
  }
}
```

### Refreshing Cache

When fields change (new options added, etc.):

```bash
source scripts/github/lib/fields.sh
refresh_field_cache <project_id>

# Check cache
cat .claude/github-field-cache.json | jq '.fields | keys'
```

---

## GraphQL API Reference

### Authentication

All GraphQL queries use `gh api graphql`:

```bash
gh api graphql -f query='...'  # File content
gh api graphql -f query@file   # From file
```

Your GitHub credentials are used automatically.

### Core Queries

#### Get Project ID

```graphql
query {
  user(login: "ujagr0121") {
    projectsV2(first: 100) {
      nodes {
        id
        title
      }
    }
  }
}
```

#### Get Field IDs for Project

```graphql
query {
  node(id: "PROJECT_ID") {
    ... on ProjectV2 {
      fields(first: 100) {
        nodes {
          ... on ProjectV2Field {
            id
            name
          }
          ... on ProjectV2SingleSelectField {
            id
            name
            options {
              id
              name
            }
          }
        }
      }
    }
  }
}
```

#### Get Issues in Project

```graphql
query {
  repository(owner: "ujagr0121", name: "databricks_study") {
    issues(first: 100, states: OPEN) {
      nodes {
        number
        title
        body
      }
    }
  }
}
```

#### Get Issue with Custom Fields

```graphql
query {
  node(id: "PROJECT_ID") {
    ... on ProjectV2 {
      items(first: 100) {
        nodes {
          id
          content {
            ... on Issue {
              number
              title
            }
          }
          fieldValues(first: 10) {
            nodes {
              ... on ProjectV2ItemFieldSingleSelectValue {
                field {
                  ... on ProjectV2SingleSelectField {
                    name
                  }
                }
                name
              }
              ... on ProjectV2ItemFieldNumberValue {
                field {
                  ... on ProjectV2Field {
                    name
                  }
                }
                number
              }
            }
          }
        }
      }
    }
  }
}
```

### Mutations

#### Add Issue to Project

```graphql
mutation {
  addProjectV2ItemById(input: {
    projectId: "PROJECT_ID"
    contentId: "ISSUE_NODE_ID"
  }) {
    item {
      id
    }
  }
}
```

#### Update Single Select Field

```graphql
mutation {
  updateProjectV2ItemFieldValue(input: {
    projectId: "PROJECT_ID"
    itemId: "ITEM_ID"
    fieldId: "FIELD_ID"
    value: { singleSelectOptionId: "OPTION_ID" }
  }) {
    projectV2Item {
      id
    }
  }
}
```

#### Update Text Field

```graphql
mutation {
  updateProjectV2ItemFieldValue(input: {
    projectId: "PROJECT_ID"
    itemId: "ITEM_ID"
    fieldId: "FIELD_ID"
    value: { text: "Your text here" }
  }) {
    projectV2Item {
      id
    }
  }
}
```

#### Update Number Field

```graphql
mutation {
  updateProjectV2ItemFieldValue(input: {
    projectId: "PROJECT_ID"
    itemId: "ITEM_ID"
    fieldId: "FIELD_ID"
    value: { number: 42 }
  }) {
    projectV2Item {
      id
    }
  }
}
```

---

## GraphQL Explorer

Debug and test queries using GitHub's GraphQL Explorer:

1. Go to: https://docs.github.com/en/graphql/overview/explorer
2. Authenticate with your GitHub account
3. Write and test queries
4. Copy working queries to scripts

### Example Workflow

```
1. Open Explorer
2. Write query
3. Click "Play" button to execute
4. View results in right panel
5. Refine query if needed
6. Copy to shell script when working
```

---

## Field Management Helpers

### List All Cached Fields

```bash
source scripts/github/lib/fields.sh
list_cached_fields

# Output:
# Cached fields from: 2026-02-02T23:30:00Z
# Status
# Week
# Track
# Priority
# Estimate
# Outcome
```

### Get Field ID

```bash
source scripts/github/lib/fields.sh
get_cached_field_id "Status"
# Output: PVTF_lADOBEEX...
```

### Get Option ID

```bash
source scripts/github/lib/fields.sh
get_cached_option_id "Status" "Done"
# Output: PVTSSF_...
```

### List Field Options

```bash
source scripts/github/lib/fields.sh
list_field_options "Week"

# Output:
# W1
# W2
# W3
# ...
```

---

## Custom Field Updates

### Update via Skill

The preferred method is using Skills which handle caching:

```bash
/register-task tasks/week01/task-01.md
# Automatically sets: Status, Week, Track, Estimate, Priority

/update-progress tasks/week01/task-01.md
# Updates: Status, Outcome if changed
```

### Update via GitHub Project UI

Manual updates in the Project board:

1. Click on a task
2. Edit custom fields in the right panel
3. Changes are immediate

### Update via gh CLI

Direct Issue updates:

```bash
# Add label
gh issue edit 1 --add-label spark-sql

# Close/reopen
gh issue close 1
gh issue reopen 1

# Add comment
gh issue comment 1 --body "Progress update..."
```

### Update via GraphQL

For complex field updates:

```bash
# Get necessary IDs first
PROJECT_ID="..."
ITEM_ID="..."
FIELD_ID="..."
OPTION_ID="..."

# Then update
gh api graphql -f query='mutation {
  updateProjectV2ItemFieldValue(input: {
    projectId: "'$PROJECT_ID'"
    itemId: "'$ITEM_ID'"
    fieldId: "'$FIELD_ID'"
    value: { singleSelectOptionId: "'$OPTION_ID'" }
  }) {
    projectV2Item {
      id
    }
  }
}'
```

---

## Troubleshooting

### Field Cache Out of Sync

If field IDs change (manual updates):

```bash
# Refresh from GitHub
source scripts/github/lib/fields.sh
PROJECT_ID=$(jq -r '.project_id' .claude/github-field-cache.json)
refresh_field_cache "$PROJECT_ID"

# Verify
show_cache_info
```

### "Field not found" Error

Field doesn't exist in project:

```bash
# List actual fields
show_cache_info

# Or query directly:
gh api graphql -f query='...' | jq '.data.node.fields.nodes'

# Then create missing field manually in UI
```

### "Invalid option ID" Error

Option doesn't exist for field:

```bash
# List available options
list_field_options "Status"

# Add missing option in Project Settings
```

### GraphQL Query Errors

Use `--debug` flag to see full API response:

```bash
gh api graphql --debug -f query='...'

# Common errors:
# - Node ID not found: Check PROJECT_ID, ITEM_ID format
# - Permission denied: Check Personal Access Token scopes
# - Invalid value: Verify field type (singleSelect vs text vs number)
```

### API Rate Limiting

If hitting rate limits:

```bash
# Check current rate limit
gh api rate_limit

# Reset timing
gh api rate_limit | jq '.rate.reset | todate'
```

Solutions:
- Use field ID cache to minimize requests
- Batch updates with `/sync-week`
- Wait for rate limit reset (1 hour)

---

## Best Practices

1. **Cache First**: Always use cached field IDs to minimize API calls
2. **Refresh Regularly**: Run `refresh_field_cache` after manual Project changes
3. **Validate Input**: Check option IDs before updating fields
4. **Batch Operations**: Use `/sync-week` for multiple tasks
5. **Monitor Rate Limits**: Know your API usage
6. **Keep Secrets Safe**: Never commit Personal Access Tokens
7. **Test Queries**: Use GraphQL Explorer before scripting

---

## Advanced Features

### Project Views

GitHub Projects V2 supports multiple views:

1. **Table View**: Spreadsheet-like layout
2. **Board View**: Kanban columns (default)
3. **Custom Fields**: Group by Week, Track, etc.

Access: Project settings → Views

### Automation (Future)

Consider GitHub Actions for:
- Auto-add new Issues to Project
- Auto-update fields based on Issue labels
- Weekly sync reports

### Integration with Other Tools

Possible integrations:
- Slack notifications on Issue updates
- Calendar sync for task deadlines
- Habit trackers for study streaks

---

## References

- GitHub Projects V2 Docs: https://docs.github.com/en/issues/planning-and-tracking-with-projects/managing-your-project
- GraphQL API: https://docs.github.com/en/graphql
- Custom Fields: https://docs.github.com/en/issues/planning-and-tracking-with-projects/understanding-fields
- gh CLI: https://cli.github.com/manual
