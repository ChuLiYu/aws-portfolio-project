# 🔐 GitHub Secrets 配置指南
# GitHub Secrets Configuration Guide

## 📋 必要的 GitHub Secrets

為了讓 GitHub Actions 能夠自動部署到 AWS，您需要在 GitHub 儲存庫中設定以下 Secrets：

### 1. AWS 憑證
- **`AWS_ACCESS_KEY_ID`**: AWS 存取金鑰 ID
- **`AWS_SECRET_ACCESS_KEY`**: AWS 秘密存取金鑰

### 2. AWS 資源配置
- **`S3_BUCKET_NAME`**: S3 儲存桶名稱（必須全域唯一）

### 3. 可選配置
- **`ALLOWED_ORIGINS`**: 允許的 CORS 來源（用逗號分隔）
- **`SECRET_KEY`**: Flask 應用程式的密鑰
- **`JWT_SECRET_KEY`**: JWT 密鑰

## 🛠️ 設定步驟

### 步驟 1: 建立 AWS IAM 使用者

1. 登入 AWS 控制台
2. 前往 IAM 服務
3. 建立新使用者：
   - 使用者名稱：`github-actions-portfolio`
   - 存取類型：程式化存取

4. 附加政策：
   ```json
   {
       "Version": "2012-10-17",
       "Statement": [
           {
               "Effect": "Allow",
               "Action": [
                   "cloudformation:*",
                   "s3:*",
                   "cloudfront:*",
                   "ec2:*",
                   "iam:*"
               ],
               "Resource": "*"
           }
       ]
   }
   ```

5. 下載憑證檔案（CSV 格式）

### 步驟 2: 在 GitHub 中設定 Secrets

1. 前往您的 GitHub 儲存庫
2. 點擊 **Settings** 標籤
3. 在左側選單中點擊 **Secrets and variables** > **Actions**
4. 點擊 **New repository secret** 按鈕
5. 逐一新增以下 Secrets：

#### AWS_ACCESS_KEY_ID
- **Name**: `AWS_ACCESS_KEY_ID`
- **Value**: 從 CSV 檔案中的 `Access key ID`

#### AWS_SECRET_ACCESS_KEY
- **Name**: `AWS_SECRET_ACCESS_KEY`
- **Value**: 從 CSV 檔案中的 `Secret access key`

#### S3_BUCKET_NAME
- **Name**: `S3_BUCKET_NAME`
- **Value**: 您的 S3 儲存桶名稱（例如：`my-portfolio-bucket-2024`）

#### ALLOWED_ORIGINS（可選）
- **Name**: `ALLOWED_ORIGINS`
- **Value**: 允許的域名（例如：`https://yourdomain.com,https://www.yourdomain.com`）

#### SECRET_KEY（可選）
- **Name**: `SECRET_KEY`
- **Value**: 強密碼（至少 32 個字符）

#### JWT_SECRET_KEY（可選）
- **Name**: `JWT_SECRET_KEY`
- **Value**: 強密碼（至少 32 個字符）

## 🔒 安全最佳實踐

### 1. IAM 權限最小化
建議使用更嚴格的 IAM 政策，只授予必要的權限：

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "cloudformation:CreateStack",
                "cloudformation:UpdateStack",
                "cloudformation:DeleteStack",
                "cloudformation:DescribeStacks",
                "cloudformation:DescribeStackEvents",
                "cloudformation:Wait*"
            ],
            "Resource": "arn:aws:cloudformation:*:*:stack/portfolio-stack/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::your-bucket-name",
                "arn:aws:s3:::your-bucket-name/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudfront:CreateInvalidation",
                "cloudfront:GetDistribution",
                "cloudfront:GetDistributionConfig"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceStatus"
            ],
            "Resource": "*"
        }
    ]
}
```

### 2. 定期輪換憑證
- 每 90 天輪換 AWS 存取金鑰
- 更新 GitHub Secrets 中的對應值

### 3. 監控和日誌
- 啟用 AWS CloudTrail 監控 API 呼叫
- 設定 CloudWatch 告警

## 🧪 測試 Secrets 設定

### 方法 1: 使用 GitHub Actions 測試
建立一個簡單的測試工作流程：

```yaml
name: Test AWS Connection
on:
  workflow_dispatch:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v4
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: us-east-1

    - name: Test AWS connection
      run: aws sts get-caller-identity
```

### 方法 2: 使用本地測試
```bash
# 設定環境變數
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_SECRET_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"

# 測試連線
aws sts get-caller-identity
```

## 🚨 常見問題

### Q: Secrets 設定後仍然無法部署
**A**: 檢查以下項目：
1. Secret 名稱是否完全正確（區分大小寫）
2. AWS 憑證是否有效
3. IAM 使用者是否有足夠權限
4. S3 儲存桶名稱是否全域唯一

### Q: 如何更新 Secrets
**A**: 
1. 前往 GitHub 儲存庫的 Settings > Secrets and variables > Actions
2. 找到要更新的 Secret
3. 點擊 **Update** 按鈕
4. 輸入新值並儲存

### Q: 如何刪除 Secrets
**A**: 
1. 前往 GitHub 儲存庫的 Settings > Secrets and variables > Actions
2. 找到要刪除的 Secret
3. 點擊 **Delete** 按鈕
4. 確認刪除

## 📚 相關資源

- [GitHub Secrets 文件](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [AWS IAM 最佳實踐](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [AWS CLI 配置指南](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)
