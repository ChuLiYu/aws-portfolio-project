# Terraform Import Guide - 导入现有 AWS 资源

## 概述
本指南帮助您将现有的 AWS 资源导入到 Terraform 管理中。

## 您的现有资源
根据扫描，您有以下资源：
- **S3 Bucket**: `aws-portfolio-liyu`
- **CloudFront Distribution**: `E3CSSG3NLBDZHV` (d278zt8g1aybxp.cloudfront.net)
- **EC2 Instances**: 
  - `i-02f2caee522bb3725` (ec2-dev-api-us-east-1a)
  - `i-0262707311b4bddbd` (Web Server from Module)

## 导入步骤

### Step 1: 初始化 Terraform
```bash
cd terraform
terraform init
```

### Step 2: 获取现有资源的详细配置

#### 2.1 获取 S3 配置
```bash
# 查看 S3 bucket 配置
aws s3api get-bucket-versioning --bucket aws-portfolio-liyu
aws s3api get-bucket-encryption --bucket aws-portfolio-liyu
aws s3api get-public-access-block --bucket aws-portfolio-liyu
aws s3api get-bucket-policy --bucket aws-portfolio-liyu
aws s3api get-bucket-tagging --bucket aws-portfolio-liyu 2>&1
```

#### 2.2 获取 CloudFront 配置
```bash
# 查看 CloudFront distribution 配置
aws cloudfront get-distribution --id E3CSSG3NLBDZHV > cloudfront-config.json
cat cloudfront-config.json | grep -A 5 "OriginAccessControlId"
```

#### 2.3 获取 EC2 配置
```bash
# 选择要导入的 EC2 instance
aws ec2 describe-instances --instance-ids i-02f2caee522bb3725 > ec2-config.json
aws ec2 describe-instances --instance-ids i-0262707311b4bddbd > ec2-config-2.json

# 查看安全组
aws ec2 describe-security-groups --filters "Name=group-name,Values=*portfolio*,*api*" --output table

# 查看 IAM instance profile
aws iam list-instance-profiles --query 'InstanceProfiles[?contains(InstanceProfileName, `portfolio`) || contains(InstanceProfileName, `api`)]'
```

### Step 3: 修改 Terraform 配置以匹配现有资源

在导入之前，您需要根据实际资源配置调整 `terraform/*.tf` 文件。

#### 3.1 修改 variables.tf 或创建 terraform.tfvars
```bash
cp terraform.tfvars.example terraform.tfvars
```

编辑 `terraform.tfvars`：
```hcl
aws_region        = "us-east-1"
environment       = "prod"
project_name      = "aws-portfolio-liyu"  # 匹配现有 bucket 名称
ec2_instance_type = "t3.micro"
# ... 其他变量根据实际情况填写
```

#### 3.2 更新 S3 bucket name
如果您的 bucket 名称是 `aws-portfolio-liyu`，确保 `s3.tf` 中的配置匹配：
```hcl
resource "aws_s3_bucket" "frontend" {
  bucket = "aws-portfolio-liyu"  # 必须与现有 bucket 完全一致
  # ...
}
```

### Step 4: 执行 Terraform Import

#### 4.1 导入 S3 Bucket
```bash
# 导入主 bucket
terraform import aws_s3_bucket.frontend aws-portfolio-liyu

# 导入 bucket versioning
terraform import aws_s3_bucket_versioning.frontend aws-portfolio-liyu

# 导入 bucket encryption
terraform import aws_s3_bucket_server_side_encryption_configuration.frontend aws-portfolio-liyu

# 导入 public access block
terraform import aws_s3_bucket_public_access_block.frontend aws-portfolio-liyu

# 导入 bucket policy (如果有)
terraform import aws_s3_bucket_policy.cloudfront_oac aws-portfolio-liyu
```

#### 4.2 导入 CloudFront Distribution
```bash
# 首先获取 OAC ID（如果使用）
aws cloudfront list-origin-access-controls --query 'OriginAccessControlList.Items[*].[Id,Name]' --output table

# 导入 OAC (替换 YOUR_OAC_ID)
terraform import aws_cloudfront_origin_access_control.s3_oac YOUR_OAC_ID

# 导入 CloudFront distribution
terraform import aws_cloudfront_distribution.frontend E3CSSG3NLBDZHV
```

#### 4.3 导入 EC2 及相关资源

**选择要管理的 EC2 instance**（建议选择 ec2-dev-api-us-east-1a）：

```bash
# 先获取相关资源 ID
INSTANCE_ID="i-02f2caee522bb3725"
SG_ID=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].SecurityGroups[0].GroupId' --output text)
PROFILE_NAME=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].IamInstanceProfile.Arn' --output text | cut -d'/' -f2)
ROLE_NAME=$(aws iam get-instance-profile --instance-profile-name $PROFILE_NAME --query 'InstanceProfile.Roles[0].RoleName' --output text 2>&1)

echo "Security Group: $SG_ID"
echo "Instance Profile: $PROFILE_NAME"
echo "IAM Role: $ROLE_NAME"

# 导入安全组
terraform import aws_security_group.api_server $SG_ID

# 导入 IAM Role (如果存在)
terraform import aws_iam_role.ec2_cloudwatch $ROLE_NAME

# 导入 IAM Instance Profile (如果存在)
terraform import aws_iam_instance_profile.ec2_profile $PROFILE_NAME

# 导入 IAM Role Policy (需要根据实际情况调整)
terraform import aws_iam_role_policy.cloudwatch_logs "${ROLE_NAME}/CloudWatchLogsPolicy"

# 导入 EC2 Instance
terraform import aws_instance.api_server $INSTANCE_ID
```

### Step 5: 验证导入结果

```bash
# 查看 Terraform state
terraform state list

# 检查是否有配置差异
terraform plan
```

