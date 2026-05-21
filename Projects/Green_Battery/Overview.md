# Green Battery プロジェクト概要

<!-- updated: 2026-05-21 -->

## プロジェクト名
**EneMap AI** (旧称: Green Battery)

## 一言説明
日本全国の蓄電池設置適地を自動発掘するSaaS型GIS解析プラットフォーム。

## 解決する課題
- 蓄電池設置に適した土地（低傾斜・農振外・建物近接）を人手で探すのは膨大な時間がかかる
- 全国47都道府県の筆ポリゴン・農業振興地域データを横断的に解析し、候補地を自動抽出する

## 主要機能

| 機能 | 説明 |
|---|---|
| **バッチパイプライン** | 47都道府県のGISデータを処理し候補地をDBに格納 |
| **リアルタイム発掘** | 地図の表示範囲に応じてオンデマンドで候補地を動的抽出 |
| **候補地マップ表示** | Leaflet.jsベースのダッシュボードで地図上に可視化 |
| **登記情報取得** | 地番・地目・所有者情報の取得（有料プラン） |
| **SaaSサブスク** | Stripe決済によるサブスクリプション管理 |

## 技術スタック

| 層 | 技術 |
|---|---|
| **バックエンド** | FastAPI + Uvicorn (Python) |
| **DB** | SQLite (`green_battery.db`, `project.db`) |
| **GIS解析** | geopandas, osmnx, shapely, fiona |
| **認証** | JWT (python-jose) + bcrypt |
| **決済** | Stripe API |
| **フロントエンド** | HTML + Leaflet.js (`dashboard.html`, `dashboard_ai.html`) |
| **実行環境** | GitHub Codespaces (Linux / Python 3.x) |

## データ構成

```
data/
├── green_battery.db      # 候補地・ユーザーDB (SQLite)
├── project.db            # プロジェクト管理DB
├── gis_raw/              # 都道府県別ZIPファイル (計~5.1GB)
│   ├── 01_hokkaido_fude.zip
│   └── ... (47都道府県 × agri_zone + fude)
└── processed/            # パイプライン処理済みparquet (~489MB)
```

## 主要ファイル

| ファイル | 役割 |
|---|---|
| `src/web/main.py` | FastAPI エントリポイント・全APIエンドポイント |
| `src/pipeline/run_japan_batch.py` | 47都道府県一括処理パイプライン |
| `src/analysis/dynamic_finder.py` | リアルタイム候補地探索エンジン |
| `src/utils/init_product_db.py` | DB初期化 |
| `dashboard.html` | メインダッシュボード UI |
| `scripts/download_all_data.sh` | GISデータ一括ダウンロード |

## APIエンドポイント一覧

| メソッド | パス | 認証 | 説明 |
|---|---|---|---|
| GET | `/api/health` | なし | ヘルスチェック |
| POST | `/api/auth/register` | なし | ユーザー登録 |
| POST | `/api/auth/token` | なし | ログイン・JWT取得 |
| GET | `/api/auth/me` | JWT | 現在ユーザー情報 |
| GET | `/api/candidates` | JWT | 候補地一覧（bbox指定でリアルタイム発掘） |
| POST | `/api/registry` | JWT+有料 | 登記情報取得 |
| POST | `/api/stripe/create-checkout-session` | JWT | Stripe決済セッション作成 |
| POST | `/api/stripe/webhook` | なし | Stripeイベント受信 |

## 開発サーバー起動

```bash
# 必須: プロジェクトルートから実行
python -m src.web.main

# アクセス
# http://localhost:8000
```

## パイプライン実行

```bash
# GISデータ取得後に実行（約0.6分）
python -m src.pipeline.run_japan_batch

# 結果: 約2万件の候補地がDBに格納される
```

## 既知の問題

| 問題 | 状態 |
|---|---|
| 北海道 agri_zone.zip のフォーマットエラー | 未対応（処理スキップ中） |
| 青森・秋田・長野・静岡のデータ欠損 | Google Drive未収録 |

## 収益モデル
- **フリープラン**: 候補地閲覧のみ
- **有料プラン (Stripe)**: 登記情報取得・詳細データDL
