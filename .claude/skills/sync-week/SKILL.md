# Sync Week Skill

## Metadata

- **name**: sync-week
- **description**: Batch sync all learning tasks for a given week to GitHub
- **usage**: `/sync-week <week>`

## Overview

Performs a batch synchronization of all learning task files in a given week (W1-W12) to GitHub Issues. Registers new tasks and updates progress on existing ones.

## Input

- **Argument**: Week number (W1 through W12)

## Process

1. **List Tasks**: Find all Markdown files in `tasks/weekXX/`
2. **Register New Tasks**: For tasks without `github_issue`, run `/register-task`
3. **Update Existing**: For tasks with `github_issue`, run `/update-progress`
4. **Generate Summary**: Calculate metrics for the week:
   - Total tasks
   - Completed tasks
   - Total estimated hours
   - Actual hours spent
   - Blockers identified

5. **Display Report**: Show weekly summary in structured format

## Output

Summary report showing:
- Task completion status
- Time spent vs estimate
- Topic distribution
- Blockers and notes
- Next recommended actions

## Example

```bash
/sync-week W1

# Output:
# ✓ Week 1 Sync Complete
#
# Tasks: 5 total, 2 completed, 0 blocked
# Time: 8 hours (estimated 12)
#
# Topic breakdown:
#   spark-sql: 2 tasks
#   delta: 1 task
#   unity-catalog: 2 tasks
#
# Blockers: None
#
# ✓ All tasks synchronized
```

## Requirements

- Valid week number (W1-W12)
- Week directory must exist (`tasks/weekXX/`)
- GitHub CLI with authenticated session

## Error Handling

- Invalid week format: Show usage
- Week directory not found: Create it
- No tasks in week: Show informational message
- Individual task errors: Continue with remaining tasks

## Notes

- Sync is idempotent: safe to run multiple times
- Progress notes are accumulated as comments
- Week summary is informational only (not stored)
- Blockers are identified from task status and comments
