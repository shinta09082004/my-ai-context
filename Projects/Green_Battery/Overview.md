# Green Battery プロジェクト概要

<!-- updated: 2026-05-22 -->

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
| **AI探索モード** | DynamicFinderでリアルタイム候補地発掘（地図移動のたびに自動抽出） |
| **セルフ探索モード** | 傾斜・農振・地目・建物距離・評価ステータスで絞り込み検索 |
| **地図クリック → 住所取得** | HeartRails GeoAPI + 国土地理院 逆ジオコーディング（セルフ探索時） |
| **レイヤーパネル** | 地図下部チェックボックスでGIS オーバーレイ切替（8レイヤー対応） |
| **登記情報取得** | 地番・地目・所有者情報の取得（有料プラン・現在はモックデータ） |
| **SaaSサブスク** | Stripe決済によるサブスクリプション管理 |

## レイヤーパネル対応レイヤー

| チェックボックス | 色 | データソース |
|---|---|---|
| 傾斜量 | オレンジ | 国土地理院 slopemap タイル |
| 農地（土地利用） | 緑 | 国土地理院 lum タイル |
| 行政区画 | 青 | 国土地理院 lcmfc2 タイル |
| 洪水浸水想定区域 | 水色 | 国土地理院ハザードマップ WMS |
| 土砂災害警戒区域 | 赤 | 国土地理院ハザードマップ WMS |
| 保安林 | 濃緑 | 農水省 WMS |
| 農業振興地域（青地） | 紺 | 農水省 WMS |
| **筆界** | 紫 | 国土地理院 chiban タイル |

## 技術スタック

| 層 | 技術 |
|---|---|
| **バックエンド** | FastAPI + Uvicorn (Python) |
| **DB** | SQLite (`green_battery.db`, `project.db`) |
| **GIS解析** | geopandas, osmnx, shapely, fiona |
| **認証** | JWT (python-jose) + bcrypt |
| **決済** | Stripe API |
| **フロントエンド** | HTML + Leaflet.js (`dashboard_ai_v2.html`) |
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
| `dashboard_ai_v2.html` | メインダッシュボード UI（現行ファイル） |
| `src/pipeline/run_japan_batch.py` | 47都道府県一括処理パイプライン |
| `src/analysis/dynamic_finder.py` | リアルタイム候補地探索エンジン |
| `src/utils/init_product_db.py` | DB初期化 |
| `scripts/download_all_data.sh` | GISデータ一括ダウンロード |

## APIエンドポイント一覧

| メソッド | パス | 認証 | 説明 |
|---|---|---|---|
| GET | `/api/health` | なし | ヘルスチェック |
| POST | `/api/auth/register` | なし | ユーザー登録 |
| POST | `/api/auth/token` | なし | ログイン・JWT取得 |
| GET | `/api/auth/me` | JWT | 現在ユーザー情報 |
| GET | `/api/candidates` | JWT | 候補地一覧（bbox + mode + フィルター） |
| GET | `/api/reverse-geocode` | JWT | 逆ジオコーディング（HeartRails→国土地理院） |
| POST | `/api/registry` | JWT+有料 | 登記情報取得（現在モック） |
| POST | `/api/stripe/create-checkout-session` | JWT | Stripe決済セッション作成 |
| POST | `/api/stripe/webhook` | なし | Stripeイベント受信 |

## /api/candidates パラメータ

| パラメータ | 型 | 説明 |
|---|---|---|
| `north/south/east/west` | float | バウンディングボックス |
| `mode` | str | `"ai"`（DynamicFinder実行）/ `"self"`（DBのみ） |
| `max_slope` | float | 傾斜上限 (例: 5.0) |
| `agri` | str | 農振区分フィルター |
| `chimoku` | str | 地目フィルター |
| `min_dist_bldg` | int | 建物離隔下限 (m) |
| `status_filter` | str | "有望" / "要確認" |

## 開発サーバー起動

```bash
python -m src.web.main
# → http://localhost:8000
```

## 既知の問題・TODO

| 項目 | 状態 |
|---|---|
| 北海道 agri_zone.zip フォーマットエラー | 未対応 |
| 青森・秋田・長野・静岡のデータ欠損 | Google Drive未収録 |
| 登記情報 (`/api/registry`) | モックデータ（法務省API実連携が次期P1） |
| レイヤーパネル WMS | 接続確認が必要（農水省・国土地理院ハザード） |
| **レイヤー生データ統合** | 次セッション予定（筆界・農振等の自前データ活用） |

## 収益モデル
- **フリープラン**: 候補地閲覧・AI探索・セルフ探索
- **有料プラン (Stripe)**: 登記情報取得・詳細データDL
