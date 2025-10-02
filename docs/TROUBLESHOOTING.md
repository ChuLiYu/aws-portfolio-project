# AWS Portfolio Project - Troubleshooting Guide

## Overview
This document records the troubleshooting process and solutions for deploying a portfolio website on AWS using S3, CloudFront, and custom domain configuration.

## Problem Summary
- **Domain**: `luichu.dev`
- **Issue**: Website showing blank page with 403 errors for CSS/JS resources
- **Infrastructure**: AWS S3 + CloudFront + Custom Domain

---

## Issue #1: DNS Resolution Failure

### Problem Description
- **Error**: `DNS_PROBE_FINISHED_NXDOMAIN`
- **Symptom**: Domain `luichu.dev` could not be resolved
- **Root Cause**: Missing DNS records for the custom domain

### Investigation Steps
```bash
# Check DNS resolution
nslookup luichu.dev
dig luichu.dev

# Check CloudFront distribution
aws cloudfront list-distributions --region us-east-1
```

### Solution
1. **Added custom domain to CloudFront distribution**:
   ```bash
   aws cloudfront update-distribution \
     --id EOJPSKY8NNVO2 \
     --distribution-config file:///tmp/cloudfront-update.json \
     --if-match EPD09FZ4K08U0 \
     --region us-east-1
   ```

2. **Configured DNS records in Cloudflare**:
   ```
   Type: CNAME
   Name: luichu.dev
   Target: d3hdtwr5zmjki6.cloudfront.net
   Proxy Status: Disabled (gray cloud)
   ```

### Result
- Domain successfully resolved to CloudFront IP addresses
- DNS propagation completed within 5-15 minutes

---

## Issue #2: Wrong S3 Bucket Configuration

### Problem Description
- **Error**: Website showing CHAINY URL shortener instead of portfolio
- **Root Cause**: CloudFront distribution pointing to wrong S3 bucket (`chainy-prod-web` instead of `aws-portfolio-liyu`)

### Investigation Steps
```bash
# Check CloudFront origin configuration
aws cloudfront get-distribution --id EOJPSKY8NNVO2 --region us-east-1 \
  --query 'Distribution.DistributionConfig.Origins.Items[0]'

# List S3 buckets
aws s3 ls | grep -i portfolio
aws s3 ls s3://aws-portfolio-liyu/
```

### Solution
1. **Updated CloudFront origin**:
   - Changed from: `chainy-prod-web.s3.ap-northeast-1.amazonaws.com`
   - Changed to: `aws-portfolio-liyu.s3.us-east-1.amazonaws.com`

2. **Configured S3 bucket for website hosting**:
   ```bash
   aws s3api put-bucket-website \
     --bucket aws-portfolio-liyu \
     --region us-east-1 \
     --website-configuration '{"IndexDocument":{"Suffix":"index.html"},"ErrorDocument":{"Key":"index.html"}}'
   ```

3. **Uploaded portfolio files**:
   ```bash
   aws s3 sync frontend/ s3://aws-portfolio-liyu/ --region us-east-1 --delete
   ```

### Result
- CloudFront distribution now serves correct portfolio content
- S3 bucket properly configured for static website hosting

---

## Issue #3: S3 Permissions Conflict

### Problem Description
- **Error**: 403 Forbidden for CSS/JS resources
- **Symptom**: Blank white page with console errors
- **Root Cause**: Conflicting S3 permissions (public access + OAC)

### Investigation Steps
```bash
# Check S3 bucket policy
aws s3api get-bucket-policy --bucket aws-portfolio-liyu --region us-east-1

# Check public access block settings
aws s3api get-public-access-block --bucket aws-portfolio-liyu --region us-east-1

# Test resource access
curl -I https://d3hdtwr5zmjki6.cloudfront.net/index-BWHL81kB.css
```

### Solution
1. **Removed conflicting public access policy**:
   ```bash
   aws s3api delete-bucket-policy --bucket aws-portfolio-liyu --region us-east-1
   ```

