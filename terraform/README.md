# Portfolio Infrastructure with Terraform

This directory contains all Infrastructure as Code (IaC) for the AWS Portfolio project, organized by cloud provider.

## 📁 Directory Structure

```
terraform/
├── aws/                    # AWS resources (S3, CloudFront)
│   ├── main.tf            # Provider and data sources
│   ├── variables.tf       # Input variables
│   ├── s3.tf             # S3 bucket configuration
│   ├── cloudfront.tf     # CloudFront distribution
│   ├── outputs.tf        # Output values
│   └── terraform.tfvars  # Variable values (gitignored)
│
├── cloudflare/            # DNS management
│   ├── main.tf           # Cloudflare DNS records
│   ├── terraform.tfvars  # Cloudflare credentials (gitignored)
│   └── README.md         # Cloudflare setup guide
│
├── docs/                  # Documentation
│   ├── IMPORT_GUIDE.md   # Guide for importing existing resources
│   └── RESOURCE_MAPPING.md # Resource ownership mapping
│
└── scripts/               # Utility scripts
    └── import.sh         # Automated import script
```

## 🚀 Quick Start

### AWS Resources (S3 + CloudFront)

```bash
# 1. Navigate to AWS directory
cd terraform/aws

# 2. Copy example variables
cp terraform.tfvars.example terraform.tfvars

# 3. Initialize Terraform
terraform init

# 4. Import existing resources (if any)
cd ../scripts
./import.sh

# 5. Review changes
cd ../aws
terraform plan

# 6. Apply configuration
terraform apply
```

### Cloudflare DNS

```bash
# 1. Navigate to Cloudflare directory
cd terraform/cloudflare

# 2. Setup credentials (see cloudflare/README.md)
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your API token and Zone ID

# 3. Initialize and apply
terraform init
terraform plan
terraform apply
```

## 🔧 Configuration

### AWS Resources

Edit `aws/terraform.tfvars`:

```hcl
aws_region        = "us-east-1"
environment       = "prod"
project_name      = "aws-portfolio"
```

### Cloudflare DNS

Edit `cloudflare/terraform.tfvars`:

```hcl
cloudflare_api_token = "your-api-token"
zone_id              = "your-zone-id"
```

## 📊 Resource Management

### Current AWS Resources
- ✅ S3 Bucket: `aws-portfolio-liyu` (Frontend hosting)
- ✅ CloudFront Distribution: `E3CSSG3NLBDZHV` (CDN for luichu.dev)

### Current DNS Records
- ✅ luichu.dev → GitHub Pages (A records)
- ✅ www.luichu.dev → GitHub Pages (CNAME)

## 💰 Cost Estimation

### AWS (S3 + CloudFront only)
- **Free Tier eligible**: $0-2/month
- **After Free Tier**: ~$1-3/month (low traffic)

See [../docs/COST_OPTIMIZATION.md](../docs/COST_OPTIMIZATION.md) for details.

### Cloudflare
- **Free** (using Free plan)

## 🛡️ Security Best Practices

1. **Never commit sensitive files**:
   - `terraform.tfvars` (contains secrets)
   - `*.tfstate` (may contain sensitive data)
   - `.terraform/` directory

2. **Use remote state** (recommended for production):
   ```hcl
   terraform {
     backend "s3" {
       bucket = "terraform-state-aws-portfolio"
       key    = "aws/terraform.tfstate"
       region = "us-east-1"
     }
   }
   ```

3. **Enable state locking** with DynamoDB

## 📖 Documentation

- [IMPORT_GUIDE.md](docs/IMPORT_GUIDE.md) - How to import existing AWS resources
- [RESOURCE_MAPPING.md](docs/RESOURCE_MAPPING.md) - Resource ownership and protection
- [COST_OPTIMIZATION.md](../docs/COST_OPTIMIZATION.md) - Cost analysis and optimization

## 🔄 Common Commands

```bash
# AWS
cd terraform/aws
terraform init          # Initialize
terraform plan          # Preview changes
terraform apply         # Apply changes
terraform destroy       # Destroy resources
terraform state list    # List managed resources

# Cloudflare
cd terraform/cloudflare
terraform init
terraform plan
terraform apply

# Import existing resources
cd terraform/scripts
./import.sh
```

## ⚠️ Important Notes

1. **Separate State Files**: AWS and Cloudflare use separate state files
   - AWS: `terraform/aws/terraform.tfstate`
   - Cloudflare: `terraform/cloudflare/terraform.tfstate`

2. **No Shared Resources**: Changes in one module don't affect the other

3. **Chainy Project Protection**: This Terraform configuration will NOT affect Chainy project resources (chainy.luichu.dev)

## 🆘 Troubleshooting

### Import Issues
- Check [docs/IMPORT_GUIDE.md](docs/IMPORT_GUIDE.md)
- Run `terraform state list` to see managed resources
- Use `terraform state rm` to remove incorrect imports

### State Conflicts
```bash
# If state is locked
terraform force-unlock <LOCK_ID>

# If state is corrupted
cp terraform.tfstate.backup terraform.tfstate
```

### Authentication Errors
```bash
# AWS
aws configure

# Cloudflare
# Check your API token in terraform.tfvars
```

## 📞 Support

For issues or questions:
1. Check documentation in `docs/`
2. Review Terraform logs: `TF_LOG=DEBUG terraform plan`
3. See [TROUBLESHOOTING.md](../docs/TROUBLESHOOTING.md)

---

**Last Updated**: 2026-01-04
**Terraform Version**: >= 1.0
**AWS Provider**: ~> 5.0
**Cloudflare Provider**: ~> 4.0
