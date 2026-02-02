#!/bin/bash
# Field ID caching and retrieval for GitHub Projects V2

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CACHE_FILE="$SCRIPT_DIR/../.claude/github-field-cache.json"

# Source graphql library
source "$SCRIPT_DIR/github/lib/graphql.sh"

# Initialize cache directory
init_cache_dir() {
    mkdir -p "$(dirname "$CACHE_FILE")"
}

# Refresh field cache by querying GitHub API
# Usage: refresh_field_cache "<project_id>"
refresh_field_cache() {
    local project_id="$1"

    init_cache_dir

    echo "Refreshing field cache from GitHub API..." >&2

    local fields_json=$(get_field_ids "$project_id")

    # Parse and build cache structure
    local cache_obj=$(cat << EOF
{
    "project_id": "$project_id",
    "last_updated": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "fields": {}
}
EOF
)

    # Extract field information and build index
    local fields=$(echo "$fields_json" | jq '.data.node.fields.nodes[]')

    while IFS= read -r field; do
        local field_id=$(echo "$field" | jq -r '.id')
        local field_name=$(echo "$field" | jq -r '.name')
        local options=$(echo "$field" | jq '.options // empty')

        # Build field entry
        local field_entry=$(cat << EOF
{
    "id": "$field_id",
    "name": "$field_name",
    "options": $(echo "$options" | jq -r 'map({id, name}) | map({(.name): .id}) | add // {}')
}
EOF
)

        cache_obj=$(echo "$cache_obj" | jq ".fields[\"$field_name\"] = $field_entry")
    done < <(echo "$fields_json" | jq -c '.data.node.fields.nodes[]')

    # Write cache
    echo "$cache_obj" > "$CACHE_FILE"
    echo "Cache updated: $CACHE_FILE" >&2
}

# Load cache from file
load_cache() {
    if [ ! -f "$CACHE_FILE" ]; then
        return 1
    fi
    cat "$CACHE_FILE"
}

# Get field ID from cache
# Usage: get_cached_field_id "Status"
get_cached_field_id() {
    local field_name="$1"

    if [ ! -f "$CACHE_FILE" ]; then
        echo "Error: Field cache not found. Run 'refresh_field_cache' first." >&2
        return 1
    fi

    jq -r ".fields[\"$field_name\"].id // \"\"" "$CACHE_FILE"
}

# Get option ID for a single-select field
# Usage: get_cached_option_id "Status" "Done"
get_cached_option_id() {
    local field_name="$1"
    local option_name="$2"

    if [ ! -f "$CACHE_FILE" ]; then
        echo "Error: Field cache not found. Run 'refresh_field_cache' first." >&2
        return 1
    fi

    jq -r ".fields[\"$field_name\"].options[\"$option_name\"] // \"\"" "$CACHE_FILE"
}

# List all cached fields
list_cached_fields() {
    if [ ! -f "$CACHE_FILE" ]; then
        echo "Field cache not found." >&2
        return 1
    fi

    echo "Cached fields from: $(jq -r '.last_updated' "$CACHE_FILE")"
    jq -r '.fields | keys[]' "$CACHE_FILE"
}

# List options for a cached field
# Usage: list_field_options "Status"
list_field_options() {
    local field_name="$1"

    if [ ! -f "$CACHE_FILE" ]; then
        echo "Field cache not found." >&2
        return 1
    fi

    jq -r ".fields[\"$field_name\"].options | keys[]" "$CACHE_FILE"
}

# Display cache info
show_cache_info() {
    if [ ! -f "$CACHE_FILE" ]; then
        echo "Field cache not found at: $CACHE_FILE" >&2
        return 1
    fi

    echo "=== Field Cache Info ==="
    echo "Project ID: $(jq -r '.project_id' "$CACHE_FILE")"
    echo "Last Updated: $(jq -r '.last_updated' "$CACHE_FILE")"
    echo "Cached Fields:"
    jq -r '.fields | keys[]' "$CACHE_FILE" | sed 's/^/  - /'
}

# Export functions
export -f init_cache_dir refresh_field_cache load_cache get_cached_field_id get_cached_option_id list_cached_fields list_field_options show_cache_info
