# セットアップガイド

Databricks学習管理システムの完全セットアップガイド。

## 前提条件

### 必要なツール

1. **GitHub CLI** (`gh`)
   ```bash
   # macOS（Homebrew使用）
   brew install gh

   # その他のシステム: https://cli.github.com/
   ```

2. **jq** （JSONクエリツール）
   ```bash
   # macOS（Homebrew使用）
   brew install jq

   # その他のシステム: https://stedolan.github.io/jq/
   ```

3. **Bash** (4.0+)
   - ほとんどのシステムにBashがプリインストール済み
   - 確認: `bash --version`

4. **Git**
   - リポジトリ操作に必要
   - 確認: `git --version`

### GitHubアカウントのセットアップ

1. **個人アカウント**: https://github.com/ujagr0121 （すでにセットアップ済み）
2. **リポジトリアクセス**: databricks_studyリポジトリをフォークまたは使用
3. **Personal Access Token**:
   - アクセス: https://github.com/settings/tokens/new
   - トークン名: "Claude Code - Databricks Study"
   - 有効期限: 90日またはカスタム
   - 必要なスコープ:
     - `repo` （プライベートリポジトリの完全制御）
     - `project` （Projectsへの読み書き）
   - 「Generate token」をクリック
   - **トークンを安全に保存** - 次のステップで必要になります

## 初期セットアップ手順

### ステップ1: GitHub CLIで認証

```bash
gh auth login
# プロンプトに従う:
# - プロトコル: HTTPS
# - GitHubアカウントでGitHub CLIを認証: Yes
# - プロンプト表示時にPersonal Access Tokenを貼り付け
# - Git credential helper: 推奨（または必要に応じて選択）
```

認証を確認:
```bash
gh auth status
# 表示されるべき内容: Logged in to github.com as ujagr0121
```

### ステップ2: GitHub Projectを作成

すべてのタスクをホストするGitHub Projects V2プロジェクトを作成:

```bash
cd /Users/ujagr0121/dev/projects/databricks_study

# セットアップスクリプトを実行
bash scripts/github/setup-project.sh

# 期待される出力:
# ✓ Prerequisites check passed
# ✓ Project ID: [UUID]
# ✓ Field cache created
# Next Steps: GitHub Project UIでカスタムフィールドを作成
```

### ステップ3: カスタムフィールドを手動で作成

GraphQL APIはカスタムフィールドの作成をサポートしていないため、手動で作成する必要があります：

1. **GitHub Projectを開く**: `gh project view 1 --web`
   - ブラウザでプロジェクト設定が開きます

2. **カスタムフィールドを追加**（Settings → Custom Fieldsで）:

   **単一選択フィールド:**
   - **Status**: オプション: `Todo`, `Doing`, `Done`, `Blocked`
   - **Week**: オプション: `W1`, `W2`, ..., `W12`
   - **Track**: オプション: `Common`, `DE`, `ML`
   - **Priority**: オプション: `P0`, `P1`, `P2`

   **数値フィールド:**
   - **Estimate**: （時間用）

   **テキストフィールド:**
   - **Outcome**: （完了ノート用）

3. **フィールド設定を保存**

4. **フィールドキャッシュをリフレッシュ**:
   ```bash
   # フィールド作成後、キャッシュをリフレッシュ
   bash scripts/github/lib/fields.sh
   # 表示されるべき内容: ✓ Cache updated
   ```

### ステップ4: Issueラベルを作成

タスク分類用のラベルを作成:

```bash
bash scripts/github/create-labels.sh

# 期待される出力:
# ✓ Created label: spark-sql
# ✓ Created label: delta
# ... (その他のトピックラベル)
# ✓ Label setup completed
```

ラベルが作成されたことを確認:
```bash
gh label list --limit 100
```

### ステップ5: セットアップを確認

すべてが動作していることをテスト:

```bash
# GitHub認証を確認
gh auth status

# プロジェクトをリスト
gh project list

# プロジェクトを表示
gh project view 1 --web

# GraphQLクエリをテスト
gh api graphql -f query='query { viewer { login } }'
# GitHubユーザー名を返すべき
```

