# Setup Guide

Complete setup guide for the Databricks Learning Management System.

## Prerequisites

### Required Tools

1. **GitHub CLI** (`gh`)
   ```bash
   # macOS with Homebrew
   brew install gh

   # Other systems: https://cli.github.com/
   ```

2. **jq** (JSON query tool)
   ```bash
   # macOS with Homebrew
   brew install jq

   # Other systems: https://stedolan.github.io/jq/
   ```

3. **Bash** (4.0+)
   - Most systems come with Bash
   - Verify: `bash --version`

4. **Git**
   - Required for repository operations
   - Verify: `git --version`

### GitHub Account Setup

1. **Personal Account**: https://github.com/ujagr0121 (already set up)
2. **Repository Access**: Fork or use existing databricks_study repo
3. **Personal Access Token**:
   - Go to: https://github.com/settings/tokens/new
   - Token name: "Claude Code - Databricks Study"
   - Expiration: 90 days or custom
   - Scopes needed:
     - `repo` (full control of private repositories)
     - `project` (read and write to Projects)
   - Click "Generate token"
   - **Save the token securely** - you'll need it next

## Initial Setup Steps

### Step 1: Authenticate with GitHub CLI

```bash
gh auth login
# Follow prompts:
# - Protocol: HTTPS
# - Authenticate GitHub CLI for your account: Yes
# - Paste your Personal Access Token when prompted
# - Git credential helper: Recommended (or choose as needed)
```

Verify authentication:
```bash
gh auth status
# Should show: Logged in to github.com as ujagr0121
```

### Step 2: Create GitHub Project

Create the GitHub Projects V2 project that will host all tasks:

```bash
cd /Users/ujagr0121/dev/projects/databricks_study

# Run the setup script
bash scripts/github/setup-project.sh

# Expected output:
# ✓ Prerequisites check passed
# ✓ Project ID: [UUID]
# ✓ Field cache created
# Next Steps: Create custom fields in GitHub Project UI
```

### Step 3: Manually Create Custom Fields

The GraphQL API doesn't support creating custom fields, so these must be created manually:

1. **Open GitHub Project**: `gh project view 1 --web`
   - This opens your browser to the project settings

2. **Add Custom Fields** (in Settings → Custom Fields):

   **Single Select Fields:**
   - **Status**: Options: `Todo`, `Doing`, `Done`, `Blocked`
   - **Week**: Options: `W1`, `W2`, ..., `W12`
   - **Track**: Options: `Common`, `DE`, `ML`
   - **Priority**: Options: `P0`, `P1`, `P2`

   **Number Field:**
   - **Estimate**: (for hours)

   **Text Field:**
   - **Outcome**: (for completion notes)

3. **Save Field Settings**

4. **Refresh Field Cache**:
   ```bash
   # After creating fields, refresh the cache
   bash scripts/github/lib/fields.sh
   # Should see: ✓ Cache updated
   ```

### Step 4: Create Issue Labels

Create labels for categorizing tasks:

```bash
bash scripts/github/create-labels.sh

# Expected output:
# ✓ Created label: spark-sql
# ✓ Created label: delta
# ... (and more topic labels)
# ✓ Label setup completed
```

Verify labels were created:
```bash
gh label list --limit 100
```

### Step 5: Verify Setup

Test that everything is working:

```bash
# Check GitHub auth
gh auth status

# List projects
gh project list

# View project
gh project view 1 --web

# Test GraphQL query
gh api graphql -f query='query { viewer { login } }'
# Should return your GitHub username
```

## File Permissions

Make scripts executable:

```bash
chmod +x scripts/github/lib/*.sh
chmod +x scripts/github/*.sh
chmod +x scripts/validation/*.sh
chmod +x .claude/skills/*/restore.sh
```

Or recursively:
```bash
find scripts .claude -name "*.sh" -exec chmod +x {} \;
```

## Claude Code Configuration

### Update .claude/settings.local.json

Ensure permissions are properly configured:

```json
{
  "permissions": {
    "allow": [
      "Bash(gh *)",
      "Bash(jq *)",
      "Bash(*register-task*)",
      "Bash(*update-progress*)",
      "Bash(*sync-week*)",
      "Write(tasks/**/*.md)",
      "Edit(tasks/**/*.md)",
      "Read(tasks/**/*.md)",
      "Glob(tasks/**)",
      "Read(.claude/**)",
      "Read(scripts/**)"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Write(.git/**)"
    ]
  }
}
```

### Update management.toml

Verify these settings are enabled:

```toml
[execution]
allow_shell = true
allow_file_write = true

[agent.learning-planner]
max_iterations = 50
timeout = 300

[agent.progress-analyzer]
max_iterations = 30
timeout = 180
```

## Troubleshooting

### "gh: command not found"

GitHub CLI not installed or not in PATH.

```bash
# Install
brew install gh

# Verify
gh --version
```

### "jq: command not found"

jq not installed.

```bash
# Install
brew install jq

# Verify
jq --version
```

### "Error: Not authenticated with GitHub"

Authentication failed or expired.

```bash
# Re-authenticate
gh auth logout
gh auth login

# Or refresh token if expired:
gh auth refresh
```

### "Field cache not found"

Cache file not created during setup.

```bash
# Recreate cache
source scripts/github/lib/graphql.sh
source scripts/github/lib/fields.sh
init_cache_dir
project_id=$(get_project_id "Databricks DE Professional Roadmap")
refresh_field_cache "$project_id"
```

### "Error: Could not find Project"

Project not created yet.

```bash
# Create project manually
gh project create --title "Databricks DE Professional Roadmap" --owner "@me"

# Or re-run setup
bash scripts/github/setup-project.sh
```

### "Custom fields not showing in Project"

Fields may not have been created in the UI.

```bash
# Open project and manually add fields:
gh project view 1 --web

# Then refresh cache:
bash scripts/github/lib/fields.sh
# Select refresh option
```

### GraphQL Errors

For debugging GraphQL issues:

```bash
# Add --debug flag for verbose output
gh api graphql --debug -f query='...'

# Save response to file
gh api graphql -f query='...' > graphql-response.json

# View response
cat graphql-response.json | jq '.'
```

## Testing Setup

Quick validation that everything is working:

```bash
#!/bin/bash
# test-setup.sh

echo "Testing GitHub CLI..."
gh auth status || exit 1

echo "Testing jq..."
echo '{"test": true}' | jq '.test' || exit 1

echo "Testing Project access..."
gh project list || exit 1

echo "Testing custom fields..."
bash scripts/github/lib/fields.sh show_cache_info || exit 1

echo "✓ All tests passed!"
```

Save this script and run:
```bash
bash test-setup.sh
```

## Next Steps

After setup is complete:

1. **Create first task**: See `docs/workflow.md`
2. **Invite learning-planner**: Generate Week 1 tasks
3. **Register tasks**: Use `/register-task` Skill
4. **Start learning**: Add content to Markdown files
5. **Track progress**: Use `/update-progress` regularly

## Additional Resources

- GitHub CLI docs: https://cli.github.com/manual
- GitHub Projects V2: https://docs.github.com/en/issues/planning-and-tracking-with-projects
- GraphQL API: https://docs.github.com/en/graphql
- jq manual: https://stedolan.github.io/jq/manual/

## Support

If you encounter issues:

1. Check relevant log files in `.claude/` directory
2. Review troubleshooting section above
3. Test individual components with `test-setup.sh`
4. Check GitHub API status: https://www.githubstatus.com/
