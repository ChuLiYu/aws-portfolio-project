#!/bin/bash
set -e

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# ========================================
# 资源定义 - PORTFOLIO 项目专用
# ========================================
# ⚠️ 警告: 只导入 Portfolio 项目资源
# ❌ 绝对不要导入 Chainy 项目资源！

# Portfolio 项目资源
S3_BUCKET="aws-portfolio-liyu"
CF_DIST_ID="E3CSSG3NLBDZHV"  # luichu.dev (Portfolio Website)

# ⚠️ EC2 选择 - 请手动确认用途后再取消注释
# EC2_INSTANCE="i-02f2caee522bb3725"  # ec2-dev-api-us-east-1a
# EC2_INSTANCE="i-0262707311b4bddbd"  # Web Server from Module
EC2_INSTANCE=""  # 默认不导入，需要手动确认

# Chainy 项目资源（禁止导入）
CHAINY_CF_DIST="E17M3II142BC5E"  # chainy.luichu.dev
CHAINY_BUCKETS=("chainy-prod-web" "chainy-prod-chainy-events" "chainy-terraform-state-lui-20240930")

echo -e "${GREEN}=== 开始导入现有 AWS 资源到 Terraform ===${NC}"
echo -e "${YELLOW}项目: Portfolio (aws-portfolio-liyu)${NC}"
echo -e "${RED}⚠️  不会影响 Chainy 项目 (chainy.luichu.dev)${NC}"
echo ""

# 检查是否在正确的目录
if [ ! -f "../aws/main.tf" ] && [ ! -f "main.tf" ]; then
    echo -e "${RED}错误: 请在 terraform/scripts 或 terraform/aws 目录下运行此脚本${NC}"
    exit 1
fi

# 切换到 aws 目录
if [ -f "../aws/main.tf" ]; then
    cd ../aws
    echo -e "${GREEN}切换到 terraform/aws 目录${NC}"
fi

# 验证资源归属
echo -e "${YELLOW}=== 验证资源归属 ===${NC}"
echo -e "将导入的资源:"
echo -e "  S3 Bucket: ${GREEN}$S3_BUCKET${NC}"
echo -e "  CloudFront: ${GREEN}$CF_DIST_ID${NC}"
if [ -n "$EC2_INSTANCE" ]; then
    echo -e "  EC2 Instance: ${GREEN}$EC2_INSTANCE${NC}"
else
    echo -e "  EC2 Instance: ${YELLOW}未指定（需要手动确认用途）${NC}"
fi
echo ""
echo -e "${RED}禁止导入的 Chainy 资源:${NC}"
echo -e "  CloudFront: ${RED}$CHAINY_CF_DIST (chainy.luichu.dev)${NC}"
for bucket in "${CHAINY_BUCKETS[@]}"; do
    echo -e "  S3 Bucket: ${RED}$bucket${NC}"
done
echo ""
read -p "确认只导入 Portfolio 项目资源？(yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo -e "${YELLOW}取消导入${NC}"
    exit 0
fi

# 检查 AWS CLI
if ! command -v aws &> /dev/null; then
    echo -e "${RED}错误: 未找到 AWS CLI${NC}"
    exit 1
fi

# 检查 Terraform
if ! command -v terraform &> /dev/null; then
    echo -e "${RED}错误: 未找到 Terraform${NC}"
    exit 1
fi

# 初始化
echo -e "${YELLOW}初始化 Terraform...${NC}"
terraform init

# 函数：安全导入（如果已存在则跳过）
safe_import() {
    local resource=$1
    local id=$2
    echo -e "${YELLOW}导入 $resource...${NC}"
    if terraform import "$resource" "$id" 2>&1 | grep -q "Resource already managed"; then
        echo -e "${GREEN}✓ $resource 已存在，跳过${NC}"
    else
        echo -e "${GREEN}✓ $resource 导入成功${NC}"
    fi
}

# 导入 S3 相关资源
echo -e "\n${GREEN}=== 导入 S3 资源 ===${NC}"
safe_import "aws_s3_bucket.frontend" "$S3_BUCKET"
safe_import "aws_s3_bucket_versioning.frontend" "$S3_BUCKET"
safe_import "aws_s3_bucket_server_side_encryption_configuration.frontend" "$S3_BUCKET"
safe_import "aws_s3_bucket_public_access_block.frontend" "$S3_BUCKET"

# 尝试导入 S3 bucket policy（可能不存在）
echo -e "${YELLOW}尝试导入 S3 Bucket Policy...${NC}"
if aws s3api get-bucket-policy --bucket "$S3_BUCKET" &> /dev/null; then
    safe_import "aws_s3_bucket_policy.cloudfront_oac" "$S3_BUCKET"
else
    echo -e "${YELLOW}⚠ S3 Bucket Policy 不存在，跳过${NC}"
fi

# 导入 CloudFront
echo -e "\n${GREEN}=== 导入 CloudFront 资源 ===${NC}"

# 获取 OAC ID（如果存在）
OAC_ID=$(aws cloudfront get-distribution --id "$CF_DIST_ID" 2>/dev/null | grep -o '"OriginAccessControlId"[^"]*"[^"]*"' | cut -d'"' -f4 || echo "")
if [ -n "$OAC_ID" ] && [ "$OAC_ID" != "null" ]; then
    echo -e "${YELLOW}找到 Origin Access Control: $OAC_ID${NC}"
    safe_import "aws_cloudfront_origin_access_control.s3_oac" "$OAC_ID"
