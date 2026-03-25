# 📊 infodashborad — 個人マガジンダッシュボード

個人用の情報収集・タスク管理・VRChat雑談ネタ準備のためのシステム。  
`data.json` を更新してpushするだけで全ページに反映される。

---

## 🌐 URL

| ページ | URL |
|--------|-----|
| 🏠 index（メイン） | `https://nnonma.github.io/infodashborad/` |
| 🎮 VRC Terminal | `terminal.html` |
| 🔴 RSS Live | `rss.html` |
| 📋 この仕様書（HTML版） | `memo.html` |

---

## 📁 フォルダ構成

```
infodashborad/
├── index.html          ← タスク管理 ＋ リンク集（パスワード付き）
├── terminal.html       ← VRC iframeトーテムポール
├── rss.html            ← RSSリアルタイムフィード（キャッシュ読込）
├── memo.html           ← システム備忘録HTML版
├── data.json           ← 全データの単一ソース ★
├── rss_cache.json      ← build.ymlが自動生成（コミット不要）
├── auto-push.ps1       ← 自動pushスクリプト（Windows PowerShell）
├── README.md           ← この仕様書
│
├── vrc/                ← VRCダッシュボード（iframe表示用）
│   ├── vrchat.html     ← VRChat動向
│   ├── culture.html    ← 娯楽・文化・未来年表
│   ├── market.html     ← 投機・地政学・業界地図
│   ├── pixiv.html      ← pixiv市場分析
│   ├── vrchat.json     ← VRChat動向データ
│   ├── culture.json    ← 文化データ
│   ├── market.json     ← 市場・地政学データ
│   └── pixiv.json      ← pixivデータ
│
├── magazine/           ← 情報マガジン（5分野）
│   ├── culture.html    ← 文化系
│   ├── investment.html ← 投機・投資系
│   ├── politics.html   ← 政治・国際系
│   ├── policy.html     ← 法律・統計系
│   └── science.html    ← 科学系
│
├── docs/               ← 資料フォルダ（独立・不定期更新）
├── editor/             ← エディタフォルダ（独立・既存あり）
├── _proto/             ← プロトタイプ退避場所（走査対象外）
│
└── .github/workflows/
    └── build.yml       ← 自動化の心臓部
```

---

## ⚙️ build.yml が行うこと

pushのたびに以下を自動実行する。

1. **`data.json` 構文チェック** — JSONが壊れていたらデプロイを止める
2. **リンク自動生成** — ルート直下のフォルダを走査し `data.json` の `links` を更新
   - `_` や `.` 始まりのフォルダは対象外（`_proto/` など）
   - `vrc/` は `terminal.html` を先頭に固定してから追加
   - **新しいフォルダをルートに追加してpushするだけで自動的にリンクが増える**
3. **RSSフィード取得** — 理研・NHK・arXiv・JSTを取得して `rss_cache.json` に保存
4. **GitHub Pages にデプロイ**

---

## 🔄 更新フロー

### マガジン・タスクを更新する

```
1. Claudeに「〇〇を追加して、差分だけ返して」と頼む
2. 返ってきた差分を data.json に貼る
3. auto-push.ps1 が自動検知してpush（5秒ポーリング）
4. GitHub Actions が自動でリンク生成・RSS取得・デプロイ
```

### VRC JSON（vrc/*.json）を更新する

```
1. Claudeに「vrc/market.json を最新情報に更新して、差分だけ返して」と頼む
2. 返ってきた差分を vrc/market.json に貼る
3. auto-push.ps1 が自動検知してpush
```

### 新しいページ（フォルダ）を追加する

```
1. 新しいフォルダを作成（例: research/）
2. フォルダ内にHTMLを追加
3. pushするだけで index.html のリンク集に自動追加される
```

> **フォルダ名ルール**: `_` か `.` で始まるフォルダは走査対象外。  
> プロトタイプや一時ファイルは `_proto/` に入れる。

---

## 📋 データ構造（data.json）

```json
{
  "_meta": { "version": "1.x", "updated": "YYYY-MM-DD" },
  "tasks": [
    { "id": 1, "text": "タスク名", "done": false, "tag": "setup", "priority": "high" }
  ],
  "links": {
    "magazine": [ { "label": "文化系", "href": "magazine/culture.html" } ],
    "vrc":      [ { "label": "VRC Terminal", "href": "terminal.html" } ],
    "docs":     [],
    "editor":   []
  },
  "culture":    { "_label": "文化系", "sections": [ ... ] },
  "investment": { "_label": "投機・投資系", "sections": [ ... ] },
  "politics":   { "_label": "政治・国際系", "sections": [ ... ] },
  "policy":     { "_label": "法律・統計系", "sections": [ ... ] },
  "science":    { "_label": "科学系", "sections": [ ... ] }
}
```

### エントリ1件の形（全マガジン共通）

```json
{
  "id": "vc001",
  "title": "記事タイトル",
  "url": "https://...",
  "date": "2026-03-21",
  "summary": "1〜2行の要約。VRChat掲示板にも流用可能。",
  "tags": ["タグA", "タグB"],
  "source": "Claude"
}
```

---

## 🤖 Claudeへの依頼テンプレート

### マガジン更新（差分生成）

```
以下のdata.jsonの[セクション名]に、
[テーマ]の最新情報を[N]件追加してください。
差分（追加するentriesの配列）だけ返してください。

[現在のdata.jsonをここに貼る]
```

### VRC JSON更新（差分生成）

```
以下のvrc/[xxx].jsonを最新情報に更新してください。
差分だけ返してください。

[現在のxxx.jsonをここに貼る]
```

### プロジェクト引き継ぎ

```
以下のNotionページを読んで、プロジェクトの続きをお願いします。
https://www.notion.so/3278140b186e81798460fa063f4e1e18
```

---

## 🔒 パスワード

`index.html` はパスワードロック付き。  
3回ミスで5分ロック。誤入力時は日時を画面に表示。

---

## 🗂️ 保留・将来構想

| 項目 | 概要 |
|------|------|
| SVGギャラリー | GitHub Gist API連携・タグ分別・デバイス間共有 |
| VRChat Udon連携 | VRCImageDownloaderでdata.jsonをワールド内表示 |
| RSS Next.js版 | Docker環境・既読管理DB付きリアルタイムポータル |
| CNAME統一 | workers.devとgithub.ioを1URLに統一 |
| data.json分割 | magazine別JSONに分けてトークン節約 |

---

## 📅 更新履歴

| 日付 | 内容 |
|------|------|
| 2026-03-21 | build.yml 汎用フォルダ走査に変更。RSS取得追加。index.htmlパステル化。 |
| 2026-03-20 | terminal.html + vrc/ 4枚 + 4JSON 作成・動作確認 |
| 2026-03-18 | 初回リリース。index.html / magazine 5枚 / build.yml / GitHub Pages 公開 |
