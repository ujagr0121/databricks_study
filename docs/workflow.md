# Daily Workflow Guide

Step-by-step guide for using the learning management system in your daily study routine.

## Quick Reference

### Commands

```bash
# Register a new task to GitHub
/register-task tasks/week01/task-01-spark-basics.md

# Sync progress to GitHub
/update-progress tasks/week01/task-01-spark-basics.md

# Batch sync all tasks in a week
/sync-week W1

# List agents
/agents
# Then select: learning-planner or progress-analyzer
```

### File Locations

```
tasks/week01/task-01-spark-basics.md      # Local Markdown task
.claude/agents/learning-planner.md         # Planning agent
.claude/agents/progress-analyzer.md        # Analysis agent
.claude/skills/register-task/register.sh   # Registration script
.claude/skills/update-progress/update.sh   # Sync script
```

---

## Standard Workflow

### 1. START A NEW WEEK

**Goal**: Create learning plan for the upcoming week

**Steps**:

1. Open Claude Code (if not already open)

2. Invoke `learning-planner` agent:
   ```
   I want to start Week 1: Databricks Lakehouse and Spark Fundamentals
   Please create 5 structured learning tasks for this week
   ```

3. Review generated tasks in `tasks/week01/`

4. Register each task:
   ```bash
   /register-task tasks/week01/task-01-lakehouse-fundamentals.md
   /register-task tasks/week01/task-02-spark-architecture.md
   /register-task tasks/week01/task-03-dataframe-api.md
   /register-task tasks/week01/task-04-sql-basics.md
   /register-task tasks/week01/task-05-hands-on-exercise.md
   ```

5. View tasks on GitHub:
   ```bash
   gh project view 1 --web
   ```

### 2. DAILY LEARNING

**Goal**: Actively learn and track progress

**Steps**:

1. **Choose a task**:
   - Open `tasks/week01/task-01-lakehouse-fundamentals.md`
   - Read learning objectives

2. **Study**:
   - Follow links and resources
   - Take notes (optional, external to system)
   - Practice hands-on exercises

3. **Record progress in Markdown**:
   - Find "学習記録" section
   - Add entry with date:
   ```markdown
   ## 2026-02-02
   - Completed Lakehouse architecture section
   - Reviewed 3 official Databricks docs
   - Spent 2 hours
   ```

4. **Update status** if task changes:
   ```yaml
   status: Doing  # Changed from Todo
   ```

### 3. SYNC PROGRESS (Daily)

**Goal**: Update GitHub Issues with today's progress

**Steps**:

1. At end of study session:
   ```bash
   /update-progress tasks/week01/task-01-lakehouse-fundamentals.md
   ```

2. Verify on GitHub:
   ```bash
   gh issue view 1  # Replace 1 with your issue number
   ```

3. Check Issue has:
   - New comment with progress notes
   - Status field updated (if changed)

### 4. COMPLETE A TASK

**Goal**: Mark task done when learning objectives are met

**Steps**:

1. **Update local Markdown**:
   ```yaml
   status: Done  # Changed from Doing
   ```

2. **Add outcome summary**:
   ```markdown
   # アウトカム
   Successfully mastered Lakehouse fundamentals:
   ✓ Understand medallion architecture
   ✓ Can explain data lakehouse advantages
   ✓ Completed practice exercises
   ```

3. **Sync to GitHub**:
   ```bash
   /update-progress tasks/week01/task-01-lakehouse-fundamentals.md
   ```

4. **View on Project**:
   - Status field now shows "Done"
   - Outcome field populated
   - Issue shows completion comment

### 5. WEEKLY REVIEW

**Goal**: Analyze progress and plan ahead

**Steps**:

1. **Batch sync all week's tasks**:
   ```bash
   /sync-week W1
   ```

   Output shows:
   - Total tasks: 5
   - Completed: 3
   - Time: 10 hours estimated, 12 hours actual
   - Blockers (if any)

2. **Detailed analysis**:
   ```
   Please analyze my Week 1 progress and tell me:
   - Which topics are taking longer than expected
   - What's my completion velocity
   - Should I adjust Week 2 planning
   ```

3. **Adjust for next week**:
   - Learning planner suggests adjustments
   - Create Week 2 tasks
   - Register them with `/register-task`

---

## Detailed Task Operations

### Create Task from Template

```bash
# Copy template
cp tasks/template.md tasks/week01/task-01-my-task.md

# Edit the file
nano tasks/week01/task-01-my-task.md

# Update required fields:
# week: W1
# track: DE
# title: "My Learning Task"
# estimate: 5
# priority: P1
# status: Todo
# labels: [study, spark-sql]
```

### Register Single Task

```bash
/register-task tasks/week01/task-01-my-task.md

# Output:
# ✓ Issue created: #1
# ✓ Added to Project
# ✓ Fields configured
# 📝 Updated: tasks/week01/task-01-my-task.md
# View: https://github.com/ujagr0121/databricks_study/issues/1
```

### Register Multiple Tasks (Batch)

```bash
for file in tasks/week01/task-*.md; do
  /register-task "$file"
done

# Or use the skill:
/register-task tasks/week01/*.md
```

### Update Progress (Existing Task)

```bash
/update-progress tasks/week01/task-01-my-task.md

# Output:
# ✓ Found Issue: #1
# ✓ Found progress notes
# ✓ Posted comment to Issue #1
# ✓ Status updated: Done
```

### View Issue on GitHub