else
    echo -e "${YELLOW}⚠ 未找到 Origin Access Control，可能使用 OAI 或公开访问${NC}"
fi

safe_import "aws_cloudfront_distribution.frontend" "$CF_DIST_ID"

# 导入 EC2 相关资源
echo -e "\n${GREEN}=== 导入 EC2 相关资源 ===${NC}"

if [ -z "$EC2_INSTANCE" ]; then
    echo -e "${YELLOW}⚠️  EC2_INSTANCE 未设置，跳过 EC2 导入${NC}"
    echo -e "${YELLOW}如需导入 EC2，请先确认其用途并在脚本中设置 EC2_INSTANCE 变量${NC}"
else
# 获取 Security Group ID
echo -e "${YELLOW}获取 EC2 Security Group...${NC}"
SG_ID=$(aws ec2 describe-instances --instance-ids "$EC2_INSTANCE" --query 'Reservations[0].Instances[0].SecurityGroups[0].GroupId' --output text 2>/dev/null || echo "")
if [ -n "$SG_ID" ] && [ "$SG_ID" != "None" ]; then
    echo -e "${GREEN}找到 Security Group: $SG_ID${NC}"
    safe_import "aws_security_group.api_server" "$SG_ID"
else
    echo -e "${YELLOW}⚠ 未找到 Security Group${NC}"
fi

# 获取 IAM Instance Profile
echo -e "${YELLOW}获取 IAM Instance Profile...${NC}"
PROFILE_ARN=$(aws ec2 describe-instances --instance-ids "$EC2_INSTANCE" --query 'Reservations[0].Instances[0].IamInstanceProfile.Arn' --output text 2>/dev/null || echo "")
if [ -n "$PROFILE_ARN" ] && [ "$PROFILE_ARN" != "None" ]; then
    PROFILE_NAME=$(echo "$PROFILE_ARN" | cut -d'/' -f2)
    echo -e "${GREEN}找到 Instance Profile: $PROFILE_NAME${NC}"
    
    # 获取 IAM Role
    ROLE_NAME=$(aws iam get-instance-profile --instance-profile-name "$PROFILE_NAME" --query 'InstanceProfile.Roles[0].RoleName' --output text 2>/dev/null || echo "")
    if [ -n "$ROLE_NAME" ] && [ "$ROLE_NAME" != "None" ]; then
        echo -e "${GREEN}找到 IAM Role: $ROLE_NAME${NC}"
        safe_import "aws_iam_role.ec2_cloudwatch" "$ROLE_NAME"
        safe_import "aws_iam_instance_profile.ec2_profile" "$PROFILE_NAME"
        
        # 尝试导入 inline policies
        echo -e "${YELLOW}检查 IAM Role Policies...${NC}"
        POLICIES=$(aws iam list-role-policies --role-name "$ROLE_NAME" --query 'PolicyNames' --output text 2>/dev/null || echo "")
        if [ -n "$POLICIES" ]; then
            for policy_name in $POLICIES; do
                echo -e "${YELLOW}找到 Inline Policy: $policy_name${NC}"
                safe_import "aws_iam_role_policy.cloudwatch_logs" "${ROLE_NAME}/${policy_name}"
            done
        else
            echo -e "${YELLOW}⚠ 未找到 Inline Policies${NC}"
        fi
    else
        echo -e "${YELLOW}⚠ 未找到 IAM Role${NC}"
    fi
else
    echo -e "${YELLOW}⚠ EC2 Instance 没有 IAM Instance Profile${NC}"
fi

# 导入 EC2 Instance
safe_import "aws_instance.api_server" "$EC2_INSTANCE"
fi  # 结束 EC2_INSTANCE 检查

# 验证导入结果
echo -e "\n${GREEN}=== 导入完成！验证结果 ===${NC}"
echo -e "${YELLOW}已导入的资源列表:${NC}"
terraform state list

# 检查配置差异
echo -e "\n${GREEN}=== 检查配置差异 ===${NC}"
echo -e "${YELLOW}运行 terraform plan 检查实际资源与配置的差异...${NC}"
terraform plan -detailed-exitcode || {
    EXIT_CODE=$?
    if [ $EXIT_CODE -eq 2 ]; then
        echo -e "\n${YELLOW}⚠ 发现配置差异！${NC}"
        echo -e "${YELLOW}请根据上面的 plan 输出调整 .tf 文件以匹配现有资源${NC}"
        echo -e "${YELLOW}或者确认这些差异是预期的更改${NC}"
    elif [ $EXIT_CODE -eq 1 ]; then
        echo -e "\n${RED}✗ Terraform plan 执行失败${NC}"
        exit 1
    fi
}

echo -e "\n${GREEN}=== 下一步 ===${NC}"
echo -e "1. 查看上面的 terraform plan 输出"
echo -e "2. 调整 .tf 文件以消除不必要的差异"
echo -e "3. 重新运行 terraform plan 直到显示 'No changes'"
echo -e "4. 提交配置到 Git: git add . && git commit -m 'Import existing AWS resources'"
echo -e "5. 考虑设置远程 State Backend (S3 + DynamoDB)"
echo -e "\n${GREEN}导入脚本执行完成！${NC}"