## ファイル権限

スクリプトを実行可能にする:

```bash
chmod +x scripts/github/lib/*.sh
chmod +x scripts/github/*.sh
chmod +x scripts/validation/*.sh
chmod +x .claude/skills/*/register.sh
```

または再帰的に:
```bash
find scripts .claude -name "*.sh" -exec chmod +x {} \;
```

## Claude Code設定

### .claude/settings.local.jsonの更新

権限が適切に設定されていることを確認:

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

### management.tomlの更新

以下の設定が有効になっていることを確認:

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

## トラブルシューティング

### "gh: command not found"

GitHub CLIがインストールされていないかPATHに含まれていません。

```bash
# インストール
brew install gh

# 確認
gh --version
```

### "jq: command not found"

jqがインストールされていません。

```bash
# インストール
brew install jq

# 確認
jq --version
```

### "Error: Not authenticated with GitHub"

認証が失敗したか期限切れです。

```bash
# 再認証
gh auth logout
gh auth login

# またはトークンが期限切れの場合はリフレッシュ:
gh auth refresh
```

### "Field cache not found"

セットアップ中にキャッシュファイルが作成されませんでした。

```bash
# キャッシュを再作成
source scripts/github/lib/graphql.sh
source scripts/github/lib/fields.sh
init_cache_dir
project_id=$(get_project_id "Databricks DE Professional Roadmap")
refresh_field_cache "$project_id"
```

### "Error: Could not find Project"

プロジェクトがまだ作成されていません。

```bash
# プロジェクトを手動で作成
gh project create --title "Databricks DE Professional Roadmap" --owner "@me"

# またはセットアップを再実行
bash scripts/github/setup-project.sh
```

### "Custom fields not showing in Project"

フィールドがUIで作成されていない可能性があります。

```bash
# プロジェクトを開いて手動でフィールドを追加:
gh project view 1 --web

# その後キャッシュをリフレッシュ:
bash scripts/github/lib/fields.sh
# リフレッシュオプションを選択
```

### GraphQLエラー

GraphQL問題のデバッグ:

```bash
# 詳細な出力のために--debugフラグを追加
gh api graphql --debug -f query='...'

# レスポンスをファイルに保存
gh api graphql -f query='...' > graphql-response.json

# レスポンスを表示
cat graphql-response.json | jq '.'
```

## セットアップのテスト

すべてが動作していることを簡単に検証:

```bash
#!/bin/bash
# test-setup.sh

echo "GitHub CLIをテスト中..."
gh auth status || exit 1

echo "jqをテスト中..."
echo '{"test": true}' | jq '.test' || exit 1

echo "Projectアクセスをテスト中..."
gh project list || exit 1

echo "カスタムフィールドをテスト中..."
bash scripts/github/lib/fields.sh show_cache_info || exit 1

echo "✓ すべてのテストが成功しました！"
```

このスクリプトを保存して実行:
```bash
bash test-setup.sh
```

## 次のステップ

セットアップ完了後：

1. **最初のタスクを作成**: `docs/workflow.md`を参照
2. **learning-plannerを実行**: Week 1タスクを生成
3. **タスクを登録**: `/register-task` Skillを使用
4. **学習を開始**: Markdownファイルにコンテンツを追加
5. **進捗を追跡**: 定期的に`/update-progress`を使用

## 追加リソース

- GitHub CLIドキュメント: https://cli.github.com/manual
- GitHub Projects V2: https://docs.github.com/ja/issues/planning-and-tracking-with-projects
- GraphQL API: https://docs.github.com/ja/graphql
- jqマニュアル: https://stedolan.github.io/jq/manual/

## サポート

問題が発生した場合：

1. `.claude/`ディレクトリの関連ログファイルを確認
2. 上記のトラブルシューティングセクションをレビュー
3. `test-setup.sh`で個別コンポーネントをテスト
4. GitHub APIステータスを確認: https://www.githubstatus.com/
