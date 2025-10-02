# DNS and CloudFront Migration - Troubleshooting Guide

## Overview

This document records the DNS configuration issues encountered during the migration from Cloudflare direct S3 hosting to AWS CloudFront distribution for the portfolio website, while maintaining the chainy URL shortener service functionality.

## Problem Description

### Initial State

- **Chainy Service**: `chainy.luichu.dev` → CloudFront (EOJPSKY8NNVO2) → S3 (chainy-prod-web)
- **Portfolio Website**: `luichu.dev` → Cloudflare → S3 Website Endpoint (aws-portfolio-liyu)

### Issues Encountered

1. **DNS Conflict**: Both services were configured to use the same CloudFront distribution
2. **SSL Handshake Failure**: Cloudflare trying to connect to S3 Website Endpoint via HTTPS
3. **Service Interruption**: Portfolio website returning 525/522 errors

## Root Cause Analysis

### Issue 1: DNS Configuration Conflict

**Problem**: The CloudFront distribution (EOJPSKY8NNVO2) was configured with both aliases:

- `chainy.luichu.dev` (for URL shortener)
- `luichu.dev` (for portfolio website)

**Root Cause**: Both services were pointing to the same CloudFront distribution, causing routing conflicts.

### Issue 2: SSL/TLS Configuration Mismatch

**Problem**: Cloudflare was configured with "Full" SSL mode, attempting HTTPS connection to S3 Website Endpoint.

**Root Cause**: S3 Website Endpoints only support HTTP, not HTTPS, causing SSL handshake failures.

### Issue 3: Origin Configuration Error

**Problem**: CloudFront was pointing to the wrong S3 bucket for the chainy service.

**Root Cause**: Origin was configured to point to `aws-portfolio-liyu.s3.us-east-1.amazonaws.com` instead of `chainy-prod-web.s3-website.ap-northeast-1.amazonaws.com`.

## Solution Implementation

### Step 1: Fix Chainy Service CloudFront Configuration

**Actions Taken**:

1. Updated CloudFront distribution (EOJPSKY8NNVO2) to only serve `chainy.luichu.dev`
2. Changed origin from `aws-portfolio-liyu.s3.us-east-1.amazonaws.com` to `chainy-prod-web.s3-website.ap-northeast-1.amazonaws.com`
3. Updated origin configuration to use Custom Origin instead of S3 Origin
4. Removed `luichu.dev` alias from the distribution

**Configuration Changes**:

```json
{
  "Aliases": {
    "Quantity": 1,
    "Items": ["chainy.luichu.dev"]
  },
  "Origins": {
    "Items": [
      {
        "Id": "chainy-origin",
        "DomainName": "chainy-prod-web.s3-website.ap-northeast-1.amazonaws.com",
        "CustomOriginConfig": {
          "HTTPPort": 80,
          "HTTPSPort": 443,
          "OriginProtocolPolicy": "http-only",
          "OriginSslProtocols": {
            "Quantity": 1,
            "Items": ["TLSv1.2"]
          }
        }
      }
    ]
  }
}
```

### Step 2: Create Dedicated CloudFront Distribution for Portfolio

**Actions Taken**:

1. Created new CloudFront distribution (E3CSSG3NLBDZHV) for portfolio website
2. Configured to serve `luichu.dev` only
3. Set up proper S3 Origin with Origin Access Control (OAC)
4. Updated S3 bucket policy to allow CloudFront access

**Configuration**:

```json
{
  "Aliases": {
    "Quantity": 1,
    "Items": ["luichu.dev"]
  },
  "Origins": {
    "Items": [
      {
        "Id": "portfolio-s3-origin",
        "DomainName": "aws-portfolio-liyu.s3.us-east-1.amazonaws.com",
        "S3OriginConfig": {
          "OriginAccessIdentity": "",
          "OriginReadTimeout": 30
        },
        "OriginAccessControlId": "E2SFGD3WRCWRMG"
      }
    ]
  }
}
```

### Step 3: Update S3 Bucket Policy

**Actions Taken**:

1. Enabled Public Access Block on S3 bucket
2. Created CloudFront-specific bucket policy
3. Removed public read access

