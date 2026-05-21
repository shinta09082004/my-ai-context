# /sync-drive — my-ai-context の変更を Google Drive に同期

## 目的
`git push` 後に、変更されたファイルを自動で Google Drive にアップロードし Obsidian に反映する。

## 手順

### Step 1: 変更ファイルを取得

```bash
git -C /workspaces/my-ai-context log --name-only --pretty=format: -1
```

このコマンドで直近コミットの変更ファイル一覧を取得する。

### Step 2: フォルダIDマッピングを読み込む

`/workspaces/my-ai-context/.drive-sync-map.json` を読み込む。

マッピング:
- `00_Global/` → Drive フォルダ ID: `1RA9apjhCJaXPPpt9zayI24HIRP4ulzDM`
- `Projects/karaoke-AI/` → Drive フォルダ ID: `1X-Jvvhf_5wgtOH3PVRFHhrEQh6orEz0m`
- `Projects/Green_Battery/` → Drive フォルダ ID: `1MzIYhwDUtb4PYBBBx3_vazCOYnxRd1na`

サブフォルダ（Research/, AI_Handoff/ 等）がある場合は、Drive でそのフォルダを検索し、
なければ親フォルダID配下に作成してからアップロードする。

### Step 3: 各ファイルをアップロード

変更ファイルごとに:
1. ファイルのパスからどの Drive フォルダに入れるか判断する
2. そのフォルダに同名ファイルが既に存在するか検索する
   - 存在する → 上書き更新 (update_file)
   - 存在しない → 新規アップロード (create_file)
3. アップロード完了を記録する

### Step 4: 結果を報告

アップロードしたファイルの一覧と、Drive URL を出力する。

---

## 引数なしで実行した場合
直近コミットの変更ファイルを自動で同期する。

## `all` 引数で実行した場合 (`/sync-drive all`)
`/workspaces/my-ai-context/` 配下の全 `.md` ファイルを対象にする。
（初回セットアップ時や全件同期したいときに使う）

---

## 注意
- `.drive-sync-map.json` にないパスのファイルはスキップする
- `.git/` 配下のファイルはスキップする
- Google Drive MCP が必要（mcp__claude_ai_Google_Drive__* ツール）
