# karaoke-AI プロジェクトルール

<!-- updated: 2026-05-18 -->

## プロジェクト概要

カラオケ曲検索サービス。DAM・JOYSOUNDをまたいで曲が探せる、TikTokトレンド連動、音域マッチングを特徴とする。
集客チャンネル: TikTok @karaoke_muneniku（むねにく【音域紹介の人】）

## 技術スタック

| 層 | 技術 |
|---|---|
| **フロントエンド** | Next.js 14 (App Router), React, TypeScript, Tailwind CSS |
| **バックエンド** | Next.js API Routes, Supabase (PostgreSQL) |
| **モバイル** | `/workspaces/karaoke/karaoke-mobile/` (詳細未確認) |
| **デプロイ** | Vercel (想定) |
| **DB** | Supabase (karaoke_songs テーブル等) |
| **広告** | Google AdSense |

## コーディングルール

### 必須

- TypeScript strict モード (`"strict": true`)
- コンポーネントは `src/app/` 配下に App Router 構成で配置
- API は `src/app/api/` 配下に Route Handlers で実装
- DB アクセスは `src/lib/db.ts` 経由に統一
- 環境変数は `.env.local` (コミットしない)

### 禁止

- `any` 型の使用（型推論が難しい場合は `unknown` + narrowing）
- クライアントコンポーネントでの直接DB接続
- console.log を本番コードに残す
- ハードコードされた API キー

### セキュリティ

- ユーザー入力は必ずサーバー側でバリデーション
- Supabase RLS (Row Level Security) を有効化する
- XSS 対策: dangerouslySetInnerHTML を使わない
- SQL インジェクション: Supabase クライアント経由のみ (生 SQL は避ける)

## AIエージェントへの指示

### AIが自律実行してよいこと

- コードの読み取り・分析
- テストの実行
- ドキュメントの更新
- UI コンポーネントの実装（レビュー後）
- API エンドポイントの実装（レビュー後）

### 必ず人間が確認してから実行すること

- `git push` / デプロイ
- Supabase スキーマ変更 (migration)
- 外部 API キーの追加・変更
- 本番環境の設定変更
- ユーザーデータを含む DB 操作

### 絶対にやってはいけないこと

- `.env.local` をコミット
- `git push --force` (main ブランチへ)
- Supabase の RLS を無効化
- ユーザーのパスワードをログに出力

## コンテンツ (TikTok) ルール

- キャラクター: むねにく（カジュアル、音域に詳しい先輩感）
- 禁句: 「〜となっています」「〜でございます」「非常に」「素晴らしい」（AI っぽい硬い表現）
- 必須要素: アプリへの自然な誘導（押し売り感なく）
- 動画尺: 15〜60秒想定

## 参考ファイル

- `karaoke-app/CLAUDE.md` - Claude Code 向けプロジェクト指示
- `karaoke-app/AGENTS.md` - エージェント共通ルール
- `.claude/agents/` - プロジェクト専用エージェント定義
- `agent-dashboard.html` - エージェント構成図

---
*このファイルはすべてのエージェントが読みます。ルール変更時は必ずここを更新してください。*
