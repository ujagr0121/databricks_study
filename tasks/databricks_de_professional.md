了解です。
では **「Academy Labs 前提・12週間ロードマップ」を GitHub Issue 化するための“設計確定版”** を出します。
このまま **Codex → gh スクリプト生成** に流せる粒度です。

以下は **設計書ではなく「管理に耐える Issue 定義」** になっています。

---

# Project 前提（再確認・固定）

* Project名：`Databricks DE Professional Roadmap`
* 期間：12週間
* 進め方：**Issue駆動 / 成果物重視 / Labs併用**
* 1 Issue = 1〜2時間（重すぎない）

---

# W1–W12 Issue 一覧（確定版）

## W1：Databricks全体像を掴む（概念フェーズ）

**目的**：Databricksを「説明できる」状態になる

1. Databricks Lakehouseの全体構成を理解する

   * type:study / track:Common / est:1.5h
   * 完了条件：Lakehouse構成図を自分の言葉で説明できる

2. Databricks主要コンポーネント整理（DBFS / Workspace / Cluster）

   * est:1h
   * 成果物：Markdown 1枚

3. DE / ML / Analytics の役割差を整理

   * est:1h
   * 成果物：「どこまでDEが責任を持つか」メモ

4. Data Engineer Professional Exam Guide 通読

   * est:2h
   * 完了条件：出題カテゴリを列挙できる

5. GitHub Repo に学習ログ用 README 作成

   * type:deliverable / est:1h

---

## W2：Spark SQL 最小セット

**目的**：SparkをSQLで使える状態にする

1. Spark SQL 基本文法（SELECT/JOIN/AGG）

   * topic:spark-sql / est:1.5h

2. Delta Table の正体を理解

   * topic:delta / est:1h

3. CSV → Delta → 集計の一連処理

   * type:handson / est:2h
   * 成果物：Notebook

4. Spark SQL と RDB SQL の違い整理

   * est:1h

---

## W3：DataFrameとPython最小理解

**目的**：Pythonを「書けなくても使える」状態に

1. DataFrame API の役割理解

   * est:1h

2. SQL ⇄ DataFrame 対応関係を整理

   * est:1h

3. DataFrameでの集計処理実装

   * type:handson / est:2h

4. Python文法の「読解用最小セット」整理

   * est:1h

---

## W4：データ収集（Ingestion）

**目的**：データを「安全に集める」設計ができる

1. Auto Loader の仕組み理解

   * topic:delta / est:1h

2. バッチ vs ストリーミング判断軸整理

   * est:1h

3. Auto Loader ハンズオン

   * type:handson / est:2h

4. 収集方式の設計パターンまとめ

   * type:deliverable / est:1h

---

## W5：変換・品質・冪等性

**目的**：壊れないパイプラインを作る

1. データ品質チェック設計

   * est:1h

2. 不正データ隔離パターン

   * est:1h

3. 冪等なパイプライン実装

   * type:handson / est:2h

4. 再実行戦略まとめ

   * est:1h

---

## W6：Lakeflow & Jobs

**目的**：本番運用できる形にする

1. Lakeflow Spark Declarative Pipelines 理解

   * topic:jobs / est:1h

2. Jobs の構成要素理解

   * est:1h

3. パイプライン + Job 実装

   * type:handson / est:2h

4. 失敗時の挙動整理

   * est:1h

---

## W7：Unity Catalog（ガバナンス）

**目的**：「安全に使わせる」基盤を作る

1. Unity Catalog の思想理解

   * topic:unity-catalog / est:1h

2. スキーマ/権限設計

   * est:1h

3. 行・列レベル制御実装

   * type:handson / est:2h

4. ガバナンス設計まとめ

   * type:deliverable / est:1h

---

## W8：データ共有

**目的**：組織外/部門間共有を説明できる

1. Delta Sharing 理解

   * est:1h

2. Lakehouse Federation 理解

   * est:1h

3. 共有方式の使い分け整理

   * type:deliverable / est:1h

---

## W9：パフォーマンス最適化

**目的**：遅い理由を説明できる

1. Spark性能劣化パターン整理

   * topic:perf-cost / est:1h

2. Query Profile の使い方

   * est:1h

3. クラスタ構成とコストの関係

   * est:1h

---

## W10：運用監視・コスト

**目的**：お金の話ができる

1. system tables 理解

   * est:1h

2. ジョブ実行コスト分析

   * type:handson / est:2h

3. コスト削減ポイント整理

   * type:deliverable / est:1h

---

## W11：IaC・自動化

**目的**：再現可能な構築

1. Databricks Asset Bundles 理解

   * est:1h

2. CLI / デプロイフロー整理

   * est:1h

3. 簡易Bundle作成

   * type:handson / est:2h

---

## W12：試験対策＋統合

**目的**：合格＋提案力

1. Exam Guide 要件再整理

   * est:1h

2. サンプル問題演習

   * est:2h

3. 架空案件の構成提案作成

   * type:deliverable / est:2h