2. **Configured OAC-specific bucket policy**:
   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Sid": "AllowCloudFrontServicePrincipal",
         "Effect": "Allow",
         "Principal": {
           "Service": "cloudfront.amazonaws.com"
         },
         "Action": "s3:GetObject",
         "Resource": "arn:aws:s3:::aws-portfolio-liyu/*",
         "Condition": {
           "StringEquals": {
             "AWS:SourceArn": "arn:aws:cloudfront::277375108569:distribution/EOJPSKY8NNVO2"
           }
         }
       }
     ]
   }
   ```

3. **Enabled public access block**:
   ```bash
   aws s3api put-public-access-block \
     --bucket aws-portfolio-liyu \
     --region us-east-1 \
     --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
   ```

4. **Invalidated CloudFront cache**:
   ```bash
   aws cloudfront create-invalidation \
     --distribution-id EOJPSKY8NNVO2 \
     --paths "/*" \
     --region us-east-1
   ```

### Result
- S3 bucket now only accessible through CloudFront OAC
- 403 errors resolved
- Website loads correctly

---

## Issue #4: Browser Cache Issues

### Problem Description
- **Error**: Browser still showing 403 errors for non-existent resources
- **Symptom**: Console errors for `index-BWHL81kB.css`, `index-DQQWzcdl.js`, `vite.svg`
- **Root Cause**: Browser caching old HTML with incorrect resource references

### Investigation Steps
```bash
# Verify current HTML content
curl -s https://luichu.dev/ | grep -E "(BWHL81kB|DQQWzcdl|vite\.svg)"

# Check if resources exist in S3
aws s3 ls s3://aws-portfolio-liyu/ --recursive | grep -E "(BWHL81kB|DQQWzcdl|vite\.svg)"
```

### Solution
**Browser-side fixes**:
1. **Clear browser cache**:
   - Chrome: `Cmd + Shift + Delete` → Select "Cached images and files" → Clear
   - Or use incognito mode: `Cmd + Shift + N`

2. **Force refresh**:
   - `Cmd + Shift + R` (Mac) or `Ctrl + Shift + R` (Windows)

3. **Alternative testing**:
   - Access CloudFront URL directly: `https://d3hdtwr5zmjki6.cloudfront.net`

### Result
- Browser cache cleared
- Website displays correctly
- No more 403 errors in console

---

## Final Configuration

### Infrastructure Summary
- **S3 Bucket**: `aws-portfolio-liyu` (us-east-1)
- **CloudFront Distribution**: `EOJPSKY8NNVO2`
- **Domain**: `luichu.dev`
- **SSL Certificate**: ACM certificate for `luichu.dev`
- **Access Method**: Origin Access Control (OAC)

### Key Files
- **HTML**: `index.html`, `index-zh.html` (self-contained with embedded CSS)
- **Assets**: `assets/images/profile/avatar.jpg`
- **Styles**: Embedded in HTML files

### Security Configuration
- S3 bucket: Private with OAC-only access
- CloudFront: HTTPS redirect enabled
- SSL: TLS 1.2+ with SNI

---

## Lessons Learned

### Best Practices
1. **Use OAC instead of OAI** for new CloudFront distributions
2. **Avoid mixing public S3 access with OAC** - choose one method
3. **Always invalidate CloudFront cache** after content updates
4. **Test with direct CloudFront URL** before custom domain
5. **Clear browser cache** when troubleshooting display issues

### Common Pitfalls
1. **DNS propagation delays** (5-15 minutes)
2. **CloudFront deployment time** (5-15 minutes)
3. **Browser cache interference** with troubleshooting
4. **S3 region mismatches** between bucket and CloudFront
5. **SSL certificate region requirements** (must be in us-east-1 for CloudFront)

### Monitoring Commands
```bash
# Check CloudFront status
aws cloudfront get-distribution --id EOJPSKY8NNVO2 --region us-east-1 \
  --query 'Distribution.Status'

# Check DNS resolution
dig luichu.dev

# Test website response
curl -I https://luichu.dev/

# Check S3 bucket contents
aws s3 ls s3://aws-portfolio-liyu/ --recursive
```

---

## References
- [AWS CloudFront Documentation](https://docs.aws.amazon.com/cloudfront/)
- [AWS S3 Static Website Hosting](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html)
- [CloudFront Origin Access Control](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html)
- [DNS Propagation Guide](https://www.whatsmydns.net/)

---

*Last Updated: October 2, 2025*
*Author: Lui Chu*
*Project: AWS Portfolio Website*
