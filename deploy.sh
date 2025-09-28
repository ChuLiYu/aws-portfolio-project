#!/bin/bash

# AWS Portfolio 專案部署腳本
# AWS Portfolio Project Deployment Script

set -e

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置變數
AWS_REGION="us-east-1"
STACK_NAME="portfolio-stack"
BUCKET_NAME=""
DOMAIN_NAME=""
CERTIFICATE_ARN=""

# 函數：顯示幫助訊息
show_help() {
    echo -e "${BLUE}AWS Portfolio 專案部署腳本${NC}"
    echo ""
    echo "用法: $0 [選項]"
    echo ""
    echo "選項:"
    echo "  -b, --bucket BUCKET_NAME      S3 儲存桶名稱 (必須)"
    echo "  -d, --domain DOMAIN_NAME      自訂域名 (可選)"
    echo "  -c, --cert CERTIFICATE_ARN     SSL 憑證 ARN (可選)"
    echo "  -r, --region REGION           AWS 區域 (預設: us-east-1)"
    echo "  -s, --stack STACK_NAME        堆疊名稱 (預設: portfolio-stack)"
    echo "  -h, --help                    顯示此幫助訊息"
    echo ""
    echo "範例:"
    echo "  $0 --bucket my-portfolio-bucket"
    echo "  $0 --bucket my-portfolio-bucket --domain example.com --cert arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
    echo ""
}

# 函數：檢查 AWS CLI 是否安裝
check_aws_cli() {
    if ! command -v aws &> /dev/null; then
        echo -e "${RED}錯誤: AWS CLI 未安裝${NC}"
        echo "請先安裝 AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
        exit 1
    fi
}

# 函數：檢查 AWS 憑證
check_aws_credentials() {
    if ! aws sts get-caller-identity &> /dev/null; then
        echo -e "${RED}錯誤: AWS 憑證未設定或無效${NC}"
        echo "請執行 'aws configure' 設定您的 AWS 憑證"
        exit 1
    fi
}

