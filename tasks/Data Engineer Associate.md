了解しました。
ここでは **Databricks Data Engineer Associate** を対象に、

* 記述は**一切省略せず**
* **GitHub Issue にそのまま使える粒度**
* **Markdown 形式**

で **完全版の学習計画（Issue 定義）** を出力します。
このまま **Codex → gh スクリプト化**が可能です。

---

# Databricks Data Engineer Associate

## 学習計画（Issue 完全版 / Markdown）

> 期間目安：6週間
> 前提：Spark未経験／SQLは実務レベル
> 1 Issue = 1〜2時間

---

## W1：Databricks と Spark の全体像

### Issue 1-1：Databricks の基本コンセプトを理解する

* **Type**: study
* **Track**: DE
* **Estimate**: 1.0h
* **目的**
  Databricks が解決しようとしている課題と、Lakehouse の思想を理解する。
* **作業内容**

  * Lakehouse とは何かを調べる
  * DWH + Data Lake 構成との違いを整理
* **完了条件**

  * 「なぜ Databricks を使うのか」を文章で説明できる
* **成果物**

  * Markdown メモ（200〜300字）

---

### Issue 1-2：Spark の役割と実行モデルを理解する

* **Type**: study
* **Estimate**: 1.0h
* **目的**
  Spark が何をしているエンジンなのかを概念レベルで理解する。
* **作業内容**

  * Spark = 分散処理エンジンである理由を調査
  * Driver / Executor / Cluster の役割整理
* **完了条件**

  * 「Spark が速い理由」を3点で説明できる

---

### Issue 1-3：Databricks Workspace を操作する

* **Type**: handson
* **Estimate**: 1.5h
* **目的**
  Databricks の基本UI操作に慣れる。
* **作業内容**

  * Workspace を開く
  * Notebook を作成
  * セル実行・保存
* **完了条件**

  * Notebook を自分で作成・実行できる

---

### Issue 1-4：Cluster の概念を理解する

* **Type**: study
* **Estimate**: 1.0h
* **目的**
  Databricks における計算資源の扱いを理解する。
* **作業内容**

  * All-purpose cluster / Job cluster の違い整理
  * オートスケールの考え方を確認
* **完了条件**

  * Cluster 種別の使い分けを説明できる

---

## W2：Spark SQL 基礎

### Issue 2-1：Spark SQL の基本構文を理解する

* **Type**: study
* **Topic**: spark-sql
* **Estimate**: 1.0h
* **目的**
  Spark SQL が通常の SQL とどう違うかを理解する。
* **作業内容**

  * SELECT / WHERE / ORDER BY
  * LIMIT / DISTINCT
* **完了条件**

  * 基本クエリを Notebook 上で実行できる

---

### Issue 2-2：JOIN と集計を Spark SQL で実行する

* **Type**: handson
* **Estimate**: 2.0h
* **目的**
  実務で最も使うクエリ操作を Spark 上で行う。
* **作業内容**

  * INNER / LEFT JOIN
  * GROUP BY / COUNT / SUM
* **完了条件**

  * JOIN + 集計クエリを実行できる

---

### Issue 2-3：Window 関数を理解する

* **Type**: study
* **Estimate**: 1.0h
* **目的**
  Spark SQL における Window 処理を理解する。
* **作業内容**

  * OVER / PARTITION BY / ORDER BY
* **完了条件**

  * Window 関数の用途を説明できる

---

### Issue 2-4：Spark SQL と RDB SQL の違いを整理する

* **Type**: deliverable
* **Estimate**: 1.0h
* **目的**
  分散SQLの制約を理解する。
* **作業内容**

  * トランザクションの違い
  * インデックスの考え方の違い
* **完了条件**

  * 違いを表形式で整理できている

---

## W3：Delta Lake

### Issue 3-1：Delta Lake の基本概念を理解する

* **Type**: study
* **Topic**: delta
* **Estimate**: 1.0h
* **目的**
  Delta Lake が何を解決しているかを理解する。
* **作業内容**

  * ACID
  * バージョン管理
* **完了条件**

  * Delta Lake の利点を3点挙げられる

---

### Issue 3-2：Delta Table を作成する

* **Type**: handson
* **Estimate**: 1.5h
* **目的**
  Delta Table を実際に作成する。
* **作業内容**

  * CSV → Delta Table 変換
  * テーブル参照
* **完了条件**

  * Delta Table を SQL で参照できる

---

### Issue 3-3：UPDATE / DELETE / MERGE を理解する

* **Type**: handson
* **Estimate**: 1.5h
* **目的**
  Delta の更新系操作を理解する。
* **作業内容**

  * UPDATE
  * DELETE
  * MERGE INTO
* **完了条件**

  * MERGE が何に使われるか説明できる

---

## W4：データ取り込み

### Issue 4-1：ファイルデータの読み込み

* **Type**: handson
* **Estimate**: 1.5h
* **目的**
  外部データを Spark に取り込む。
* **作業内容**

  * CSV / JSON 読み込み
  * スキーマ指定
* **完了条件**

  * DataFrame として読み込める

---

### Issue 4-2：基本的なETLフローを作る

* **Type**: handson
* **Estimate**: 2.0h
* **目的**
  ETL の基本構造を理解する。
* **作業内容**

  * 読み込み
  * 変換
  * 保存
* **完了条件**

  * ETL 処理が一通り動く

---

## W5：ジョブ実行と運用基礎

### Issue 5-1：Notebook を Job として実行する

* **Type**: handson
* **Topic**: jobs
* **Estimate**: 1.5h
* **目的**
  バッチ処理として実行できるようにする。
* **作業内容**

  * Job 作成
  * スケジュール設定
* **完了条件**

  * 定期実行できる

---

### Issue 5-2：失敗時の挙動を確認する

* **Type**: study
* **Estimate**: 1.0h
* **目的**
  ジョブ失敗時の考え方を理解する。
* **作業内容**

  * Retry
  * エラーログ
* **完了条件**

  * 再実行時の注意点を説明できる

---

## W6：試験対策と総仕上げ

### Issue 6-1：Exam Guide を精読する

* **Type**: study
* **Estimate**: 1.5h
* **目的**
  出題範囲を漏れなく確認する。
* **作業内容**

  * 出題カテゴリ一覧化
* **完了条件**

  * 出題分野をすべて列挙できる

---

### Issue 6-2：サンプル問題を解く

* **Type**: study
* **Estimate**: 2.0h
* **目的**
  問題形式に慣れる。
* **作業内容**

  * 正答理由の言語化
* **完了条件**

  * すべての選択肢の是非を説明できる

---

### Issue 6-3：総復習メモ作成

* **Type**: deliverable
* **Estimate**: 1.5h
* **目的**
  知識を定着させる。
* **作業内容**

  * 重要ポイントまとめ
* **完了条件**

  * A4 2枚以内に整理されている
