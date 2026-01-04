# 🚀 GitHub Pages 遷移指南

## 📋 遷移步驟

### 1️⃣ **在 GitHub 啟用 Pages**

1. 前往你的 GitHub repo 設定頁面
   ```
   https://github.com/YOUR_USERNAME/aws-portfolio-project/settings/pages
   ```

2. 在 **Source** 選擇：
   - **GitHub Actions** (不是 Deploy from a branch)

3. 儲存設定

---

### 2️⃣ **移除後端相關檔案（可選）**

如果你確定不需要後端功能，可以刪除：

```bash
# 備份後刪除
rm -rf api/
rm -rf terraform/
rm -rf iac/
rm -f docker-compose.yml
rm -f scripts/deploy.sh
```

或保留這些檔案作為「程式碼展示」，但不實際部署。

---

### 3️⃣ **更新前端（移除 API 呼叫）**

檢查 `frontend/` 中的 HTML/JS 檔案，移除所有對後端 API 的呼叫：

```javascript
// 移除類似這樣的程式碼
fetch('https://api.yoursite.com/messages')
  .then(response => response.json())
  .then(data => console.log(data));
```

---

### 4️⃣ **推送程式碼觸發部署**

```bash
git add .
git commit -m "遷移到 GitHub Pages"
git push origin master
```

部署完成後，你的網站會在：
```
https://YOUR_USERNAME.github.io/aws-portfolio-project/
```

---

### 5️⃣ **自訂網域（可選）**

如果你有自己的網域：

1. 在 repo 根目錄創建 `frontend/CNAME` 檔案：
   ```
   www.yoursite.com
   ```

2. 在你的 DNS 供應商設定 CNAME 記錄：
   ```
   CNAME  www  YOUR_USERNAME.github.io
   ```

---

## ✅ **部署後檢查清單**

- [ ] GitHub Actions workflow 執行成功
- [ ] 網站可以在 `github.io` 訪問
- [ ] 所有靜態資源（圖片、CSS）正常載入
- [ ] 移動裝置顯示正常
- [ ] HTTPS 正常運作（GitHub Pages 自動提供）

---

## 📊 **GitHub Pages vs AWS 比較**

| 項目 | GitHub Pages | AWS (原架構) |
|------|-------------|-------------|
| **費用** | **$0** 完全免費 | $0-10/月 |
| **部署** | 自動（推送即部署） | GitHub Actions + AWS CLI |
| **後端** | ❌ 不支援 | ✅ FastAPI/Flask |
| **資料庫** | ❌ 不支援 | ✅ 可整合 RDS/DynamoDB |
| **CDN** | ✅ 內建 | ✅ CloudFront |
| **HTTPS** | ✅ 自動 | ✅ 需設定 |
| **自訂網域** | ✅ 支援 | ✅ 支援 |
| **技能展示** | 前端為主 | 全端 + 雲端 + DevOps |

---

## 🔧 **故障排除**

### 網站顯示 404
- 確認 GitHub Pages 已啟用
- 檢查 Source 設定為 "GitHub Actions"
- 確認 workflow 執行成功

### 圖片或 CSS 載入失敗
- 使用相對路徑而非絕對路徑
- 檢查檔案路徑大小寫（GitHub Pages 區分大小寫）

### Workflow 執行失敗
- 檢查 `.github/workflows/deploy-pages.yml` 語法
- 確認 `permissions` 設定正確

---

## 📝 **未來如果想回到 AWS**

保留所有 `terraform/` 和 `iac/` 檔案，未來隨時可以：

```bash
# 重新部署到 AWS
cd terraform
terraform init
terraform apply
```
