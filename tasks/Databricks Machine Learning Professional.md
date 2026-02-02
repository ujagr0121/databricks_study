**Databricks Machine Learning Professional** を、

* **記述は一切省略せず**
* **GitHub Issue にそのまま登録できる粒度**
* **1 Issue = 1〜2時間**
* **Markdown 形式**

で **完全版の学習計画（Issue 定義）**として出力します。
（このまま Codex → `gh` スクリプト化できます）

---

# Databricks Machine Learning Professional

## 学習計画（Issue 完全版 / Markdown）

> 期間目安：8週間
> 前提：
>
> * Machine Learning Associate 相当の理解がある
> * Pythonは「読める・軽微な修正ができる」
> * アルゴリズム実装力より **設計・選択・運用判断**を重視
>
> ゴール：
> **「MLを業務システムとして設計・運用・改善する判断ができる」状態**

---

## W1：MLシステム全体設計（最重要）

### Issue 1-1：MLシステムの全体構成を整理する

* **Type**: study
* **Track**: ML
* **Estimate**: 1.5h
* **目的**
  ML を「1本の処理」ではなく「システム」として捉える。
* **作業内容**

  * データ収集
  * 特徴量生成
  * 学習
  * 推論
  * 監視
    の一連の流れを整理
* **完了条件**

  * MLシステム構成図を自分で描ける
* **成果物**

  * 構成図（Markdown + 図）

---

### Issue 1-2：Databricks における ML アーキテクチャを理解する

* **Type**: study
* **Estimate**: 1.0h
* **目的**
  Databricks が ML プラットフォームとして提供する要素を理解する。
* **作業内容**

  * Spark
  * MLflow
  * Feature Store
  * Model Serving
  * Unity Catalog
* **完了条件**

  * 各コンポーネントの役割を説明できる

---

### Issue 1-3：ML Professional 試験の出題範囲を把握する

* **Type**: study
* **Estimate**: 1.0h
* **目的**
  学習のスコープを明確にする。
* **作業内容**

  * Exam Guide 通読
  * 出題カテゴリ整理
* **完了条件**

  * 出題分野をすべて列挙できる

---

## W2：分散学習とスケーリング

### Issue 2-1：分散学習が必要になるケースを理解する

* **Type**: study
* **Estimate**: 1.0h
* **目的**
  なぜ単一ノードでは足りないかを理解する。
* **作業内容**

  * データサイズ
  * モデルサイズ
  * 学習時間
* **完了条件**

  * 分散学習が必要な条件を説明できる

---

### Issue 2-2：Spark による分散学習の考え方を理解する

* **Type**: study
* **Estimate**: 1.0h
* **目的**
  Spark での分散処理と ML の関係を理解する。
* **作業内容**

  * データ並列
  * パラメータ共有の概念
* **完了条件**

  * Spark ML がスケールする理由を説明できる

---

### Issue 2-3：Optuna / Ray の役割と使い分けを整理する

* **Type**: study
* **Estimate**: 1.5h
* **目的**
  ハイパーパラメータ探索の設計判断をできるようにする。
* **作業内容**

  * Optuna の用途
  * Ray の用途
  * Spark ML との違い
* **完了条件**

  * ケース別に選択理由を説明できる

---

## W3：MLflow Advanced（実験管理の中核）

### Issue 3-1：MLflow の高度な機能を理解する

* **Type**: study
* **Topic**: mlflow
* **Estimate**: 1.5h
* **目的**
  実験管理を「業務レベル」に引き上げる。
* **作業内容**

  * Nested Runs
  * Tags
  * Artifacts
* **完了条件**

  * 複雑な実験構造を説明できる

---

### Issue 3-2：MLflow Model Registry を理解する

* **Type**: study
* **Estimate**: 1.0h
* **目的**
  モデルのライフサイクル管理を理解する。
* **作業内容**

  * Staging / Production
  * モデル昇格フロー
* **完了条件**

  * 本番移行の判断基準を説明できる

---

### Issue 3-3：実験から登録までの一連フローを整理する

* **Type**: deliverable
* **Estimate**: 1.5h
* **目的**
  MLflow を用いた標準フローを確立する。
* **作業内容**

  * 実験
  * 比較
  * 登録
* **完了条件**

  * 再現可能な手順書が完成している
* **成果物**

  * Markdown ドキュメント

---

## W4：Feature Store と特徴量管理

### Issue 4-1：Feature Store の必要性を理解する

* **Type**: study
* **Estimate**: 1.0h
* **目的**
  特徴量を「再利用資産」として扱う。
* **作業内容**

  * 学習・推論の乖離問題
  * 特徴量の一元管理
