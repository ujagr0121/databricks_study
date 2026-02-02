#!/bin/bash
# GraphQL query functions for GitHub Projects V2 API

set -euo pipefail

# Execute a GraphQL query
# Usage: graphql_query "<query_string>"
graphql_query() {
    local query="$1"
    gh api graphql -f query="$query"
}

# Get the node ID for the project by name
# Usage: get_project_id "Project Name"
get_project_id() {
    local project_name="$1"
    local query='query {
        user(login: "ujagr0121") {
            projectsV2(first: 100) {
                nodes {
                    id
                    title
                }
            }
        }
    }'

    local result=$(graphql_query "$query")
    echo "$result" | jq -r ".data.user.projectsV2.nodes[] | select(.title == \"$project_name\") | .id"
}

# Get all field IDs and option IDs for a project
# Usage: get_field_ids "<project_node_id>"
# Returns JSON with field names as keys and {id, type, options} as values
get_field_ids() {
    local project_id="$1"
    local query="query {
        node(id: \"$project_id\") {
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
    }"

    graphql_query "$query"
}

# Add an issue to a project
# Usage: add_to_project "<project_id>" "<issue_id>"
add_to_project() {
    local project_id="$1"
    local issue_id="$2"
    local query="mutation {
        addProjectV2ItemById(input: {projectId: \"$project_id\", contentId: \"$issue_id\"}) {
            item {
                id
            }
        }
    }"

    graphql_query "$query"
}

# Update a custom field on a project item
# Usage: update_field "<project_id>" "<item_id>" "<field_id>" "<value>"
# For single select: value should be the option ID
# For text: value should be the text string
update_field() {
    local project_id="$1"
    local item_id="$2"
    local field_id="$3"
    local value="$4"
    local field_type="${5:-singleSelectField}"  # singleSelectField or textField

    if [ "$field_type" = "singleSelectField" ]; then
        local query="mutation {
            updateProjectV2ItemFieldValue(
                input: {
                    projectId: \"$project_id\"
                    itemId: \"$item_id\"
                    fieldId: \"$field_id\"
                    value: {singleSelectOptionId: \"$value\"}
                }
            ) {
                projectV2Item {
                    id
                }
            }
        }"
    else
        local query="mutation {
            updateProjectV2ItemFieldValue(
                input: {
                    projectId: \"$project_id\"
                    itemId: \"$item_id\"
                    fieldId: \"$field_id\"
                    value: {text: \"$value\"}
                }
            ) {
                projectV2Item {
                    id
                }
            }
        }"
    fi

    graphql_query "$query"
}

# Get issue node ID from issue number
# Usage: get_issue_node_id 123
get_issue_node_id() {
    local issue_number="$1"
    local owner="ujagr0121"
    local repo="databricks_study"

    local query="query {
        repository(owner: \"$owner\", name: \"$repo\") {
            issue(number: $issue_number) {
                id
            }
        }
    }"

    graphql_query "$query" | jq -r '.data.repository.issue.id'
}

# Get the item ID for a given issue in a project
# Usage: get_project_item_id "<project_id>" "<issue_number>"
get_project_item_id() {
    local project_id="$1"
    local issue_number="$2"

    # First get the issue node ID
    local issue_node_id=$(get_issue_node_id "$issue_number")

    local query="query {
        node(id: \"$project_id\") {
            ... on ProjectV2 {
                items(first: 100) {
                    nodes {
                        id
                        content {
                            ... on Issue {
                                number
                            }
                        }
                    }
                }
            }
        }
    }"

    graphql_query "$query" | jq -r ".data.node.items.nodes[] | select(.content.number == $issue_number) | .id"
}

# Create necessary custom fields in a project
# Usage: create_project_fields "<project_id>"
create_project_fields() {
    local project_id="$1"

    # Note: Creating fields via GraphQL API is not directly supported.
    # This function documents the fields that should exist.
    # Fields should be created manually or via GitHub CLI.

    cat << 'EOF'
# Required custom fields to create manually in GitHub Projects UI:

## Single Select Fields:
1. Status - Options: Todo, Doing, Done, Blocked
2. Week - Options: W1, W2, W3, W4, W5, W6, W7, W8, W9, W10, W11, W12
3. Track - Options: Common, DE, ML
4. Priority - Options: P0, P1, P2

## Number Field:
5. Estimate (hours)

## Text Field:
6. Outcome
EOF
}

export -f graphql_query get_project_id get_field_ids add_to_project update_field get_issue_node_id get_project_item_id create_project_fields