# 函數：檢查必要檔案
check_required_files() {
    local missing_files=()
    
    if [[ ! -f "iac/cfn/template.yaml" ]]; then
        missing_files+=("iac/cfn/template.yaml")
    fi
    
    if [[ ! -d "frontend" ]]; then
        missing_files+=("frontend/")
    fi
    
    if [[ ! -f "api/app.py" ]]; then
        missing_files+=("api/app.py")
    fi
    
    if [[ ${#missing_files[@]} -gt 0 ]]; then
        echo -e "${RED}錯誤: 缺少必要檔案:${NC}"
        for file in "${missing_files[@]}"; do
            echo "  - $file"
        done
        exit 1
    fi
}

# 函數：驗證 S3 儲存桶名稱
validate_bucket_name() {
    if [[ -z "$BUCKET_NAME" ]]; then
        echo -e "${RED}錯誤: 必須指定 S3 儲存桶名稱${NC}"
        exit 1
    fi
    
    # 檢查儲存桶名稱格式
    if [[ ! "$BUCKET_NAME" =~ ^[a-z0-9.-]+$ ]]; then
        echo -e "${RED}錯誤: S3 儲存桶名稱只能包含小寫字母、數字、點和連字符${NC}"
        exit 1
    fi
    
    # 檢查儲存桶名稱長度
    if [[ ${#BUCKET_NAME} -lt 3 ]] || [[ ${#BUCKET_NAME} -gt 63 ]]; then
        echo -e "${RED}錯誤: S3 儲存桶名稱長度必須在 3-63 個字符之間${NC}"
        exit 1
    fi
}

# 函數：部署 CloudFormation 堆疊
deploy_stack() {
    echo -e "${BLUE}正在部署 CloudFormation 堆疊...${NC}"
    
    local parameters="ParameterKey=BucketName,ParameterValue=$BUCKET_NAME"
    
    if [[ -n "$DOMAIN_NAME" ]]; then
        parameters="$parameters ParameterKey=DomainName,ParameterValue=$DOMAIN_NAME"
    fi
    
    if [[ -n "$CERTIFICATE_ARN" ]]; then
        parameters="$parameters ParameterKey=CertificateArn,ParameterValue=$CERTIFICATE_ARN"
    fi
    
    # 檢查堆疊是否存在
    if aws cloudformation describe-stacks --stack-name "$STACK_NAME" --region "$AWS_REGION" &> /dev/null; then
        echo -e "${YELLOW}堆疊已存在，正在更新...${NC}"
        aws cloudformation update-stack \
            --stack-name "$STACK_NAME" \
            --template-body file://iac/cfn/template.yaml \
            --parameters $parameters \
            --capabilities CAPABILITY_IAM \
            --region "$AWS_REGION"
        
        echo -e "${YELLOW}等待堆疊更新完成...${NC}"
        aws cloudformation wait stack-update-complete \
            --stack-name "$STACK_NAME" \
            --region "$AWS_REGION"
    else
        echo -e "${YELLOW}堆疊不存在，正在建立...${NC}"
        aws cloudformation create-stack \
            --stack-name "$STACK_NAME" \
            --template-body file://iac/cfn/template.yaml \
            --parameters $parameters \
            --capabilities CAPABILITY_IAM \
            --region "$AWS_REGION"
        
        echo -e "${YELLOW}等待堆疊建立完成...${NC}"
        aws cloudformation wait stack-create-complete \
            --stack-name "$STACK_NAME" \
            --region "$AWS_REGION"
    fi
    
    echo -e "${GREEN}CloudFormation 堆疊部署完成！${NC}"
}

# 函數：上傳前端檔案到 S3
upload_frontend() {
    echo -e "${BLUE}正在上傳前端檔案到 S3...${NC}"
    
    # 上傳靜態資源（長快取）
    aws s3 sync frontend/ "s3://$BUCKET_NAME/" \
        --delete \
        --cache-control "max-age=31536000" \
        --exclude "*.html" \
        --exclude "*.css" \
        --region "$AWS_REGION"
    
    # 上傳 HTML 和 CSS 檔案（短快取）
    aws s3 sync frontend/ "s3://$BUCKET_NAME/" \
        --cache-control "max-age=3600" \
        --include "*.html" \
        --include "*.css" \
        --region "$AWS_REGION"
    
    echo -e "${GREEN}前端檔案上傳完成！${NC}"
}

# 函數：使 CloudFront 快取失效
invalidate_cloudfront() {
    echo -e "${BLUE}正在使 CloudFront 快取失效...${NC}"
    
    local distribution_id
    distribution_id=$(aws cloudformation describe-stacks \
        --stack-name "$STACK_NAME" \
        --region "$AWS_REGION" \
        --query 'Stacks[0].Outputs[?OutputKey==`CloudFrontDistributionId`].OutputValue' \
        --output text)
    
    if [[ "$distribution_id" != "None" ]] && [[ -n "$distribution_id" ]]; then
        aws cloudfront create-invalidation \
            --distribution-id "$distribution_id" \
            --paths "/*" \
            --region "$AWS_REGION"
        
        echo -e "${GREEN}CloudFront 快取失效完成！${NC}"
    else
        echo -e "${YELLOW}警告: 無法取得 CloudFront 分配 ID${NC}"
    fi
}

# 函數：部署 API 到 EC2
deploy_api() {
    echo -e "${BLUE}正在部署 API 到 EC2...${NC}"
    
    local instance_ip
    instance_ip=$(aws cloudformation describe-stacks \
        --stack-name "$STACK_NAME" \
        --region "$AWS_REGION" \
        --query 'Stacks[0].Outputs[?OutputKey==`ApiEndpoint`].OutputValue' \
        --output text | sed 's|http://||' | sed 's|/api/guestbook||')
    
    if [[ "$instance_ip" == "None" ]] || [[ -z "$instance_ip" ]]; then
        echo -e "${YELLOW}警告: 無法取得 EC2 實例 IP，跳過 API 部署${NC}"
        return
    fi
    
    echo -e "${YELLOW}EC2 實例 IP: $instance_ip${NC}"
    
    # 建立部署腳本
    cat > deploy-api.sh << 'EOF'
#!/bin/bash
set -e

# 更新系統
sudo yum update -y

# 安裝 Python 和依賴
sudo yum install -y python3 pip

# 建立應用程式目錄
sudo mkdir -p /var/www/api
sudo chown ec2-user:ec2-user /var/www/api
cd /var/www/api

# 停止現有服務
sudo systemctl stop api.service || true

# 複製應用程式檔案
# 這裡會從 GitHub Actions 或本地複製檔案

# 安裝 Python 依賴
pip3 install flask flask-cors gunicorn

# 建立 systemd 服務
sudo tee /etc/systemd/system/api.service > /dev/null << 'SERVICEEOF'
[Unit]
Description=Portfolio API
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/var/www/api
ExecStart=/usr/local/bin/gunicorn --bind 0.0.0.0:80 --workers 2 --timeout 30 app:app
Restart=always
RestartSec=10
Environment=FLASK_ENV=production
Environment=FLASK_DEBUG=False

[Install]
WantedBy=multi-user.target
SERVICEEOF

# 重新載入並啟動服務
sudo systemctl daemon-reload
sudo systemctl enable api.service
sudo systemctl start api.service

# 檢查服務狀態
sudo systemctl status api.service --no-pager
EOF
    
    # 複製部署腳本到 EC2
    scp -o StrictHostKeyChecking=no deploy-api.sh "ec2-user@$instance_ip:/tmp/"
    
    # 複製 API 檔案到 EC2
    scp -o StrictHostKeyChecking=no api/app.py "ec2-user@$instance_ip:/tmp/"
    
    # 執行部署腳本
    ssh -o StrictHostKeyChecking=no "ec2-user@$instance_ip" << 'SSHEOF'
chmod +x /tmp/deploy-api.sh
sudo cp /tmp/app.py /var/www/api/
/tmp/deploy-api.sh
SSHEOF
    
    echo -e "${GREEN}API 部署完成！${NC}"
}

# 函數：顯示部署結果
show_results() {
    echo -e "${GREEN}🎉 部署完成！${NC}"
    echo ""
    
    # 取得堆疊輸出
    local outputs
    outputs=$(aws cloudformation describe-stacks \
        --stack-name "$STACK_NAME" \
        --region "$AWS_REGION" \
        --query 'Stacks[0].Outputs')
    
    echo -e "${BLUE}📋 部署資訊:${NC}"
    echo "$outputs" | jq -r '.[] | "\(.OutputKey): \(.OutputValue)"'
    echo ""
    
    # 取得網站 URL
    local website_url
    website_url=$(aws cloudformation describe-stacks \
        --stack-name "$STACK_NAME" \
        --region "$AWS_REGION" \
        --query 'Stacks[0].Outputs[?OutputKey==`WebsiteURL`].OutputValue' \
        --output text)
    
    if [[ "$website_url" != "None" ]] && [[ -n "$website_url" ]]; then
        echo -e "${GREEN}🌐 網站 URL: $website_url${NC}"
    fi
    
    # 取得 API 端點
    local api_endpoint
    api_endpoint=$(aws cloudformation describe-stacks \
        --stack-name "$STACK_NAME" \
        --region "$AWS_REGION" \
        --query 'Stacks[0].Outputs[?OutputKey==`ApiEndpoint`].OutputValue' \
        --output text)
    
    if [[ "$api_endpoint" != "None" ]] && [[ -n "$api_endpoint" ]]; then
        echo -e "${GREEN}🔗 API 端點: $api_endpoint${NC}"
    fi
}

# 主函數
main() {
    echo -e "${BLUE}🚀 開始部署 AWS Portfolio 專案...${NC}"
    echo ""
    
    # 檢查前置條件
    check_aws_cli
    check_aws_credentials
    check_required_files
    validate_bucket_name
    
    # 部署流程
    deploy_stack
    upload_frontend
    invalidate_cloudfront
    deploy_api
    show_results
    
    echo -e "${GREEN}✅ 所有部署步驟完成！${NC}"
}

# 解析命令列參數
while [[ $# -gt 0 ]]; do
    case $1 in
        -b|--bucket)
            BUCKET_NAME="$2"
            shift 2
            ;;
        -d|--domain)
            DOMAIN_NAME="$2"
            shift 2
            ;;
        -c|--cert)
            CERTIFICATE_ARN="$2"
            shift 2
            ;;
        -r|--region)
            AWS_REGION="$2"
            shift 2
            ;;
        -s|--stack)
            STACK_NAME="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo -e "${RED}未知選項: $1${NC}"
            show_help
            exit 1
            ;;
    esac
done

# 執行主函數
main