```bash
# View in terminal
gh issue view 1

# Open in browser
gh issue view 1 --web

# List all issues
gh issue list --label study
```

---

## Advanced Workflows

### Multi-Day Task Tracking

For tasks spanning multiple days:

```markdown
---
week: W1
title: "Delta Lake Deep Dive - Part 1 & 2"
estimate: 8
status: Doing
---

# 学習記録

## 2026-02-02
- Read Delta Lake overview
- 3 hours spent

## 2026-02-03
- Completed optimization exercise
- 2.5 hours spent
- Still need: Part 2 advanced topics

## 2026-02-04
- Finished Part 2: time travel
- 2 hours spent
- Ready to complete
```

Then sync at end:
```bash
/update-progress tasks/week01/task-02-delta-deep-dive.md
```

### Handling Blockers

When stuck on a task:

```yaml
---
status: Blocked
---

# アウトカム
Blocked on: Understanding optimization parameters
Next: Need to review docs or ask for clarification
```

Sync and get help:
```bash
/update-progress tasks/week01/task-03-blocked-task.md

# Then in Claude Code:
I'm blocked on task-03 (Issue #3). Can you help me understand?
```

### Switching Between Tasks

If context switching during week:

```bash
# Update current task
/update-progress tasks/week01/task-01-current.md

# Edit next task status
nano tasks/week01/task-02-next.md
# Change: status: Todo → status: Doing

# Sync new status
/update-progress tasks/week01/task-02-next.md
```

### Re-estimating Tasks

If estimate was too low/high:

```yaml
# Edit in Markdown
estimate: 8  # was 6, takes longer than expected

# When registered, it will be updated:
# OR manually update GitHub Project custom field
```

---

## GitHub Project Navigation

### View All Tasks

```bash
gh project view 1 --web
```

Opens browser to your Project board.

**Features**:
- Drag tasks between Status columns (Todo → Doing → Done)
- Filter by Week, Track, Priority
- View custom fields
- Add notes to tasks

### View Week's Tasks

Using the Project filters:

1. Open: `gh project view 1 --web`
2. Click "Filter" button
3. Add filter: `Week is W1`
4. View: All W1 tasks in columns

### View by Status

```bash
# In Project UI, filter by Status column
# Or via CLI:

gh issue list --state all --label study  # All study tasks
gh issue list --state open --label study  # Open tasks only
```

### Create Checklist from Project

```bash
# Generate markdown checklist of current week
gh issue list --state all | grep "W1" | cut -d'#' -f2 | \
  xargs -I {} echo "- [ ] Issue #{}"
```

---

## Integration with Learning

### Link External Resources

In task Markdown:

```markdown
# 学習目標
- Master Spark DataFrame API

# Resources
- Official Docs: https://docs.databricks.com/dev-tools/python/databricks-sql-python.html
- Video Tutorial: [link]
- Practice Repo: [link]

# 学習記録
## 2026-02-02
- Watched video tutorial (45 min)
- Read official docs (1 hour)
```

### Attach Code/Notebooks

While not in Markdown directly, reference external files:

```markdown
# 学習記録
## 2026-02-02
- Completed notebook: `../notebooks/week01_spark_basics.py`
- Exercise repo: [link to gist or repo]
```

Then add to Git and link:
```bash
git add notebooks/week01_spark_basics.py
git commit -m "Week 1: Spark basics notebook"

# Reference in progress notes:
# See commit: [hash]
```

---

## Troubleshooting Common Issues

### Task won't register

```bash
# Check validation
bash scripts/validation/validate-task.sh tasks/week01/task-01.md

# Common issues:
# - Missing required fields (week, track, title, estimate)
# - Invalid week format (use W1-W12, not Week1)
# - Invalid track (use Common, DE, or ML)
# - Invalid status (use Todo, Doing, Done, or Blocked)
```

### /register-task fails

```bash
# Check GitHub auth
gh auth status

# Check field cache
cat .claude/github-field-cache.json | jq '.fields'

# If cache missing, refresh:
bash scripts/github/lib/fields.sh
```

### /update-progress shows no change

```bash
# Verify github_issue field exists
grep github_issue tasks/week01/task-01.md

# Check Issue comments
gh issue view <issue_number> --comments

# Force refresh GitHub cache
gh auth refresh
```

### Project link shows 404

```bash
# Get correct project ID
gh project list

# Verify project accessible
gh project view <project_id>
```

---

## Performance Tips

### Batch Operations

For multiple tasks at once:

```bash
# Register all Week 1 tasks
/sync-week W1

# Better than looping individual /register-task calls
```

### Update Multiple Tasks

```bash
# Update all week 1 tasks' progress
for file in tasks/week01/task-*.md; do
  /update-progress "$file"
done
```

### Reduce API Calls

- Use `/sync-week` instead of individual updates
- Cache is refreshed once per session
- GitHub API rate limit: 5000/hour (usually not hit)

---

## Best Practices

1. **Consistency**: Sync progress at least daily
2. **Accuracy**: Record actual time spent in learning notes
3. **Honesty**: Use realistic estimates, update if wrong
4. **Progress**: Update status regularly (Todo → Doing → Done)
5. **Backup**: Git commit your Markdown changes regularly
6. **Review**: Weekly analysis to adjust pace and focus

## Next Steps

- Start with `docs/setup.md` if not yet complete
- Review `docs/github-setup.md` for deeper GitHub config
- Begin Week 1 with learning-planner agent
- Check progress weekly with progress-analyzer agent
