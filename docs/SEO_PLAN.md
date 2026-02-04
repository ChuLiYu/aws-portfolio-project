# 網站 SEO 優化計畫與執行策略

本文件詳細說明針對 `luichu.dev` 個人作品集網站的搜尋引擎優化 (SEO) 策略。
由於您的職業定位調整為 **Data Engineer (Fintech)** 為主，**MLOps** 為輔，本計畫的關鍵字與內容策略已相應調整。

## 1. 核心目標
1.  **職業定位轉型**：讓搜尋引擎與訪客明確知道您的核心專長是「金融科技資料工程 (Fintech Data Engineering)」，同時具備 MLOps 能力。
2.  **專業形象展示**：透過 Open Graph 標籤，讓網站在 LinkedIn、Line、Twitter 分享時顯示專業的預覽卡片。
3.  **多語言精準導流**：確保中文使用者看到中文版，英文使用者看到英文版。

---

## 2. 優化項目細節

### A. 基礎標籤優化 (Meta Tags & Structure)
**目的**：讓 Google 準確抓取關鍵字，並在搜尋結果頁 (SERP) 顯示吸引人的描述。

| 標籤項目 | 設定內容 (範例) | 原因 |
| :--- | :--- | :--- |
| **Title Tag** | `Lui Chu — Data Engineer (Fintech) & MLOps` | 這是搜尋結果最顯眼的標題。將 Data Engineer 放在最前面強調主力。 |
| **Meta Description** | "Data Engineer specializing in Fintech systems, high-concurrency data pipelines, and MLOps infrastructure. Experienced in AWS, ETL, and financial reporting optimization." | 這是標題下方的兩行文字。加入 Fintech, ETL, AWS 等關鍵字能提升點擊率。 |
| **Meta Keywords** | `Data Engineer, Fintech, MLOps, AWS, ETL, Python, HiTrust` | 輔助標籤，定義核心技能。 |
| **Canonical URL** | `https://luichu.dev/` | 告訴搜尋引擎這是「正版」網址，避免權重被參數網址稀釋。 |

### B. 社群分享優化 (Social Media / Open Graph)
**目的**：優化在 LinkedIn、Facebook 等社群媒體貼上網址時的呈現效果。

| 標籤項目 | 設定內容 | 原因 |
| :--- | :--- | :--- |
| **og:title** | 與網頁標題一致 | 確保分享時標題清楚。 |
| **og:description** | 簡短有力的個人簡介 | 讓人在沒點進去前就知道您的專業背景。 |
| **og:image** | `assets/images/profile/avatar.jpg` (或專屬預覽圖) | **最重要**。沒有圖片的連結容易被忽視。我們會使用您現有的大頭照或網站截圖。 |
| **og:type** | `profile` 或 `website` | 定義內容類型。 |

### C. 多語言與技術引導 (i18n & Technical SEO)
**目的**：處理中英文版本的對應關係。

| 標籤項目 | 設定內容 | 原因 |
| :--- | :--- | :--- |
| **hreflang** | `<link rel="alternate" hreflang="en" href="..." />` | 明確告訴 Google：這兩個頁面是同一內容的不同語言版，請根據使用者語言偏好顯示。 |

---

## 3. 內容關鍵字策略 (Content Strategy)

因應您的轉型，我們將在頁面內容中強化以下關鍵字組合：

*   **Primary (主力)**: Data Engineer, Fintech, Financial Systems, ETL Pipelines, High Consistency, ACID, Database Optimization.
*   **Secondary (輔助/加分)**: MLOps, AWS Infrastructure, Model Deployment, Machine Learning.

### 修改重點：
1.  **Hero Section**: 職稱改為 Data Engineer (Fintech)，強調「高併發 (High Concurrency)」與「資料一致性 (Data Consistency)」。
2.  **About Section**: 加重描述在 **HiTrust Inc.** 的經驗（處理金融交易、報表優化），將 MLOps 描述為「將資料工程嚴謹度帶入 AI 領域」的優勢。

---

## 4. 執行步驟

1.  **修改 `index.html` (英文版)**：
    *   更新 `<head>` 加入上述所有 Meta Tags。
    *   更新 `<body>` 內容，將敘述重心移轉至 Data Engineering 與 Fintech。
2.  **修改 `index-zh.html` (中文版)**：
    *   同步更新 `<head>` 與 `<body>`，強調「金融科技」、「資料工程」。
3.  **驗證**：
    *   確認連結分享預覽 (Social Preview)。
    *   確認關鍵字密度。
