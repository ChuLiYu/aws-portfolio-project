# AWS 资源归属映射

## 概述
本文档明确区分 Portfolio 和 Chainy 两个项目的 AWS 资源，确保 Terraform 只管理 Portfolio 项目资源。

---

## ✅ Portfolio 项目资源（安全导入到 Terraform）

### CloudFront Distribution
- **ID**: `E3CSSG3NLBDZHV`
- **Domain**: `d278zt8g1aybxp.cloudfront.net`
- **Alias**: `luichu.dev`
- **Comment**: "Portfolio Website - CloudFront Distribution"
- **Origin**: `aws-portfolio-liyu.s3.us-east-1.amazonaws.com`
- **用途**: Portfolio 网站的 CDN 分发

### S3 Bucket
- **Name**: `aws-portfolio-liyu`
- **Tags**: 无（但名称明确属于 portfolio）
- **用途**: 存储 portfolio 前端静态文件

### EC2 Instances
**状态**: ✅ 已清理（2026-01-04）

~~原有的两台 EC2 实例已确认与 Portfolio 项目无关，已删除：~~
- ~~i-02f2caee522bb3725 (ec2-dev-api-us-east-1a)~~ - 培训/学习用途，已删除
- ~~i-0262707311b4bddbd (Web Server from Module)~~ - 培训用途，已删除
- **成本节省**: $16.98/月，$203.76/年
- **详细分析**: 参见 [EC2_ANALYSIS.md](../docs/EC2_ANALYSIS.md)

**Portfolio 项目架构说明**:
- Portfolio 前端通过 S3 + CloudFront 部署（无需 EC2）
- 如需 API 服务器，应通过 Terraform 创建新的专用 EC2

---

## ❌ Chainy 项目资源（绝对不能导入！）

### CloudFront Distribution
- **ID**: `E17M3II142BC5E`
- **Domain**: `dowkb9m88swbe.cloudfront.net`
- **Alias**: `chainy.luichu.dev`
- **Comment**: "Chainy web front-end with API Gateway integration"
- **Origin**: `9qwxcajqf9.execute-api.ap-northeast-1.amazonaws.com`
- **用途**: Chainy 项目的前端分发
- **🚫 禁止**: 绝对不能导入到 Portfolio Terraform

### S3 Buckets
所有以 `chainy-` 开头的 buckets：

1. **chainy-prod-web**
   - Tags: `Project: chainy`, `Environment: prod`
   - 用途: Chainy 生产环境 web 资源

2. **chainy-prod-chainy-events**
   - Tags: `Project: chainy`, `Environment: prod`, `Purpose: chainy-events`
   - 用途: Chainy 事件存储

3. **chainy-terraform-state-lui-20240930**
   - Tags: `Purpose: terraform-state`, `Environment: dev`
   - 用途: Chainy 项目的 Terraform state 存储
   - **特别重要**: 这是 Chainy 的 Terraform state，绝对不能碰！

4. **chainy-prod-web-*（多个版本）**
   - 用途: Chainy web 资源的历史版本

### 其他 Chainy 资源
- **API Gateway**: `9qwxcajqf9.execute-api.ap-northeast-1.amazonaws.com`
- **Lambda Functions**: 未列出，但应该存在
- **DynamoDB Tables**: 根据 Chainy 项目架构应该存在

---

## 🛡️ 安全保护机制

### 1. 导入脚本保护
`import.sh` 脚本包含以下保护：

```bash
# 硬编码的 Chainy 资源（禁止导入）
CHAINY_CF_DIST="E17M3II142BC5E"
CHAINY_BUCKETS=("chainy-prod-web" "chainy-prod-chainy-events" ...)

# 导入前确认
read -p "确认只导入 Portfolio 项目资源？(yes/no): " confirm
```

### 2. Terraform State 隔离
- Portfolio Terraform state: **本地或新建的 S3 bucket**
- Chainy Terraform state: `chainy-terraform-state-lui-20240930`（完全独立）

### 3. 命名约定
- Portfolio 资源: `aws-portfolio-*`
- Chainy 资源: `chainy-*`

### 4. 标签策略
建议为所有 Portfolio 资源添加统一标签：

```hcl
default_tags {
  tags = {
    Project     = "portfolio"
    ManagedBy   = "terraform"
    Repository  = "aws-portfolio-project"
  }
}
```

---

## 📋 导入检查清单

在执行 `terraform import` 前，确认：

- [ ] ✅ S3 Bucket 是 `aws-portfolio-liyu`（不是 chainy-*）
- [ ] ✅ CloudFront ID 是 `E3CSSG3NLBDZHV`（不是 E17M3II142BC5E）
- [ ] ✅ CloudFront Alias 是 `luichu.dev`（不是 chainy.luichu.dev）
- [ ] ⚠️ EC2 Instance 用途已确认（建议暂不导入）
- [ ] ❌ 确认没有任何 `chainy-*` 资源被导入
- [ ] ❌ 确认 Chainy Terraform state 不受影响

---

## 🚨 紧急回滚

如果不小心导入了错误的资源：

```bash
# 1. 立即从 state 中移除
terraform state rm aws_resource.name

# 2. 检查 state 文件
terraform state list

# 3. 如果需要，恢复 state 备份
cp terraform.tfstate.backup terraform.tfstate

# 4. 验证 Chainy 资源未受影响
aws cloudfront get-distribution --id E17M3II142BC5E
aws s3 ls s3://chainy-prod-web
```

---

## 建议的导入策略

### 阶段 1: 只导入明确的 Portfolio 资源
```bash
# S3 + CloudFront（安全）
terraform import aws_s3_bucket.frontend aws-portfolio-liyu
terraform import aws_cloudfront_distribution.frontend E3CSSG3NLBDZHV
```

### 阶段 2: 确认 EC2 用途后再决定
```bash
# 先手动检查 EC2 上运行的服务
ssh -i your-key.pem ec2-user@3.83.248.118
# 查看是否运行 portfolio API

# 如果确认是 portfolio 用途，再导入
terraform import aws_instance.api_server i-02f2caee522bb3725
```

### 阶段 3: 创建新资源（推荐）
如果现有 EC2 用途不明确，考虑：
```bash
# 用 Terraform 创建新的 EC2 专门用于 portfolio
terraform apply
# 然后迁移服务到新 EC2
```

---

## 总结

**安全原则**: 宁可不导入，也不要误导入。

- ✅ **明确属于 Portfolio**: S3 (`aws-portfolio-liyu`), CloudFront (`E3CSSG3NLBDZHV`)
- ⚠️ **需要确认**: EC2 instances（用途不明确）
- ❌ **绝对禁止**: 任何 `chainy-*` 资源

**最安全的做法**: 只导入 S3 和 CloudFront，EC2 通过 Terraform 创建新的。
