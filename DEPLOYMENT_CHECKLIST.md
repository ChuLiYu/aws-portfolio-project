# 🚀 GitHub 自動化部署檢查清單
# GitHub Automated Deployment Checklist

## 📋 部署前檢查清單

### ✅ 1. GitHub 儲存庫設定

#### 基本設定
- [ ] 建立 GitHub 儲存庫
- [ ] 上傳所有專案檔案
- [ ] 確認 `.github/workflows/deploy.yml` 存在
- [ ] 確認所有必要檔案都在正確位置

#### 檔案結構檢查
```
aws-portfolio-project/
├── .github/
│   └── workflows/
│       └── deploy.yml          ✅
├── api/
│   ├── app.py                  ✅
│   ├── Dockerfile              ✅
│   ├── requirements.txt        ✅
│   └── env.production.example ✅
├── frontend/                   ✅
├── iac/
│   └── cfn/
│       └── template.yaml       ✅
├── deploy.sh                   ✅
├── SECURITY_CHECKLIST.md      ✅
└── GITHUB_SECRETS_GUIDE.md     ✅
```

### ✅ 2. AWS 帳戶準備

#### AWS 帳戶設定
- [ ] 確認 AWS 帳戶已啟用
- [ ] 確認有足夠的額度
- [ ] 確認在目標區域（us-east-1）有權限

#### IAM 使用者建立
- [ ] 建立 IAM 使用者：`github-actions-portfolio`
- [ ] 附加必要的政策
- [ ] 下載存取金鑰（CSV 檔案）
- [ ] 測試 AWS CLI 連線

### ✅ 3. GitHub Secrets 設定

#### 必要 Secrets
- [ ] `AWS_ACCESS_KEY_ID` - AWS 存取金鑰 ID
- [ ] `AWS_SECRET_ACCESS_KEY` - AWS 秘密存取金鑰
- [ ] `S3_BUCKET_NAME` - S3 儲存桶名稱（全域唯一）

#### 可選 Secrets
- [ ] `ALLOWED_ORIGINS` - CORS 允許的來源
- [ ] `SECRET_KEY` - Flask 密鑰
- [ ] `JWT_SECRET_KEY` - JWT 密鑰

### ✅ 4. S3 儲存桶準備

#### 儲存桶命名
- [ ] 選擇全域唯一的儲存桶名稱
- [ ] 確認名稱符合 S3 命名規則
- [ ] 記錄儲存桶名稱用於 Secrets 設定

#### 範例儲存桶名稱
```
your-name-portfolio-2024
your-company-portfolio-site
my-awesome-portfolio-bucket
```

### ✅ 5. 程式碼檢查

#### API 檢查
- [ ] 確認 `api/app.py` 沒有語法錯誤
- [ ] 確認所有依賴都在 `requirements.txt` 中
- [ ] 確認 Dockerfile 正確設定
- [ ] 測試本地 API 運行

#### 前端檢查
- [ ] 確認所有 HTML 檔案存在
- [ ] 確認 CSS 和圖片檔案完整
- [ ] 測試本地前端顯示

#### CloudFormation 檢查
- [ ] 確認 `template.yaml` 語法正確
- [ ] 確認所有參數都有預設值
- [ ] 確認資源命名符合規範

### ✅ 6. 安全檢查

#### 資安設定
- [ ] 確認所有敏感資料使用環境變數
- [ ] 確認 CORS 設定正確
- [ ] 確認速率限制已啟用
- [ ] 確認輸入驗證已實作

#### 權限檢查
- [ ] 確認 IAM 政策遵循最小權限原則
- [ ] 確認安全群組規則正確
- [ ] 確認 SSH 存取已限制

## 🚀 部署流程

### 步驟 1: 推送到 GitHub
```bash
# 初始化 Git 儲存庫
git init
git add .
git commit -m "Initial commit: AWS Portfolio with CI/CD"

# 新增遠端儲存庫
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
git branch -M main
git push -u origin main
```

### 步驟 2: 設定 GitHub Secrets
1. 前往 GitHub 儲存庫
2. 點擊 **Settings** > **Secrets and variables** > **Actions**
3. 新增所有必要的 Secrets（參考 `GITHUB_SECRETS_GUIDE.md`）

### 步驟 3: 觸發部署
- **自動部署**: 推送到 `main` 分支會自動觸發部署
- **手動部署**: 前往 **Actions** 標籤，手動執行工作流程

### 步驟 4: 監控部署
1. 前往 **Actions** 標籤
2. 查看部署進度
3. 檢查日誌是否有錯誤
4. 等待部署完成

## 🔍 部署後驗證

### 檢查 CloudFormation 堆疊
```bash
aws cloudformation describe-stacks \
  --stack-name portfolio-stack \
  --region us-east-1
```

### 檢查 S3 儲存桶
```bash
aws s3 ls s3://YOUR_BUCKET_NAME/
```

### 檢查 EC2 實例
```bash
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=portfolio-stack-API" \
  --region us-east-1
```

### 測試網站
1. 取得 CloudFormation 輸出中的網站 URL
2. 在瀏覽器中開啟網站
3. 測試 API 端點
4. 測試留言功能

## 🚨 故障排除

### 常見錯誤

#### 1. CloudFormation 堆疊建立失敗
**可能原因**:
- S3 儲存桶名稱已存在
- IAM 權限不足
- 資源限制

**解決方法**:
- 檢查 S3 儲存桶名稱是否唯一
- 確認 IAM 使用者有足夠權限
- 檢查 AWS 服務限制

#### 2. GitHub Actions 失敗
**可能原因**:
- Secrets 設定錯誤
- AWS 憑證無效
- 程式碼語法錯誤

**解決方法**:
- 檢查 Secrets 名稱和值
- 測試 AWS 憑證
- 檢查程式碼語法

#### 3. API 部署失敗
**可能原因**:
- EC2 實例無法存取
- SSH 連線失敗
- 服務啟動失敗

**解決方法**:
- 檢查安全群組設定
- 確認 SSH 金鑰設定
- 檢查 EC2 實例日誌

### 日誌查看
```bash
# CloudFormation 事件
aws cloudformation describe-stack-events \
  --stack-name portfolio-stack \
  --region us-east-1

# EC2 實例日誌
aws ec2 get-console-output \
  --instance-id i-1234567890abcdef0 \
  --region us-east-1
```

## 📞 支援資源

### 文件連結
- [GitHub Actions 文件](https://docs.github.com/en/actions)
- [AWS CloudFormation 文件](https://docs.aws.amazon.com/cloudformation/)
- [AWS CLI 文件](https://docs.aws.amazon.com/cli/)

### 社群支援
- [GitHub 社群論壇](https://github.community/)
- [AWS 開發者論壇](https://forums.aws.amazon.com/)
- [Stack Overflow](https://stackoverflow.com/)

## ✅ 完成檢查

部署完成後，確認以下項目：

- [ ] 網站可以正常存取
- [ ] API 端點回應正常
- [ ] 留言功能運作正常
- [ ] CloudFront 快取正常
- [ ] 監控和日誌正常
- [ ] 安全設定正確

🎉 **恭喜！您的 AWS Portfolio 專案已成功部署並設定自動化 CI/CD！**