* **完了条件**

  * Feature Store が必要な理由を説明できる

---

### Issue 4-2：Databricks Feature Store の構成を理解する

* **Type**: study
* **Estimate**: 1.0h
* **目的**
  Databricks Feature Store の仕組みを理解する。
* **作業内容**

  * Feature Table
  * オンライン / オフライン
* **完了条件**

  * Feature Store の利用フローを説明できる

---

### Issue 4-3：特徴量管理の設計方針をまとめる

* **Type**: deliverable
* **Estimate**: 1.5h
* **目的**
  プロジェクトでの特徴量管理方針を決める。
* **作業内容**

  * 命名
  * 更新頻度
  * 責任分界
* **完了条件**

  * 設計方針が文章化されている

---

## W5：モデルデプロイと Serving

### Issue 5-1：モデルデプロイ方式を整理する

* **Type**: study
* **Estimate**: 1.0h
* **目的**
  推論方式の選択判断をできるようにする。
* **作業内容**

  * バッチ推論
  * オンライン推論
  * ストリーミング推論
* **完了条件**

  * ユースケースごとに方式を選べる

---

### Issue 5-2：Databricks Model Serving の仕組みを理解する

* **Type**: study
* **Topic**: serving
* **Estimate**: 1.0h
* **目的**
  Managed Serving の特徴を理解する。
* **作業内容**

  * エンドポイント
  * スケーリング
* **完了条件**

  * Serving 構成を説明できる

---

### Issue 5-3：デプロイから推論までの流れを整理する

* **Type**: deliverable
* **Estimate**: 1.5h
* **目的**
  本番利用を想定した推論フローを定義する。
* **作業内容**

  * デプロイ
  * 呼び出し
  * ログ
* **完了条件**

  * 運用フローが明文化されている

---

## W6：監視・ドリフト検知

### Issue 6-1：MLにおける監視の必要性を理解する

* **Type**: study
* **Estimate**: 1.0h
* **目的**
  MLは「作って終わり」でないことを理解する。
* **作業内容**

  * Data Drift
  * Model Drift
* **完了条件**

  * ドリフトの種類を説明できる

---

### Issue 6-2：Databricks における監視手法を整理する

* **Type**: study
* **Estimate**: 1.0h
* **目的**
  Databricks で可能な監視手段を理解する。
* **作業内容**

  * メトリクス
  * ログ
  * Lakehouse Monitoring
* **完了条件**

  * 監視設計を説明できる

---

### Issue 6-3：モデル改善サイクルを定義する

* **Type**: deliverable
* **Estimate**: 1.5h
* **目的**
  継続的改善を前提とした運用を設計する。
* **作業内容**

  * 再学習トリガ
  * 評価基準
* **完了条件**

  * 改善サイクルが文章化されている

---

## W7：MLOps・ガバナンス

### Issue 7-1：MLOps の全体像を整理する

* **Type**: study
* **Estimate**: 1.0h
* **目的**
  ML と DevOps の融合を理解する。
* **作業内容**

  * CI/CD
  * 権限管理
  * 監査
* **完了条件**

  * MLOps の要素を列挙できる

---

### Issue 7-2：Unity Catalog と ML の関係を理解する

* **Type**: study
* **Estimate**: 1.0h
* **目的**
  ML 資産のガバナンスを理解する。
* **作業内容**

  * モデル権限
  * データ権限
* **完了条件**

  * ガバナンス設計を説明できる

---

### Issue 7-3：MLガバナンス設計をまとめる

* **Type**: deliverable
* **Estimate**: 1.5h
* **目的**
  組織でMLを安全に使うための方針を作る。
* **作業内容**

  * 権限
  * 承認フロー
* **完了条件**

  * ガバナンス方針が文書化されている

---

## W8：試験対策と提案力統合

### Issue 8-1：Exam Guide の最終確認

* **Type**: study
* **Estimate**: 1.0h
* **目的**
  出題範囲を完全にカバーする。
* **作業内容**

  * チェックリスト化
* **完了条件**

  * 不安領域が無い状態になっている

---

### Issue 8-2：サンプル問題演習

* **Type**: study
* **Estimate**: 2.0h
* **目的**
  試験形式に慣れる。
* **作業内容**

  * 正答理由・誤答理由整理
* **完了条件**

  * 判断根拠を説明できる

---

### Issue 8-3：ML導入提案書の作成

* **Type**: deliverable
* **Estimate**: 2.0h
* **目的**
  技術コンサルとしての最終アウトプットを作る。
* **作業内容**

  * ML導入是非判断
  * 構成
  * 運用
* **完了条件**

  * 架空顧客向け提案書が完成している
* **成果物**

  * Markdown ドキュメント