**Bucket Policy**:

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
          "AWS:SourceArn": "arn:aws:cloudfront::277375108569:distribution/E3CSSG3NLBDZHV"
        }
      }
    }
  ]
}
```

### Step 4: DNS Configuration Update

**Actions Taken**:

1. Updated Cloudflare DNS record for `luichu.dev`
2. Changed CNAME target from S3 Website Endpoint to CloudFront distribution
3. Maintained proxy status (orange cloud)

**DNS Record**:

```
luichu.dev → CNAME → d278zt8g1aybxp.cloudfront.net (Proxied)
```

## Final Architecture

### Service Separation

```
Chainy URL Shortener:
chainy.luichu.dev → Cloudflare → CloudFront (EOJPSKY8NNVO2) → S3 (chainy-prod-web)

Portfolio Website:
luichu.dev → Cloudflare → CloudFront (E3CSSG3NLBDZHV) → S3 (aws-portfolio-liyu)
```

### Security Model

- **Chainy Service**: Custom Origin with HTTP-only protocol
- **Portfolio Service**: S3 Origin with Origin Access Control (OAC)
- **Both Services**: HTTPS termination at CloudFront level

## Lessons Learned

### 1. Service Isolation

- **Lesson**: Each service should have its own CloudFront distribution
- **Benefit**: Prevents configuration conflicts and allows independent scaling

### 2. Origin Configuration

- **Lesson**: S3 Website Endpoints vs S3 Origins have different requirements
- **Benefit**: Proper configuration ensures SSL compatibility and security

### 3. DNS Management

- **Lesson**: Cloudflare proxy status affects SSL handshake behavior
- **Benefit**: Understanding proxy modes helps troubleshoot connection issues

### 4. Security Best Practices

- **Lesson**: Use Origin Access Control instead of public S3 buckets
- **Benefit**: Maintains security while enabling CloudFront access

## Troubleshooting Commands

### Check DNS Resolution

```bash
dig chainy.luichu.dev
dig luichu.dev
```

### Test Service Connectivity

```bash
curl -I https://chainy.luichu.dev
curl -I https://luichu.dev
curl -I https://d278zt8g1aybxp.cloudfront.net
```

### Verify CloudFront Status

```bash
aws cloudfront get-distribution --id EOJPSKY8NNVO2 --query 'Distribution.Status'
aws cloudfront get-distribution --id E3CSSG3NLBDZHV --query 'Distribution.Status'
```

### Check S3 Bucket Policy

```bash
aws s3api get-bucket-policy --bucket aws-portfolio-liyu
aws s3api get-public-access-block --bucket aws-portfolio-liyu
```

## Cost Impact

### Before Migration

- **Portfolio**: S3 Website Endpoint (~$0.0004/month)
- **Total**: ~$0.0004/month

### After Migration

- **Portfolio**: CloudFront Distribution (~$0.09/month)
- **Chainy**: CloudFront Distribution (~$0.09/month)
- **Total**: ~$0.18/month

### Trade-offs

- **Cost**: Increased from ~$0.0004 to ~$0.18/month
- **Benefits**: Better security, performance, and AWS integration
- **Compliance**: Aligns with original project architecture design

## Future Recommendations

### 1. Monitoring

- Set up CloudWatch alarms for both distributions
- Monitor cost and performance metrics
- Implement health checks

### 2. Optimization

- Review cache policies for optimal performance
- Consider using CloudFront Functions for edge computing
- Implement proper error pages

### 3. Security

- Regular security audits of bucket policies
- Monitor access logs
- Consider WAF for additional protection

## Conclusion

The migration successfully resolved DNS conflicts and established proper service isolation. Both services now operate independently with their own CloudFront distributions, maintaining security and performance while aligning with the original AWS architecture design.

**Key Success Factors**:

1. Proper service isolation
2. Correct origin configuration
3. Appropriate security model
4. DNS configuration alignment

**Total Resolution Time**: ~2 hours
**Services Affected**: 2 (chainy, portfolio)
**Downtime**: Minimal (DNS propagation only)

---

_Document created: October 2, 2025_
_Author: Lui Chu_
_Project: AWS Portfolio Website_
