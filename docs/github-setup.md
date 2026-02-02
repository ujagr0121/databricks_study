# GitHub Projects V2 設定ガイド

GitHub Projects V2のセットアップ、カスタムフィールド、GraphQL統合の詳細リファレンス。

## 概要

このシステムはGitHub Projects V2を学習タスクの視覚的ダッシュボードとして使用します。Projects V2が提供する機能：

- Kanbanボードビュー（Status列）
- メタデータ用のカスタムフィールド（Week、Track、Priority、Estimate、Outcome）
- Issue統合
- フィルタリングとグループ化
- GraphQL APIアクセス

---

## 手動フィールド作成

GraphQL APIはフィールド作成をサポートしていないため、GitHub UIで手動で作成する必要があります。

### Projectセッティングへアクセス

1. アクセス: https://github.com/ujagr0121/databricks_study
2. クリック: Projectsタブ
3. クリック: "Databricks DE Professional Roadmap"
4. クリック: Settings（歯車アイコン、右上）

### 単一選択フィールドを作成

**Statusフィールド:**
1. クリック: "New Field" → "Single select"
2. 名前: `Status`
3. オプション:
   - `Todo` （色: gray）
   - `Doing` （色: yellow）
   - `Done` （色: green）
   - `Blocked` （色: red）
4. 保存

**Weekフィールド:**
1. クリック: "New Field" → "Single select"
2. 名前: `Week`
3. オプション: `W1`, `W2`, `W3`, ..., `W12`
4. 保存

**Trackフィールド:**
1. クリック: "New Field" → "Single select"
2. 名前: `Track`
3. オプション:
   - `Common` （すべての学習者に適用）
   - `DE` （データエンジニアリング集中）
   - `ML` （機械学習集中）
4. 保存

**Priorityフィールド:**
1. クリック: "New Field" → "Single select"
2. 名前: `Priority`
3. オプション: `P0` （重要）、`P1` （高）、`P2` （中）
4. 保存

### 数値フィールドを作成

**Estimateフィールド:**
1. クリック: "New Field" → "Number"
2. 名前: `Estimate`
3. 説明: "このタスクの推定時間"
4. 保存

### テキストフィールドを作成

**Outcomeフィールド:**
1. クリック: "New Field" → "Text"
2. 名前: `Outcome`
3. 説明: "完了ノートと成果"
4. 保存（制限: 255文字）

### フィールド設定完了

すべてのフィールド作成後:

1. プロジェクトボードに戻る
2. すべてのフィールドが列またはタスク詳細に表示されるはず
3. 実行: `bash scripts/github/lib/fields.sh refresh_field_cache`
4. キャッシュ更新を確認: `.claude/github-field-cache.json`

---

## フィールドIDの理解

GraphQLはカスタムフィールド更新にフィールドID（UUID）を使用します。システムはAPI呼び出しを最小化するためこれらのIDをキャッシュします。

### フィールドIDキャッシュ構造

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

### キャッシュのリフレッシュ

フィールド変更時（新しいオプション追加など）:

```bash
source scripts/github/lib/fields.sh
refresh_field_cache <project_id>

# キャッシュを確認
cat .claude/github-field-cache.json | jq '.fields | keys'
```

---

## GraphQL APIリファレンス

### 認証

すべてのGraphQLクエリは`gh api graphql`を使用:

```bash
gh api graphql -f query='...'  # ファイル内容
gh api graphql -f query@file   # ファイルから
```

GitHub認証情報が自動的に使用されます。

### コアクエリ

#### Project IDを取得

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

#### Projectのフィールド IDを取得

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

#### Project内のIssueを取得

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

#### カスタムフィールド付きIssueを取得

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

### ミューテーション

#### IssueをProjectに追加

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

#### 単一選択フィールドを更新

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

#### テキストフィールドを更新

```graphql
mutation {
  updateProjectV2ItemFieldValue(input: {
    projectId: "PROJECT_ID"
    itemId: "ITEM_ID"
    fieldId: "FIELD_ID"
    value: { text: "ここにテキスト" }
  }) {
    projectV2Item {
      id
    }
  }
}
```

#### 数値フィールドを更新

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

GitHubのGraphQL Explorerを使用してクエリをデバッグおよびテスト:

1. アクセス: https://docs.github.com/ja/graphql/overview/explorer
2. GitHubアカウントで認証
3. クエリを記述してテスト
4. 「Play」ボタンをクリックして実行
5. 右パネルで結果を表示
6. 必要に応じてクエリを改良
7. 動作したらシェルスクリプトにコピー

### ワークフロー例

```
1. Explorerを開く
2. クエリを記述
3. 「Play」ボタンをクリックして実行
4. 右パネルで結果を表示
5. 必要に応じてクエリを改良
6. 動作したらシェルスクリプトにコピー
```

---

## フィールド管理ヘルパー

### すべてのキャッシュされたフィールドをリスト

