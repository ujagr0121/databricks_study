# Databricks DE Professional 認定試験 - 学習進捗管理システム

Databricks Data Engineer Professional 認定試験の学習進捗を追跡するための包括的な学習管理システム。ローカルMarkdownファイルを真実の源（Single Source of Truth）とし、カスタムSkillsとSubagentsを介してGitHub Projects (V2)に同期します。

## 概要

このシステムが提供する機能：

- **ローカルMarkdownファイル**: 学習目標、進捗追跡、成果を移植可能なMarkdown形式で管理
- **GitHub Projects統合**: カスタムフィールド（ステータス、週、トラック、見積時間、優先度）を持つ視覚的なタスクボード
- **カスタムSkills**: `/register-task`、`/update-progress`、`/sync-week`でGitHub同期を実現
- **AIサブエージェント**: カリキュラム設計用の`learning-planner`、分析用の`progress-analyzer`
- **構造化された追跡**: 12週間の学習計画で約50-100のタスクをCommon、DE、MLトラックに分類

## 前提条件

- **GitHubアカウント**: 個人アカウント (ujagr0121)
- **GitHub CLI**: `brew install gh` (またはお使いのパッケージマネージャー)
- **jq**: `brew install jq` (JSON解析用)
- **Personal Access Token**: RepoとProjectの権限

## クイックスタート

### 1. 初期セットアップ

```bash
# GitHub Personal Access Tokenを作成
# https://github.com/settings/tokens にアクセス
# 権限: repo, project

# GitHub CLIで認証
gh auth login

# セットアップスクリプトを実行してProjectとラベルを作成
bash scripts/github/setup-project.sh

# Projectが作成されたことを確認
gh project list
```

### 2. 最初のタスクを作成

```bash
# Week 1、Task 1のテンプレートをコピー
cp tasks/template.md tasks/week01/task-01-spark-basics.md

# 学習目標を記入してファイルを編集
# week: W1
# track: DE
# title: "Spark SQL基礎"
# estimate: 6

# GitHubに登録
/register-task tasks/week01/task-01-spark-basics.md
```

### 3. 進捗を記録

```bash
# ローカルMarkdownファイルに学習ノートを追加
# その後GitHubに同期

/update-progress tasks/week01/task-01-spark-basics.md
```

### 4. GitHubで確認

```bash
# GitHub Projectボードを開く
gh project view 1 --web

# または特定のIssueを確認
gh issue view <番号>
```

## ディレクトリ構造

```
databricks_study/
├── .claude/                    # Claude Code設定
│   ├── settings.local.json     # 権限と実行設定
│   ├── github-field-cache.json # キャッシュされたフィールドID（自動生成）
│   ├── agents/                 # サブエージェント定義
│   │   ├── learning-planner.md
│   │   └── progress-analyzer.md
│   └── skills/                 # カスタムSkills
│       ├── register-task/
│       ├── update-progress/
│       └── sync-week/
│
├── scripts/                    # 共有ユーティリティスクリプト
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
├── tasks/                      # 学習タスク（真実の源）
│   ├── template.md
│   ├── week01/ ... week12/
│
├── docs/                       # ドキュメント
│   ├── setup.md
│   ├── workflow.md
│   └── github-setup.md
│
├── management.toml             # Claude Code設定
├── .gitignore
└── README.md
```

## 利用可能なコマンド

### Skills

- **`/register-task <パス>`**: ローカルタスクをGitHub IssueとProjectに登録
  ```bash
  /register-task tasks/week01/task-01-spark-basics.md
  ```

- **`/update-progress <パス>`**: 学習進捗をIssueに同期
  ```bash
  /update-progress tasks/week01/task-01-spark-basics.md
  ```

- **`/sync-week <週>`**: 週のすべてのタスクを一括同期
  ```bash
  /sync-week W1
  ```

### Agents（エージェント）

- **`learning-planner`**: 学習カリキュラムを設計
  ```
  Week 1と2のSpark SQL基礎の学習タスクを計画してください
  ```

- **`progress-analyzer`**: 学習進捗を分析
  ```
  Week 1の進捗を分析して、調整案を提示してください
  ```

## ワークフローの例

### 新しい週を開始する

1. 週の目標を指定して`learning-planner`エージェントを実行
2. `tasks/weekXX/`に生成されたMarkdownファイルをレビュー
3. `/register-task`でタスクを登録
4. 必要に応じてGitHub Project UIでタスクメタデータを更新

### 日々の学習

1. ローカルMarkdownファイル（`tasks/weekXX/task-XX.md`）を開く
2. 「学習記録」セクションに日付スタンプ付きで学習ノートを追加
3. YAMLフロントマターでステータスを更新（Todo → Doing → Done）
4. `/update-progress`を実行してIssueに同期

### 週次レビュー

1. `/sync-week W1`を実行してすべてのタスクを一括更新
2. `progress-analyzer`を実行して洞察を取得
3. メトリクスをレビュー: 速度、トピックバランス、見積精度
4. 次週の調整を計画

## 主要な概念

### タスク構造

各タスクはYAMLフロントマター付きのMarkdownファイルです：

```yaml
---
week: W1
track: DE
title: "Spark SQL基礎"
estimate: 6
priority: P1
status: Todo
labels: [study, spark-sql]
github_issue: "https://github.com/ujagr0121/databricks_study/issues/1"
---

# 学習目標
- Spark SQLアーキテクチャを理解する
- DataFrame APIをマスターする
- クエリ最適化を実践する

# 学習記録
## 2026-02-02
- Spark SQLの概要を完了
- 2時間実施

# アウトカム
（完了後に更新）
```

### GitHub Projectフィールド

自動管理されるカスタムフィールド：

- **Status**: Todo, Doing, Done, Blocked
- **Week**: W1-W12
- **Track**: Common, DE, ML
- **Estimate**: 時間数（数値）
- **Priority**: P0, P1, P2
- **Outcome**: 完了ノート用のテキストフィールド

### ローカルMarkdown = 真実の源

- GitHub Issueは読み取り専用ビュー
- すべての編集はローカルMarkdownで実施
- Skillsは更新をGitHubにプッシュ（一方向同期）
- オフライン作業を可能にし、バージョン管理と親和性が高い

## ドキュメント

- **[setup.md](docs/setup.md)**: 詳細なセットアップガイド
- **[workflow.md](docs/workflow.md)**: 日常ワークフローリファレンス
- **[github-setup.md](docs/github-setup.md)**: GitHub Projects設定詳細

## サポート

問題や質問については：
- [docs/github-setup.md](docs/github-setup.md)のトラブルシューティングセクションを確認
- Skillログをレビュー: `.claude/`ディレクトリのエラーログを確認
- GitHub APIエラー: `gh api graphql --debug`を使用

## 今後の機能強化

- Issue→Project自動同期のためのGitHub Actions
- 週次メトリクス付きのダッシュボード生成
- 学習成果物（ノートブック、クエリ）との統合
- マルチワークスペースサポート用のCodex統合

## ライセンス

個人学習プロジェクト - プライベート利用のみ
