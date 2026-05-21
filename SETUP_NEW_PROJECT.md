# 新プロジェクトへのAI環境セットアップ手順

新しいCodespaceでObsidianコンテキストエンジン・AIエージェント組織を再現する手順。

---

## 前提条件

- `my-ai-context` リポジトリがCodespaceに存在すること
- Claude Code がインストールされていること

---

## ワンコマンドセットアップ

```bash
bash /workspaces/my-ai-context/bootstrap-project.sh \
  <PROJECT_NAME> <PROJECT_DIR> [PROJECT_TYPE]
```

**引数:**
| 引数 | 説明 | 例 |
|---|---|---|
| `PROJECT_NAME` | my-ai-context内のプロジェクト名 | `Green_Battery` |
| `PROJECT_DIR` | Codespace上のプロジェクトディレクトリ | `/workspaces/green-battery` |
| `PROJECT_TYPE` | プロジェクト種別（省略可） | `webapp` (デフォルト) |

---

## プロジェクト別の実行例

### Green Battery
```bash
bash /workspaces/my-ai-context/bootstrap-project.sh \
  Green_Battery /workspaces/green-battery webapp
```

### karaoke-AI（参考: 手動セットアップ済み）
```bash
bash /workspaces/my-ai-context/bootstrap-project.sh \
  karaoke-AI /workspaces/karaoke webapp
```

---

## セットアップ後にやること

1. **Rules.md を更新する**
   ```
   /workspaces/my-ai-context/Projects/<PROJECT_NAME>/Rules.md
   ```
   技術スタック・プロジェクト概要・固有ルールを記入する

2. **Claude Code を起動して確認する**
   ```bash
   cd /workspaces/<project-dir>
   claude
   ```
   `.claude/agents/` のエージェントが認識されていることを確認

3. **`/resume` を実行して文脈を読み込む**

---

## my-ai-context を新Codespaceにセットアップする場合

```bash
# 1. リポジトリをクローン
git clone https://github.com/shinta09082004/my-ai-context /workspaces/my-ai-context

# 2. bootstrap を実行
bash /workspaces/my-ai-context/bootstrap-project.sh \
  Green_Battery /workspaces/green-battery webapp
```

---

## セットアップで作成されるもの

| ファイル | 説明 |
|---|---|
| `my-ai-context/Projects/<NAME>/Rules.md` | プロジェクトルール（要記入） |
| `my-ai-context/Projects/<NAME>/Research/` | リサーチ保存フォルダ |
| `my-ai-context/Projects/<NAME>/AI_Handoff/` | エージェント間引き継ぎフォルダ |
| `<PROJECT_DIR>/.claude/agents/` | 8体のエージェント定義 |
| `<PROJECT_DIR>/AI_CONTEXT_SPEC` | コンテキストへのシンボリックリンク |
