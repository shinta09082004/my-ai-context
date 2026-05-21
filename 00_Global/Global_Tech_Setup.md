# グローバル技術環境・ツールセット

<!-- updated: 2026-05-18 -->

## 開発環境

| 項目 | 内容 |
|---|---|
| **IDE / 実行環境** | GitHub Codespaces (linux / VS Code Server) |
| **シェル** | bash |
| **OS** | Linux 6.8.0 (Azure) |
| **Node.js** | プロジェクトに同梱 (Next.js 14+) |
| **パッケージマネージャー** | npm |

## AIツール

| ツール | 用途 |
|---|---|
| **Claude Code (CLI)** | メインAIエージェント・コード生成 |
| **Claude API** | claude-sonnet-4-6 (デフォルト) |
| **Gemini CLI** | サブAI (web_search 特化) |
| **MCP Servers** | Google Drive連携 (claude_ai_Google_Drive) |

## コンテキスト管理

| 項目 | 内容 |
|---|---|
| **知識ベース** | `/workspaces/my-ai-context/` (Obsidian vault headless) |
| **プロジェクト紐付け** | `AI_CONTEXT_SPEC` シンボリックリンク |
| **Obsidian sync** | Google Drive MCP経由でアップロード |
| **エージェント格納** | `~/.claude/agents/` (グローバル) / `.claude/agents/` (プロジェクト) |

## メインプロジェクト一覧

| プロジェクト | パス | 説明 |
|---|---|---|
| **karaoke-AI** | `/workspaces/karaoke/` | カラオケ曲検索サービス (Web + Mobile) |

## よく使うコマンド

```bash
# コンテキスト確認
node /workspaces/my-ai-context/ai-context.js karaoke-AI

# エージェント一覧
ls ~/.claude/agents/
ls /workspaces/karaoke/.claude/agents/

# 文脈ファイル保存
/workspaces/my-ai-context/save-context.sh <filename.md> "<content>"
```

---
*ツールやバージョンが変わったら必ずここを更新してください。*
