# DNS Terraform Configuration for GitHub Pages

This Terraform configuration updates DNS records in Cloudflare to point `luichu.dev` and `www.luichu.dev` to GitHub Pages.

## Prerequisites

1. Cloudflare API Token with DNS edit permissions
2. Cloudflare Zone ID for `luichu.dev`

## Setup Steps

### 1. Get Cloudflare API Token

1. Go to: https://dash.cloudflare.com/profile/api-tokens
2. Click "Create Token"
3. Use template: "Edit zone DNS"
4. Select: Zone Resources → Include → Specific zone → `luichu.dev`
5. Copy the token

### 2. Get Zone ID

1. Go to Cloudflare Dashboard
2. Select `luichu.dev` domain
3. Scroll down in Overview → Zone ID (right sidebar)
4. Copy the Zone ID

### 3. Configure Variables

```bash
cd dns-terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your actual values
```

### 4. Apply Configuration

```bash
# Initialize Terraform
terraform init

# Preview changes (IMPORTANT: Review before applying!)
terraform plan

# Apply changes
terraform apply
```

### 5. Verify DNS

```bash
# Wait 1-2 minutes, then check:
dig luichu.dev
dig www.luichu.dev

# Should show GitHub Pages IPs:
# 185.199.108.153
# 185.199.109.153
# 185.199.110.153
# 185.199.111.153
```

### 6. Enable Custom Domain in GitHub

1. Go to: https://github.com/ChuLiYu/aws-portfolio-project/settings/pages
2. Under "Custom domain", enter: `luichu.dev`
3. Click "Save"
4. Wait for DNS check to pass (few minutes)
5. Enable "Enforce HTTPS"

## What This Does

- ✅ Updates `luichu.dev` → GitHub Pages
- ✅ Updates `www.luichu.dev` → GitHub Pages
- ✅ Keeps `chainy.luichu.dev` unchanged
- ✅ Disables Cloudflare Proxy (required for GitHub Pages)

## Important Notes

- **Proxied must be false**: GitHub Pages doesn't work with Cloudflare proxy
- **Existing records preserved**: Only updates specified records
- **Other subdomains unaffected**: `chainy.luichu.dev` stays the same

## Rollback

To rollback, point the CNAME back to CloudFront:

```bash
# Edit main.tf and change the root domain record back, then:
terraform apply
```

Or delete the Terraform-managed records and recreate manually in Cloudflare dashboard.
