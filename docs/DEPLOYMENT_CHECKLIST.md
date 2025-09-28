# 🚀 GitHub Automated Deployment Checklist

## 📋 Pre-deployment Checklist

### ✅ 1. GitHub Repository Setup

#### Basic Configuration
- [ ] Create GitHub repository
- [ ] Upload all project files
- [ ] Verify `.github/workflows/deploy.yml` exists
- [ ] Confirm all required files are in correct locations

#### File Structure Check
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
├── scripts/
│   └── deploy.sh               ✅
└── docs/                       ✅
```

### ✅ 2. AWS Account Preparation

#### AWS Account Setup
- [ ] Confirm AWS account is active
- [ ] Verify sufficient credits
- [ ] Confirm permissions in target region (us-east-1)

#### IAM User Creation
- [ ] Create IAM user: `github-actions-portfolio`
- [ ] Attach necessary policies
- [ ] Download access keys (CSV file)
- [ ] Test AWS CLI connection

### ✅ 3. GitHub Secrets Configuration

#### Required Secrets
- [ ] `AWS_ACCESS_KEY_ID` - AWS access key ID
- [ ] `AWS_SECRET_ACCESS_KEY` - AWS secret access key
- [ ] `S3_BUCKET_NAME` - S3 bucket name (globally unique)

#### Optional Secrets
- [ ] `ALLOWED_ORIGINS` - CORS allowed origins
- [ ] `SECRET_KEY` - Flask secret key
- [ ] `JWT_SECRET_KEY` - JWT secret key

### ✅ 4. S3 Bucket Preparation

#### Bucket Naming
- [ ] Choose globally unique bucket name
- [ ] Confirm name follows S3 naming rules
- [ ] Record bucket name for Secrets configuration

#### Example Bucket Names
```
your-name-portfolio-2024
your-company-portfolio-site
my-awesome-portfolio-bucket
```

### ✅ 5. Code Review

#### API Review
- [ ] Confirm `api/app.py` has no syntax errors
- [ ] Confirm all dependencies in `requirements.txt`
- [ ] Confirm Dockerfile is correctly configured
- [ ] Test local API functionality

#### Frontend Review
- [ ] Confirm all HTML files exist
- [ ] Confirm CSS and image files are complete
- [ ] Test local frontend display

#### CloudFormation Review
- [ ] Confirm `template.yaml` syntax is correct
- [ ] Confirm all parameters have default values
- [ ] Confirm resource naming follows conventions

### ✅ 6. Security Review

#### Security Configuration
- [ ] Confirm all sensitive data uses environment variables
- [ ] Confirm CORS settings are correct
- [ ] Confirm rate limiting is enabled
- [ ] Confirm input validation is implemented

#### Permission Review
- [ ] Confirm IAM policies follow least privilege principle
- [ ] Confirm security group rules are correct
- [ ] Confirm SSH access is restricted

## 🚀 Deployment Process

### Step 1: Push to GitHub
```bash
# Initialize Git repository
git init
git add .
git commit -m "Initial commit: AWS Portfolio with CI/CD"

# Add remote repository
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
git branch -M main
git push -u origin main
```

### Step 2: Configure GitHub Secrets
1. Go to GitHub repository
2. Click **Settings** > **Secrets and variables** > **Actions**
3. Add all required Secrets (refer to `GITHUB_SECRETS_GUIDE.md`)

### Step 3: Trigger Deployment
- **Automatic deployment**: Push to `main` branch will automatically trigger deployment
- **Manual deployment**: Go to **Actions** tab, manually run workflow

### Step 4: Monitor Deployment
1. Go to **Actions** tab
2. View deployment progress
3. Check logs for errors
4. Wait for deployment completion

## 🔍 Post-deployment Verification

### Check CloudFormation Stack
```bash
aws cloudformation describe-stacks \
  --stack-name portfolio-stack \
  --region us-east-1
```

### Check S3 Bucket
```bash
aws s3 ls s3://YOUR_BUCKET_NAME/
```

### Check EC2 Instance
```bash
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=portfolio-stack-API" \
  --region us-east-1
```

### Test Website
1. Get website URL from CloudFormation outputs
2. Open website in browser
3. Test API endpoints
4. Test guestbook functionality

## 🚨 Troubleshooting

### Common Errors

#### 1. CloudFormation Stack Creation Failed
**Possible causes**:
- S3 bucket name already exists
- Insufficient IAM permissions
- Resource limits

**Solutions**:
- Check S3 bucket name is unique
- Confirm IAM user has sufficient permissions
- Check AWS service limits

#### 2. GitHub Actions Failed
**Possible causes**:
- Incorrect Secrets configuration
- Invalid AWS credentials
- Code syntax errors

**Solutions**:
- Check Secret names and values
- Test AWS credentials
- Check code syntax

#### 3. API Deployment Failed
**Possible causes**:
- EC2 instance not accessible
- SSH connection failed
- Service startup failed

**Solutions**:
- Check security group settings
- Confirm SSH key configuration
- Check EC2 instance logs

### Log Viewing
```bash
# CloudFormation events
aws cloudformation describe-stack-events \
  --stack-name portfolio-stack \
  --region us-east-1

# EC2 instance logs
aws ec2 get-console-output \
  --instance-id i-1234567890abcdef0 \
  --region us-east-1
```

## 📞 Support Resources

### Documentation Links
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [AWS CloudFormation Documentation](https://docs.aws.amazon.com/cloudformation/)
- [AWS CLI Documentation](https://docs.aws.amazon.com/cli/)

### Community Support
- [GitHub Community Forum](https://github.community/)
- [AWS Developer Forum](https://forums.aws.amazon.com/)
- [Stack Overflow](https://stackoverflow.com/)

## ✅ Completion Checklist

After deployment, confirm the following:

- [ ] Website is accessible
- [ ] API endpoints respond correctly
- [ ] Guestbook functionality works
- [ ] CloudFront caching is working
- [ ] Monitoring and logging are active
- [ ] Security settings are correct

🎉 **Congratulations! Your AWS Portfolio project has been successfully deployed with automated CI/CD!**