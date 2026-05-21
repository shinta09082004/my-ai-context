# Green Battery プロジェクトルール

<!-- updated: 2026-05-19 -->

## プロジェクト概要

[Green Batteryの説明をここに記入してください]

## 技術スタック

| 層 | 技術 |
|---|---|
| **フロントエンド** | [例: Next.js 14, React, TypeScript, Tailwind CSS] |
| **バックエンド** | [例: Next.js API Routes, Supabase] |
| **DB** | [例: PostgreSQL / Supabase] |
| **デプロイ** | [例: Vercel] |

## コーディングルール

### 必須
- TypeScript strict モード (`"strict": true`)
- 環境変数は `.env.local` (コミットしない)
- コンポーネントは単一責任に保つ
- API は Route Handlers (route.ts) で実装

### 禁止
- `any` 型の使用（型推論が難しい場合は `unknown` + narrowing）
- クライアントコンポーネントでの直接DB接続
- `console.log` を本番コードに残す
- ハードコードされた API キー

### セキュリティ
- ユーザー入力は必ずサーバー側でバリデーション
- XSS 対策: `dangerouslySetInnerHTML` を使わない
- SQL インジェクション: ORM / クライアント経由のみ（生 SQL は避ける）

## AIエージェントへの指示

### AIが自律実行してよいこと
- コードの読み取り・分析
- テストの実行
- ドキュメントの更新
- UI コンポーネントの実装（レビュー後）
- API エンドポイントの実装（レビュー後）

### 必ず人間が確認してから実行すること
- `git push` / デプロイ
- DB スキーマ変更 (migration)
- 外部 API キーの追加・変更
- 本番環境の設定変更
- ユーザーデータを含む DB 操作

### 絶対にやってはいけないこと
- `.env.local` をコミット
- `git push --force` (main ブランチへ)
- ユーザーのパスワードをログに出力

## 参考ファイル
- `.claude/agents/` - プロジェクト専用エージェント定義

---
*このファイルはすべてのエージェントが読みます。ルール変更時は必ずここを更新してください。*
