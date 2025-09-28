# 🚀 AWS Portfolio Project

現代化的個人作品集網站，使用 AWS 雲端服務和自動化 CI/CD 部署。

## ✨ 特色功能

- 🌐 **響應式前端**: 現代化的 HTML/CSS 設計
- 🔧 **RESTful API**: Flask 後端 API 支援留言功能
- ☁️ **AWS 雲端部署**: 使用 CloudFormation 自動化部署
- 🔒 **企業級安全**: 完整的資安防護和最佳實踐
- 🚀 **自動化 CI/CD**: GitHub Actions 自動部署
- 📊 **監控和日誌**: CloudWatch 整合監控

## 🏗️ 架構概覽

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   CloudFront    │    │   S3 Bucket     │    │   EC2 Instance  │
│   (CDN)         │◄───┤   (Frontend)    │    │   (API)         │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │ CloudFormation │
                    │   (IaC)        │
                    └─────────────────┘
```

## 🛠️ 技術堆疊

### 前端
- HTML5 / CSS3
- 響應式設計
- 現代化 UI/UX

### 後端
- Python 3.11
- Flask 框架
- Gunicorn WSGI 伺服器
- 速率限制和 CORS 防護

### 雲端服務
- **AWS S3**: 靜態網站託管
- **AWS CloudFront**: CDN 和快取
- **AWS EC2**: API 伺服器
- **AWS CloudFormation**: 基礎設施即程式碼
- **AWS CloudWatch**: 監控和日誌

### DevOps
- **GitHub Actions**: CI/CD 自動化
- **Docker**: 容器化部署
- **AWS CLI**: 部署腳本

## 🚀 快速開始

### 前置需求
- AWS 帳戶
- GitHub 帳戶
- AWS CLI 安裝
- Git 安裝

### 1. 複製專案
```bash
git clone https://github.com/YOUR_USERNAME/aws-portfolio-project.git
cd aws-portfolio-project
```

### 2. 設定 AWS 憑證
```bash
aws configure
```

### 3. 設定 GitHub Secrets
參考 [GitHub Secrets 配置指南](GITHUB_SECRETS_GUIDE.md)

### 4. 部署到 AWS
```bash
# 使用自動化腳本
./deploy.sh --bucket your-unique-bucket-name

# 或使用 GitHub Actions 自動部署
git push origin main
```

## 📁 專案結構

```
aws-portfolio-project/
├── .github/
│   └── workflows/
│       └── deploy.yml              # GitHub Actions CI/CD
├── api/
│   ├── app.py                      # Flask API 應用程式
│   ├── Dockerfile                  # Docker 容器配置
│   ├── requirements.txt            # Python 依賴
│   ├── test_app.py                 # API 測試
│   └── env.production.example      # 生產環境配置範例
├── frontend/
│   ├── index.html                  # 主頁面
│   ├── index-zh.html              # 中文版頁面
│   ├── styles.css                 # 樣式表
│   └── assets/                    # 靜態資源
├── iac/
│   └── cfn/
│       └── template.yaml           # CloudFormation 模板
├── deploy.sh                      # 部署腳本
├── SECURITY_CHECKLIST.md          # 資安檢查清單
├── GITHUB_SECRETS_GUIDE.md        # GitHub Secrets 指南
└── DEPLOYMENT_CHECKLIST.md         # 部署檢查清單
```

## 🔒 安全功能

- ✅ **輸入驗證**: XSS 攻擊防護
- ✅ **速率限制**: DDoS 攻擊防護
- ✅ **CORS 設定**: 跨域請求控制
- ✅ **IAM 角色**: 最小權限原則
- ✅ **安全群組**: 網路存取控制
- ✅ **HTTPS 加密**: SSL/TLS 安全連線
- ✅ **容器安全**: 非 root 使用者執行

## 🧪 測試

### 本地測試
```bash
cd api
pip install -r requirements.txt
python test_app.py
```

### Docker 測試
```bash
cd api
docker build -t portfolio-api .
docker run -p 5000:80 portfolio-api
```

## 📚 文件

- [部署檢查清單](DEPLOYMENT_CHECKLIST.md)
- [資安檢查清單](SECURITY_CHECKLIST.md)
- [GitHub Secrets 指南](GITHUB_SECRETS_GUIDE.md)
- [專案架構說明](ARCHITECTURE.md)

## 🤝 貢獻

歡迎提交 Issue 和 Pull Request！

### 開發流程
1. Fork 專案
2. 建立功能分支
3. 提交變更
4. 建立 Pull Request

## 📄 授權

MIT License

## 🆘 支援

如果您遇到問題，請：

1. 查看 [部署檢查清單](DEPLOYMENT_CHECKLIST.md)
2. 提交 [Issue](https://github.com/YOUR_USERNAME/aws-portfolio-project/issues)

---

**⭐ 如果這個專案對您有幫助，請給個 Star！**