```bash
source scripts/github/lib/fields.sh
list_cached_fields

# 出力:
# Cached fields from: 2026-02-02T23:30:00Z
# Status
# Week
# Track
# Priority
# Estimate
# Outcome
```

### フィールドIDを取得

```bash
source scripts/github/lib/fields.sh
get_cached_field_id "Status"
# 出力: PVTF_lADOBEEX...
```

### オプションIDを取得

```bash
source scripts/github/lib/fields.sh
get_cached_option_id "Status" "Done"
# 出力: PVTSSF_...
```

### フィールドオプションをリスト

```bash
source scripts/github/lib/fields.sh
list_field_options "Week"

# 出力:
# W1
# W2
# W3
# ...
```

---

## カスタムフィールド更新

### Skill経由で更新

推奨される方法はキャッシングを処理するSkillsを使用することです:

```bash
/register-task tasks/week01/task-01.md
# 自動設定: Status、Week、Track、Estimate、Priority

/update-progress tasks/week01/task-01.md
# 更新: 変更された場合はStatus、Outcome
```

### GitHub Project UI経由で更新

Projectボードでの手動更新:

1. タスクをクリック
2. 右パネルでカスタムフィールドを編集
3. 変更は即座に反映

### gh CLI経由で更新

直接Issue更新:

```bash
# ラベルを追加
gh issue edit 1 --add-label spark-sql

# クローズ/再オープン
gh issue close 1
gh issue reopen 1

# コメントを追加
gh issue comment 1 --body "進捗更新..."
```

### GraphQL経由で更新

複雑なフィールド更新の場合:

```bash
# 最初に必要なIDを取得
PROJECT_ID="..."
ITEM_ID="..."
FIELD_ID="..."
OPTION_ID="..."

# 次に更新
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

## トラブルシューティング

### フィールドキャッシュが同期していない

フィールドIDが変更された場合（手動更新）:

```bash
# GitHubからリフレッシュ
source scripts/github/lib/fields.sh
PROJECT_ID=$(jq -r '.project_id' .claude/github-field-cache.json)
refresh_field_cache "$PROJECT_ID"

# 確認
show_cache_info
```

### "Field not found" エラー

フィールドがプロジェクトに存在しません:

```bash
# 実際のフィールドをリスト
show_cache_info

# または直接クエリ:
gh api graphql -f query='...' | jq '.data.node.fields.nodes'

# 次にUIで不足しているフィールドを手動で作成
```

### "Invalid option ID" エラー

フィールドにオプションが存在しません:

```bash
# 利用可能なオプションをリスト
list_field_options "Status"

# Project Settingsで不足しているオプションを追加
```

### GraphQLクエリエラー

完全なAPIレスポンスを表示するために`--debug`フラグを使用:

```bash
gh api graphql --debug -f query='...'

# 一般的なエラー:
# - Node ID not found: PROJECT_ID、ITEM_IDフォーマットを確認
# - Permission denied: Personal Access Tokenスコープを確認
# - Invalid value: フィールドタイプを確認（singleSelect vs text vs number）
```

### APIレート制限

レート制限に達した場合:

```bash
# 現在のレート制限を確認
gh api rate_limit

# リセットタイミング
gh api rate_limit | jq '.rate.reset | todate'
```

解決策:
- リクエストを最小化するためフィールドIDキャッシュを使用
- `/sync-week`でバッチ更新
- レート制限リセットを待つ（1時間）

---

## ベストプラクティス

1. **キャッシュ優先**: API呼び出しを最小化するため、常にキャッシュされたフィールドIDを使用
2. **定期的にリフレッシュ**: 手動Project変更後に`refresh_field_cache`を実行
3. **入力を検証**: フィールド更新前にオプションIDを確認
4. **バッチ操作**: 複数タスクには`/sync-week`を使用
5. **レート制限を監視**: API使用状況を把握
6. **秘密を安全に保管**: Personal Access Tokenを絶対にコミットしない
7. **クエリをテスト**: スクリプト化前にGraphQL Explorerを使用

---

## 高度な機能

### Projectビュー

GitHub Projects V2は複数のビューをサポート:

1. **テーブルビュー**: スプレッドシートのようなレイアウト
2. **ボードビュー**: Kanban列（デフォルト）
3. **カスタムフィールド**: Week、Trackなどでグループ化

アクセス: Projectの設定 → Views

### 自動化（今後）

以下のためのGitHub Actionsを検討:
- 新しいIssueをProjectに自動追加
- Issueラベルに基づいてフィールドを自動更新
- 週次同期レポート

### 他のツールとの統合

可能な統合:
- Issue更新時のSlack通知
- タスク期限のカレンダー同期
- 学習連続記録のハビットトラッカー

---

## リファレンス

- GitHub Projects V2ドキュメント: https://docs.github.com/ja/issues/planning-and-tracking-with-projects/learning-about-projects
- GraphQL API: https://docs.github.com/ja/graphql
- カスタムフィールド: https://docs.github.com/ja/issues/planning-and-tracking-with-projects/understanding-fields
- gh CLI: https://cli.github.com/manual
