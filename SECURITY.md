# 安全配置指南
# Security Configuration Guide

## 環境變數安全設定

### 1. 敏感資料保護
- 永遠不要在程式碼中硬編碼密碼、API 金鑰或憑證
- 使用 AWS Systems Manager Parameter Store 或 AWS Secrets Manager
- 在 .gitignore 中排除所有 .env 檔案

### 2. IAM 角色設定
- EC2 實例應使用 IAM 角色而非硬編碼的 AWS 憑證
- 遵循最小權限原則，只授予必要的權限

### 3. 密碼強度要求
- SECRET_KEY 至少 32 個字符
- 使用隨機生成的強密碼
- 定期輪換密碼

### 4. 網路安全
- 限制 SSH 存取來源 IP
- 使用 HTTPS 加密所有通訊
- 設定適當的防火牆規則

### 5. 日誌和監控
- 啟用 CloudWatch 日誌
- 設定日誌輪轉
- 監控異常活動

## 部署前檢查清單

- [ ] 確認所有敏感資料使用環境變數
- [ ] 驗證 IAM 角色權限設定
- [ ] 檢查安全群組規則
- [ ] 確認 HTTPS 設定
- [ ] 測試輸入驗證
- [ ] 驗證 CORS 設定
- [ ] 檢查日誌配置
- [ ] 確認備份策略
