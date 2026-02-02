# Update Progress Skill

## Metadata

- **name**: update-progress
- **description**: Sync learning progress from local Markdown to GitHub Issue comments
- **usage**: `/update-progress <path-to-task.md>`

## Overview

Extracts learning progress from local Markdown task file and synchronizes it to the corresponding GitHub Issue as a comment. Also updates Status and Outcome fields if changed.

## Input

- **Argument**: Path to Markdown task file (must have `github_issue` field in frontmatter)

## Process

1. **Parse Markdown**: Extract github_issue URL from frontmatter
2. **Extract Progress**: Get learning notes from "学習記録" section since last sync
3. **Post Comment**: Add new progress as Issue comment
4. **Sync Fields**: Update Status and Outcome fields if changed
5. **Record Sync**: Update markdown with sync timestamp

## Output

- Posts progress comment to GitHub Issue
- Updates Status field if changed
- Updates Outcome field with completion notes
- Prints confirmation with issue number and field updates

## Example

```bash
/update-progress tasks/week01/task-01-spark-basics.md

# Output:
# ✓ Extracted progress notes
# ✓ Posted comment to Issue #1
# ✓ Updated Status: Done
# 📝 Updated: tasks/week01/task-01-spark-basics.md
# View: https://github.com/ujagr0121/databricks_study/issues/1
```

## Requirements

- Task file must have `github_issue` URL in frontmatter
- GitHub CLI (`gh`) with authenticated session
- jq for JSON parsing

## Field Updates

If the local Markdown has changed these fields since last sync:
- **status**: Update Issue's Status custom field
- **outcome**: Update Issue's Outcome custom field (truncated to 255 chars)

## Error Handling

- Missing github_issue: Cannot determine target Issue
- No progress found: Still success, but no comments posted
- API errors: Display error response

## Notes

- Last sync timestamp helps identify new progress notes
- Multiple progress entries can be posted as separate comments
- Outcome field is limited to 255 characters
- Status field supports: Todo, Doing, Done, Blocked
