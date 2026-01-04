# 🚀 Portfolio Website

> 🌐 **Live Site**: [https://luichu.dev/](https://luichu.dev/)

個人作品集網站，使用 GitHub Pages 託管，具備自動部署功能。

## ✨ 特色

- 🌐 **響應式設計**: 適配各種螢幕尺寸
- 🚀 **自動部署**: 推送即上線（GitHub Actions）
- 🆓 **免費託管**: GitHub Pages 零成本
- 🔒 **自動 HTTPS**: 內建 SSL/TLS 加密
- 🎨 **多種主題**: 不同頁面風格可選

## 🏗️ 架構

```
┌──────────────────┐
│   GitHub Pages   │
│                  │
│  • 靜態網站      │
│  • 免費 HTTPS    │
│  • 自動部署      │
└──────────────────┘
         ▲
         │ 推送 master 分支
         │
┌────────┴─────────┐
│ GitHub Actions   │
│                  │
│ • 自動建置       │
│ • 自動部署       │
└──────────────────┘
```

## 🛠️ 技術棧

### 前端
- HTML5, CSS3, JavaScript
- 響應式設計
- 多種頁面主題

### 部署
- **GitHub Pages**: 免費靜態網站託管
- **GitHub Actions**: 自動化 CI/CD
- **HTTPS**: 自動 SSL/TLS 加密

## 🚀 快速開始

### 前置需求

- GitHub 帳號
- Git 已安裝

### 1. Fork/Clone 專案

```bash
git clone https://github.com/YOUR_USERNAME/aws-portfolio-project.git
cd aws-portfolio-project
```

### 2. 啟用 GitHub Pages

1. 前往專案的 **Settings** → **Pages**
2. 在 **Source** 選擇 **GitHub Actions**
3. 儲存設定

### 3. 自訂內容

編輯 `frontend/` 目錄下的檔案：
- [frontend/index.html](frontend/index.html) - 主頁內容
- [frontend/styles.css](frontend/styles.css) - 樣式
- [frontend/assets/](frontend/assets/) - 圖片和媒體

### 4. 部署（自動）

推送到 master 分支即可：

```bash
git add .
git commit -m "更新作品集"
git push origin master
```

GitHub Actions 會自動部署到：
```
https://YOUR_USERNAME.github.io/aws-portfolio-project/
```

### 5. 自訂網域（選用）

1. 在 `frontend/` 建立 `CNAME` 檔案：
   ```
   www.yoursite.com
   ```

2. 在 DNS 供應商設定 CNAME 記錄：
   ```
   CNAME  www  YOUR_USERNAME.github.io
   ```

## 📁 專案結構

```
aws-portfolio-project/
├── .github/workflows/
│   └── deploy-pages.yml        # GitHub Actions 自動部署
├── frontend/                   # 靜態網站檔案
│   ├── index.html              # 主頁
│   ├── index-zh.html           # 中文版
│   ├── simple.html             # 簡約主題
│   ├── tech-style.html         # 科技主題
│   ├── styles.css              # 樣式表
│   └── assets/                 # 靜態資源（圖片等）
├── docs/
│   └── GITHUB_PAGES_MIGRATION.md  # 遷移指南
└── README.md
```

## 🔧 本地預覽

使用任何本地伺服器預覽網站：

```bash
# 使用 Python
cd frontend
python3 -m http.server 8000

# 或使用 PHP
php -S localhost:8000

# 或使用 VS Code Live Server 擴充功能
```

然後在瀏覽器開啟 `http://localhost:8000`

## 📚 說明文件

- [GitHub Pages 遷移指南](docs/GITHUB_PAGES_MIGRATION.md)

## 🤝 貢獻

歡迎貢獻！請隨時提交 Issue 或 Pull Request。

### 開發流程
1. Fork 專案
2. 建立功能分支
3. 提交變更
4. 建立 Pull Request

## 📄 授權

MIT License

## 🆘 支援

如果遇到問題：

1. 查看 [遷移指南](docs/GITHUB_PAGES_MIGRATION.md)
2. 提交 [Issue](https://github.com/YOUR_USERNAME/aws-portfolio-project/issues)

---

**⭐ 如果這個專案對你有幫助，請給個星星！**
