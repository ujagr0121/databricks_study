# Register Task Skill

## Metadata

- **name**: register-task
- **description**: Register a new learning task from local Markdown to GitHub Issue and Project
- **usage**: `/register-task <path-to-task.md>`

## Overview

Converts a local Markdown task file into a GitHub Issue and adds it to the Databricks GitHub Project with properly configured custom fields.

## Input

- **Argument**: Path to Markdown task file (e.g., `tasks/week01/task-01-spark-basics.md`)

## Process

1. **Validation**: Check Markdown file format and required YAML frontmatter
2. **Parse YAML**: Extract week, track, title, estimate, priority, labels
3. **Create Issue**: Use `gh issue create` to create GitHub Issue
4. **Add to Project**: Add Issue to Databricks Project via GraphQL
5. **Set Fields**: Configure custom fields (Status, Week, Track, Estimate, Priority)
6. **Update Markdown**: Append GitHub Issue URL to local file

## Output

- Creates GitHub Issue with task details
- Adds Issue to Project and configures custom fields
- Updates local Markdown with `github_issue` URL
- Prints issue number and Project link

## Example

```bash
/register-task tasks/week01/task-01-spark-basics.md

# Output:
# ✓ Task created: Issue #1
# ✓ Added to Project
# ✓ Fields configured
# 📝 Updated: tasks/week01/task-01-spark-basics.md
# View: https://github.com/ujagr0121/databricks_study/issues/1
```

## Requirements

- GitHub CLI (`gh`) with authenticated session
- jq for JSON parsing
- GitHub Personal Access Token with `repo` and `project` permissions
- Project created and field IDs cached

## Error Handling

- File not found: Exit with error
- Invalid YAML: Validation script will catch
- API errors: Display GraphQL error response
- Missing fields: Provide specific field name in error

## Notes

- Task must validate with `validate-task.sh` before registration
- Issue is created first, then added to Project to ensure Issue exists
- Custom field updates use cached field IDs to minimize API calls
- github_issue URL is appended to preserve local history
