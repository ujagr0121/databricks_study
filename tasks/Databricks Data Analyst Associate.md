**Databricks Data Analyst Associate** を対象に、

* **記述は一切省略せず**
* **GitHub Issue にそのまま登録できる粒度**
* **1 Issue = 1〜2時間**
* **Markdown 形式**

で、**完全版の学習計画（Issue 定義）**を出力します。
（これもそのまま Codex → `gh` スクリプト化可能です）

---

# Databricks Data Analyst Associate

## 学習計画（Issue 完全版 / Markdown）

> 期間目安：4〜5週間
> 前提：
>
> * SQL は基本的な読み書きが可能
> * Python 不要
> * Spark の内部理解は不要（SQL中心）
>
> ゴール：
> **「Databricks SQL を使って、分析・可視化・共有までを一貫して実行・説明できる」状態**

---

## W1：Databricks SQL & Analyst の役割理解

### Issue 1-1：Data Analyst Associate の役割と試験範囲を理解する

* **Type**: study
* **Track**: Analytics
* **Estimate**: 1.0h
* **目的**
  Data Analyst Associate が想定する業務範囲と責任を理解する。
* **作業内容**

  * Data Analyst の役割整理
  * DE / ML との役割分担を整理
  * Exam Guide を通読
* **完了条件**

  * 試験の出題カテゴリをすべて列挙できる
* **成果物**

  * Markdown メモ（200〜300字）

---

### Issue 1-2：Databricks SQL の全体像を理解する

* **Type**: study
* **Estimate**: 1.0h
* **目的**
  Databricks SQL が何を提供するサービスかを理解する。
* **作業内容**

  * Databricks SQL の位置づけ
  * Notebook / SQL Editor / Dashboard の関係整理
* **完了条件**

  * Databricks SQL の構成要素を説明できる

---

### Issue 1-3：SQL Warehouse の概念を理解する

* **Type**: study
* **Estimate**: 1.0h
* **目的**
  クエリ実行基盤としての SQL Warehouse を理解する。
* **作業内容**

  * SQL Warehouse の役割
  * Cluster との違い
* **完了条件**

  * なぜ Analyst が Warehouse を使うのか説明できる

---

## W2：Databricks SQL による分析クエリ

### Issue 2-1：Databricks SQL の基本構文を確認する

* **Type**: study
* **Estimate**: 1.0h
* **目的**
  Databricks SQL の基本操作を確認する。
* **作業内容**

  * SELECT / WHERE / ORDER BY / LIMIT
  * DISTINCT
* **完了条件**

  * SQL Editor 上でクエリを実行できる

---

### Issue 2-2：JOIN と集計を使った分析クエリを実行する

* **Type**: handson
* **Estimate**: 2.0h
* **目的**
  分析で頻出する操作を実践する。
* **作業内容**

  * INNER / LEFT JOIN
  * GROUP BY / COUNT / SUM / AVG
* **完了条件**

  * 複数テーブルを使った集計ができる
* **成果物**

  * SQL クエリ（保存）

---

### Issue 2-3：Window 関数を用いた分析を理解する

* **Type**: study
* **Estimate**: 1.0h
* **目的**
  時系列・ランキング分析を理解する。
* **作業内容**

  * OVER / PARTITION BY / ORDER BY
  * RANK / ROW_NUMBER
* **完了条件**

  * Window 関数の用途を説明できる

---

## W3：可視化とダッシュボード

### Issue 3-1：Databricks SQL の可視化機能を理解する

* **Type**: study
* **Estimate**: 1.0h
* **目的**
  クエリ結果を可視化する機能を理解する。
* **作業内容**

  * グラフ種別
  * 可視化設定
* **完了条件**

  * 可視化の種類と用途を説明できる

---

### Issue 3-2：クエリ結果をグラフとして可視化する

* **Type**: handson
* **Estimate**: 1.5h
* **目的**
  SQL 結果を可視化に落とす。
* **作業内容**

  * 棒グラフ
  * 折れ線グラフ
  * 円グラフ
* **完了条件**

  * 適切なグラフを選択できる
* **成果物**

  * 保存された可視化

---

### Issue 3-3：ダッシュボードを作成する

* **Type**: handson
* **Estimate**: 2.0h
* **目的**
  分析結果をまとめて共有する。
* **作業内容**

  * 複数可視化を配置
  * レイアウト調整
* **完了条件**

  * ダッシュボードが完成している
* **成果物**

  * ダッシュボードURL

---

## W4：データモデル・品質・共有

### Issue 4-1：分析向けデータモデルを理解する

* **Type**: study
* **Estimate**: 1.0h
* **目的**
  分析しやすいデータ構造を理解する。
* **作業内容**

  * ファクト / ディメンション
  * 正規化 / 非正規化
* **完了条件**

  * 分析用モデルの特徴を説明できる

---

### Issue 4-2：分析結果の正しさを確認する

* **Type**: study
* **Estimate**: 1.0h
* **目的**
  数値の妥当性を検証する視点を持つ。
* **作業内容**

  * 件数チェック
  * NULL の扱い
* **完了条件**

  * よくある分析ミスを3つ挙げられる

---

### Issue 4-3：ダッシュボードを共有する

* **Type**: handson
* **Estimate**: 1.0h
* **目的**
  他者に安全に共有する。
* **作業内容**

  * 権限設定
  * 共有方法確認
* **完了条件**

  * 閲覧専用で共有できる

---

## W5：試験対策と総仕上げ

### Issue 5-1：Exam Guide の最終確認

* **Type**: study
* **Estimate**: 1.0h
* **目的**
  出題範囲を完全に把握する。
* **作業内容**

  * 出題カテゴリチェック
* **完了条件**

  * 未学習分野が無い状態

---

### Issue 5-2：サンプル問題演習

* **Type**: study
* **Estimate**: 2.0h
* **目的**
  問題形式と出題意図に慣れる。
* **作業内容**

  * 正答・誤答理由整理
* **完了条件**

  * 選択肢の是非を説明できる

---

### Issue 5-3：分析ユースケースまとめ

* **Type**: deliverable
* **Estimate**: 1.5h
* **目的**
  Analyst としての成果物を整理する。
* **作業内容**

  * 分析目的
  * SQL
  * 可視化
  * 共有
* **完了条件**

  * 一連の流れを説明できる
* **成果物**

  * Markdown ドキュメント
