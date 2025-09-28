# 🔐 GitHub Secrets Configuration Guide

## 📋 Required GitHub Secrets

To enable GitHub Actions to automatically deploy to AWS, you need to configure the following Secrets in your GitHub repository:

### 1. AWS Credentials
- **`AWS_ACCESS_KEY_ID`**: AWS access key ID
- **`AWS_SECRET_ACCESS_KEY`**: AWS secret access key

### 2. AWS Resource Configuration
- **`S3_BUCKET_NAME`**: S3 bucket name (must be globally unique)

### 3. Optional Configuration
- **`ALLOWED_ORIGINS`**: Allowed CORS origins (comma-separated)
- **`SECRET_KEY`**: Flask application secret key
- **`JWT_SECRET_KEY`**: JWT secret key

## 🛠️ Setup Steps

### Step 1: Create AWS IAM User

1. Log into AWS Console
2. Navigate to IAM service
3. Create new user:
   - Username: `github-actions-portfolio`
   - Access type: Programmatic access

4. Attach policies:
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

5. Download credentials file (CSV format)

### Step 2: Configure Secrets in GitHub

1. Go to your GitHub repository
2. Click **Settings** tab
3. Click **Secrets and variables** > **Actions** in the left menu
4. Click **New repository secret** button
5. Add the following Secrets one by one:

#### AWS_ACCESS_KEY_ID
- **Name**: `AWS_ACCESS_KEY_ID`
- **Value**: `Access key ID` from CSV file

#### AWS_SECRET_ACCESS_KEY
- **Name**: `AWS_SECRET_ACCESS_KEY`
- **Value**: `Secret access key` from CSV file

#### S3_BUCKET_NAME
- **Name**: `S3_BUCKET_NAME`
- **Value**: Your S3 bucket name (e.g., `my-portfolio-bucket-2024`)

#### ALLOWED_ORIGINS (Optional)
- **Name**: `ALLOWED_ORIGINS`
- **Value**: Allowed domains (e.g., `https://yourdomain.com,https://www.yourdomain.com`)

#### SECRET_KEY (Optional)
- **Name**: `SECRET_KEY`
- **Value**: Strong password (at least 32 characters)

#### JWT_SECRET_KEY (Optional)
- **Name**: `JWT_SECRET_KEY`
- **Value**: Strong password (at least 32 characters)

## 🔒 Security Best Practices

### 1. IAM Permission Minimization
Recommend using stricter IAM policies with only necessary permissions:

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

### 2. Regular Credential Rotation
- Rotate AWS access keys every 90 days
- Update corresponding values in GitHub Secrets

### 3. Monitoring and Logging
- Enable AWS CloudTrail to monitor API calls
- Set up CloudWatch alerts

## 🧪 Testing Secrets Configuration

### Method 1: Using GitHub Actions Test
Create a simple test workflow:

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

### Method 2: Using Local Test
```bash
# Set environment variables
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_SECRET_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"

# Test connection
aws sts get-caller-identity
```

## 🚨 Common Issues

### Q: Secrets configured but deployment still fails
**A**: Check the following:
1. Secret names are exactly correct (case-sensitive)
2. AWS credentials are valid
3. IAM user has sufficient permissions
4. S3 bucket name is globally unique

### Q: How to update Secrets
**A**: 
1. Go to GitHub repository Settings > Secrets and variables > Actions
2. Find the Secret to update
3. Click **Update** button
4. Enter new value and save

### Q: How to delete Secrets
**A**: 
1. Go to GitHub repository Settings > Secrets and variables > Actions
2. Find the Secret to delete
3. Click **Delete** button
4. Confirm deletion

## 📚 Related Resources

- [GitHub Secrets Documentation](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [AWS IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [AWS CLI Configuration Guide](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)