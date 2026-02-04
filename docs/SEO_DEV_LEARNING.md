# 🚀 SEO + Web Developer 實戰學習筆記

這份筆記紀錄了行銷公司在面試「SEO + Web Developer」職位時，除了 Lighthouse 分數外，最看重的技術細節與實務能力。

---

## 1. 技術 SEO (Technical SEO)
搜尋引擎不只「看」網頁，還會「讀」代碼結構。
- [ ] **JSON-LD 結構化資料**：使用 Schema.org 標籤定義 `Person` (個人資訊)、`SoftwareApplication` (作品專案)。
- [ ] **語意化 HTML (Semantic HTML)**：正確使用 `<main>`, `<article>`, `<nav>`, `<header>`, `<footer>`，避免 `div-soup`。
- [ ] **Canonical Tags**：確保搜尋引擎知道哪個網址是原始版本，防止重複內容扣分。
- [ ] **Sitemap & Robots.txt**：自動化生成網站地圖，並明確指示爬蟲抓取範圍。

## 2. 轉換率優化 (CRO) 與追蹤 (Analytics)
行銷公司重視「數據證明價值」。
- [ ] **GA4 事件追蹤**：了解如何手動埋設 `gtag` 事件（如：點擊下載履歷、點擊專案連結）。
- [ ] **GTM 彈性運用**：雖然為了效能會精簡 GTM，但需具備在不修改代碼的情況下透過 GTM 部署追蹤代碼的能力。
- [ ] **Open Graph (OG) & Twitter Cards**：優化在社群媒體分享時的標題、描述與預覽圖，提升點擊率 (CTR)。

## 3. 核心網頁指標 (Core Web Vitals)
- [ ] **LCP (Largest Contentful Paint)**：優化首螢幕圖片（如使用 `fetchpriority="high"`, WebP 格式）。
- [ ] **CLS (Cumulative Layout Shift)**：為圖片預留 `aspect-ratio` 或固定尺寸，防止載入時內容跳動。
- [ ] **INP (Interaction to Next Paint)**：優化 JS 執行效率，確保使用者操作後網頁反應即時。

## 4. 效能優化 (Performance)
- [ ] **圖片次世代格式**：優先使用 WebP 或 Avif。
- [ ] **JS/CSS 瘦身**：移除未使用的代碼，使用 Minified 版本。
- [ ] **快取策略**：善用瀏覽器快取與 CDN (如 Cloudflare) 節省載入時間。

## 5. MLOps 與 AI 的結合 (您的優勢)
- [ ] **自動化內容生成**：利用 AI 輔助產生大量且高品質的 Meta Tags。
- [ ] **SEO 數據監控**：建立自動化腳本監控關鍵字排名與競爭對手動態。

---

## 📅 學習清單 (Next Steps)
1. [ ] 練習手動撰寫 `JSON-LD`。
2. [ ] 學習使用 Google Search Console 觀察網頁抓取狀況。
3. [ ] 深入理解 GA4 的自定義維度 (Custom Dimensions) 與指標。
