# Databricks DE Professional Certification - Learning Management System

A comprehensive learning management system for tracking Databricks Data Engineer Professional certification study progress. Uses local Markdown files as the source of truth, synchronized to GitHub Projects (V2) via custom Skills and Subagents.

## Overview

This system provides:

- **Local Markdown Files**: Learn objectives, progress tracking, outcomes in portable Markdown
- **GitHub Projects Integration**: Visual task board with custom fields (Status, Week, Track, Estimate, Priority)
- **Custom Skills**: `/register-task`, `/update-progress`, `/sync-week` for GitHub synchronization
- **AI Subagents**: `learning-planner` for curriculum design, `progress-analyzer` for insights
- **Structured Tracking**: 12-week study plan with ~50-100 tasks across Common, DE, and ML tracks

## Prerequisites

- **GitHub Account**: Personal account (ujagr0121)
- **GitHub CLI**: `brew install gh` (or your package manager)
- **jq**: `brew install jq` (for JSON parsing)
- **Personal Access Token**: Repo & Project permissions

## Quick Start

### 1. Initial Setup

```bash
# Create GitHub Personal Access Token
# Go to https://github.com/settings/tokens
# Permissions: repo, project

# Authenticate with GitHub CLI
gh auth login

# Run setup script to create Project and labels
bash scripts/github/setup-project.sh

# Verify Project was created
gh project list
```

### 2. Create Your First Task

```bash
# Copy template for Week 1, Task 1
cp tasks/template.md tasks/week01/task-01-spark-basics.md

# Edit the file with your learning objectives
# week: W1
# track: DE
# title: "Spark SQL Fundamentals"
# estimate: 6

# Register with GitHub
/register-task tasks/week01/task-01-spark-basics.md
```

### 3. Track Progress

```bash
# Add learning notes to your local Markdown file
# Then sync to GitHub

/update-progress tasks/week01/task-01-spark-basics.md
```

### 4. View on GitHub

```bash
# Open your GitHub Project board
gh project view 1 --web

# Or check specific issue
gh issue view <number>
```

## Directory Structure

```
databricks_study/
├── .claude/                    # Claude Code configuration
│   ├── settings.local.json     # Permissions and execution settings
│   ├── github-field-cache.json # Cached field IDs (auto-generated)
│   ├── agents/                 # Subagent definitions
│   │   ├── learning-planner.md
│   │   └── progress-analyzer.md
│   └── skills/                 # Custom Skills
│       ├── register-task/
│       ├── update-progress/
│       └── sync-week/
│
├── scripts/                    # Shared utility scripts
│   ├── github/
│   │   ├── setup-project.sh
│   │   ├── create-labels.sh
│   │   └── lib/
│   │       ├── graphql.sh
│   │       └── fields.sh
│   └── validation/
│       └── validate-task.sh
│
├── .github/
│   └── ISSUE_TEMPLATE/
│       ├── learning-task.yml
│       └── deliverable.yml
│
├── tasks/                      # Learning tasks (source of truth)
│   ├── template.md
│   ├── week01/ ... week12/
│
├── docs/                       # Documentation
│   ├── setup.md
│   ├── workflow.md
│   └── github-setup.md
│
├── management.toml             # Claude Code configuration
├── .gitignore
└── README.md
```

## Available Commands

### Skills

- **`/register-task <path>`**: Register a local task to GitHub Issue + Project
  ```bash
  /register-task tasks/week01/task-01-spark-basics.md
  ```

- **`/update-progress <path>`**: Sync learning progress to Issue
  ```bash
  /update-progress tasks/week01/task-01-spark-basics.md
  ```

- **`/sync-week <week>`**: Batch sync all tasks in a week
  ```bash
  /sync-week W1
  ```

### Agents

- **`learning-planner`**: Design learning curriculum
  ```
  Plan Week 1 and 2 learning tasks for Spark SQL fundamentals
  ```

- **`progress-analyzer`**: Analyze study progress
  ```
  Analyze my Week 1 progress and suggest adjustments
  ```

## Workflow Examples

### Starting a New Week

1. Invoke `learning-planner` agent with week goals
2. Review generated Markdown files in `tasks/weekXX/`
3. Register tasks with `/register-task`
4. Update task metadata in GitHub Project UI if needed

### Daily Learning

1. Open local Markdown file (`tasks/weekXX/task-XX.md`)
2. Add learning notes to "学習記録" section with date stamp
3. Update status (Todo → Doing → Done) in YAML frontmatter
4. Run `/update-progress` to sync to Issue

### Weekly Review

1. Run `/sync-week W1` to batch update all tasks
2. Invoke `progress-analyzer` for insights
3. Review metrics: velocity, topic balance, estimate accuracy
4. Plan next week adjustments

## Key Concepts

### Task Structure

Each task is a Markdown file with YAML frontmatter:

```yaml
---
week: W1
track: DE
title: "Spark SQL Fundamentals"
estimate: 6
priority: P1
status: Todo
labels: [study, spark-sql]
github_issue: "https://github.com/ujagr0121/databricks_study/issues/1"
---

# 学習目標
- Understand Spark SQL architecture
- Master DataFrame API
- Practice query optimization

# 学習記録
## 2026-02-02
- Completed Spark SQL overview
- 2 hours spent

# アウトカム
(Updated after completion)
```

### GitHub Project Fields

Custom fields automatically managed:

- **Status**: Todo, Doing, Done, Blocked
- **Week**: W1-W12
- **Track**: Common, DE, ML
- **Estimate**: Hours (number)
- **Priority**: P0, P1, P2
- **Outcome**: Text field for completion notes

### Local Markdown = Source of Truth

- GitHub Issues are read-only views
- All edits happen in local Markdown
- Skills push updates to GitHub (one-way sync)
- Enables offline work, version control friendly

## Documentation

- **[setup.md](docs/setup.md)**: Detailed setup guide
- **[workflow.md](docs/workflow.md)**: Daily workflow reference
- **[github-setup.md](docs/github-setup.md)**: GitHub Projects configuration details

## Support

For issues and questions:
- Check [docs/github-setup.md](docs/github-setup.md) troubleshooting section
- Review Skill logs: Check `.claude/` directory for error logs
- GitHub API errors: Use `gh api graphql --debug`

## Future Enhancements

- GitHub Actions for automatic Issue→Project sync
- Dashboard generation with weekly metrics
- Integration with learning artifacts (notebooks, queries)
- Codex integration for multi-workspace support

## License

Personal study project - private use only.