**重要**: `terraform plan` 会显示实际资源与 Terraform 配置之间的差异。您需要：
1. **调整 Terraform 配置**以匹配现有资源（推荐）
2. **或者接受差异**，下次 `terraform apply` 时会修改资源

### Step 6: 调整配置消除差异

根据 `terraform plan` 的输出，修改 `.tf` 文件以消除不必要的差异：

```bash
# 例如，如果 CloudFront 的 price_class 不同
# 在 cloudfront.tf 中修改：
price_class = "PriceClass_All"  # 改为实际使用的 price class

# 如果 EC2 的 tags 不同
# 在 ec2.tf 中修改 tags 以匹配现有资源
```

**持续调整直到** `terraform plan` 显示：
```
No changes. Your infrastructure matches the configuration.
```

## 常见问题

### Q1: Import 失败："Resource already exists"
**A**: 该资源已经在 Terraform state 中，使用 `terraform state rm` 移除后重新导入：
```bash
terraform state rm aws_s3_bucket.frontend
terraform import aws_s3_bucket.frontend aws-portfolio-liyu
```

### Q2: 如何查看已导入的资源？
**A**: 使用以下命令：
```bash
terraform state list                          # 列出所有资源
terraform state show aws_s3_bucket.frontend   # 查看特定资源详情
```

### Q3: Plan 显示大量差异怎么办？
**A**: 有两种策略：
1. **修改 Terraform 配置**以匹配现有资源（推荐，保持现状）
2. **应用更改**以让资源符合新配置（可能造成中断）

**建议**: 对于生产环境，优先选择策略 1，保持服务稳定。

### Q4: CloudFront Distribution 导入后显示很多差异
**A**: CloudFront 配置非常复杂，有很多默认值。建议：
```bash
# 导出现有配置
aws cloudfront get-distribution-config --id E3CSSG3NLBDZHV > current-cf-config.json

# 对比并手动调整 cloudfront.tf
# 重点关注：origins, cache_behavior, viewer_certificate, logging_config
```

### Q5: 如何处理不需要的资源？
**A**: 如果某个资源（如第二台 EC2）不需要 Terraform 管理：
- 不导入它
- 或导入后使用 `terraform state rm` 移除

## 导入后的最佳实践

### 1. 备份 State 文件
```bash
# 在每次重要操作前备份
cp terraform.tfstate terraform.tfstate.backup.$(date +%Y%m%d_%H%M%S)
```

### 2. 使用远程 State（推荐）
```bash
# 创建 S3 bucket 存储 state
aws s3 mb s3://terraform-state-aws-portfolio-liyu

# 在 main.tf 中添加 backend 配置
terraform {
  backend "s3" {
    bucket = "terraform-state-aws-portfolio-liyu"
    key    = "portfolio/terraform.tfstate"
    region = "us-east-1"
  }
}

# 迁移本地 state 到 S3
terraform init -migrate-state
```

### 3. 启用 State Locking
```bash
# 创建 DynamoDB 表
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST

# 更新 backend 配置
terraform {
  backend "s3" {
    bucket         = "terraform-state-aws-portfolio-liyu"
    key            = "portfolio/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
```

### 4. 使用 Workspace（可选）
```bash
# 为不同环境创建 workspace
terraform workspace new prod
terraform workspace new dev
terraform workspace select prod
```

## 完整导入脚本示例

创建 `import.sh` 自动化导入过程：

```bash
#!/bin/bash
set -e

# 变量
S3_BUCKET="aws-portfolio-liyu"
CF_DIST_ID="E3CSSG3NLBDZHV"
EC2_INSTANCE="i-02f2caee522bb3725"

echo "=== 开始导入现有 AWS 资源到 Terraform ==="

# 初始化
terraform init

# 导入 S3
echo "导入 S3 Bucket..."
terraform import aws_s3_bucket.frontend $S3_BUCKET || echo "S3 bucket 已存在"
terraform import aws_s3_bucket_versioning.frontend $S3_BUCKET || echo "S3 versioning 已存在"
terraform import aws_s3_bucket_server_side_encryption_configuration.frontend $S3_BUCKET || echo "S3 encryption 已存在"
terraform import aws_s3_bucket_public_access_block.frontend $S3_BUCKET || echo "S3 public access block 已存在"

# 导入 CloudFront
echo "导入 CloudFront Distribution..."
terraform import aws_cloudfront_distribution.frontend $CF_DIST_ID || echo "CloudFront 已存在"

# 获取 EC2 相关资源 ID
echo "获取 EC2 相关资源..."
SG_ID=$(aws ec2 describe-instances --instance-ids $EC2_INSTANCE --query 'Reservations[0].Instances[0].SecurityGroups[0].GroupId' --output text)

# 导入 EC2
echo "导入 Security Group: $SG_ID"
terraform import aws_security_group.api_server $SG_ID || echo "Security Group 已存在"

echo "导入 EC2 Instance: $EC2_INSTANCE"
terraform import aws_instance.api_server $EC2_INSTANCE || echo "EC2 Instance 已存在"

# 验证
echo "=== 验证导入结果 ==="
terraform state list
echo ""
echo "=== 检查配置差异 ==="
terraform plan

echo "导入完成！请根据 terraform plan 的输出调整配置文件。"
```

## 下一步

导入完成后：
1. ✅ 运行 `terraform plan` 确认无意外更改
2. ✅ 提交 Terraform 配置到 Git
3. ✅ 设置远程 State Backend（S3 + DynamoDB）
4. ✅ 配置 GitHub Actions 自动化部署
5. ✅ 文档化任何手动配置的资源

## 参考资料
- [Terraform Import 官方文档](https://www.terraform.io/docs/cli/import/index.html)
- [AWS Provider Import Guide](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
