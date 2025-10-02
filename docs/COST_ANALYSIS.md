# Cost Analysis - Static Website Deployment

## Current Architecture Analysis

### Current Setup

- **S3 Bucket**: `aws-portfolio-liyu` (Static website hosting)
- **CloudFront Distribution**: `EOJPSKY8NNVO2` (CDN with custom domain)
- **Custom Domain**: `luichu.dev` with SSL certificate
- **EC2 Instance**: Not currently running (t3.micro when active)

### Cost Breakdown (Monthly Estimates)

#### S3 Storage

- **Storage**: ~1MB (HTML, CSS, images)
- **Cost**: $0.023 per GB = ~$0.000023/month
- **Requests**: Minimal (cached by CloudFront)
- **Cost**: ~$0.0004/month for 1,000 GET requests

#### CloudFront

- **Data Transfer**: ~1GB/month (estimated)
- **Cost**: $0.085 per GB = ~$0.085/month
- **Requests**: ~10,000/month
- **Cost**: $0.0075 per 10,000 requests = ~$0.0075/month

#### SSL Certificate

- **ACM Certificate**: Free for CloudFront
- **Cost**: $0/month

#### Custom Domain

- **Domain Registration**: ~$12/year = ~$1/month
- **DNS (Cloudflare)**: Free
- **Cost**: ~$1/month

#### EC2 (When Active)

- **t3.micro**: $8.47/month (if running 24/7)
- **EBS Storage**: ~$1/month for 8GB
- **Data Transfer**: Minimal
- **Cost**: ~$9.47/month

### Total Current Cost (Static Only)

- **S3**: ~$0.0004/month
- **CloudFront**: ~$0.09/month
- **Domain**: ~$1/month
- **Total**: ~$1.09/month

### Total Cost (With API)

- **Static**: ~$1.09/month
- **EC2**: ~$9.47/month
- **Total**: ~$10.56/month

---

## Cost Optimization Analysis

### ✅ Current Optimizations

1. **S3 Static Website Hosting**: Most cost-effective for static content
2. **CloudFront CDN**: Reduces S3 requests and improves performance
3. **PriceClass_100**: Only US, Canada, Europe (cheapest option)
4. **ACM SSL**: Free SSL certificate
5. **OAC**: Secure access without additional costs

### ❌ Potential Cost Reductions

#### 1. Remove EC2 Instance (If API Not Needed)

- **Savings**: ~$9.47/month
- **Impact**: No backend functionality
- **Recommendation**: Keep if guestbook/API features are required

#### 2. Use S3 Website Endpoint Instead of CloudFront

- **Current**: S3 + CloudFront = ~$0.09/month
- **Alternative**: S3 website endpoint = ~$0.0004/month
- **Savings**: ~$0.09/month
- **Trade-offs**:
  - No global CDN
  - No custom domain support
  - No HTTPS (unless using Cloudflare)
  - Slower loading times

#### 3. Use Cloudflare Free Plan

- **Current**: CloudFront + Custom Domain = ~$1.09/month
- **Alternative**: S3 + Cloudflare Free = ~$0.0004/month
- **Savings**: ~$1.08/month
- **Trade-offs**:
  - Less control over CDN settings
  - Cloudflare branding on free plan
  - Potential vendor lock-in

#### 4. Optimize CloudFront Settings

- **Current**: PriceClass_100 (US, Canada, Europe)
- **Alternative**: PriceClass_All (Global)
- **Cost Impact**: +~$0.02/month
- **Benefit**: Better global performance

---

## Recommended Architecture for Minimum Cost

### Option 1: Pure Static (No API)

```
Internet → Cloudflare (Free) → S3 Website Endpoint
```

- **Cost**: ~$0.0004/month (S3 only)
- **Features**: Static website, custom domain, HTTPS
- **Limitations**: No backend functionality

### Option 2: Static + Serverless API

```
Internet → Cloudflare (Free) → S3 Website Endpoint
                    ↓
              AWS Lambda (API Gateway)
```

- **Cost**: ~$0.0004/month (S3) + ~$0.20/month (Lambda) = ~$0.20/month
- **Features**: Static website + serverless API
- **Benefits**: Pay-per-request, no idle costs

### Option 3: Current Setup (Recommended)

```
Internet → CloudFront → S3 Bucket
```

- **Cost**: ~$1.09/month
- **Features**: Global CDN, custom domain, HTTPS, monitoring
- **Benefits**: Best performance, AWS integration, scalability

---

## Cost Comparison Table

| Architecture          | Monthly Cost | Features            | Performance | Scalability |
| --------------------- | ------------ | ------------------- | ----------- | ----------- |
| S3 Only               | $0.0004      | Basic static        | Slow        | Limited     |
| S3 + Cloudflare       | $0.0004      | Static + CDN        | Good        | Good        |
| S3 + CloudFront       | $1.09        | Static + CDN        | Excellent   | Excellent   |
| S3 + CloudFront + EC2 | $10.56       | Full-stack          | Excellent   | Excellent   |
| S3 + Lambda           | $0.20        | Static + Serverless | Good        | Excellent   |

---

## Recommendations

### For Portfolio Website (Current Use Case)

**Keep current architecture** - The $1.09/month cost is minimal for the benefits:

- Global CDN performance
- Custom domain support
- HTTPS security
- AWS integration
- Monitoring capabilities

### For Cost-Critical Applications

**Consider S3 + Cloudflare** if:

- Budget is extremely tight
- Global performance is not critical
- You're comfortable with Cloudflare's free plan limitations

### For High-Traffic Sites

**Current architecture is optimal** - CloudFront provides:

- Better performance than Cloudflare free plan
- More control over caching
- AWS ecosystem integration
- Professional-grade monitoring

---

## Cost Monitoring

### AWS Cost Explorer

- Set up billing alerts for $5, $10, $20 thresholds
- Monitor monthly spending trends
- Review cost breakdown by service

### CloudWatch Billing Alarms

```bash
# Create billing alarm
aws cloudwatch put-metric-alarm \
  --alarm-name "Portfolio-Monthly-Cost" \
  --alarm-description "Alert when monthly cost exceeds $5" \
  --metric-name EstimatedCharges \
  --namespace AWS/Billing \
  --statistic Maximum \
  --period 86400 \
  --threshold 5.0 \
  --comparison-operator GreaterThanThreshold \
  --evaluation-periods 1
```

### Regular Cost Reviews

- Monthly cost analysis
- Resource utilization review
- Optimization opportunity identification
- Budget vs. actual spending comparison

---

## Conclusion

The current architecture provides **excellent value for money** at ~$1.09/month:

- Professional-grade infrastructure
- Global CDN performance
- Custom domain support
- HTTPS security
- AWS ecosystem integration
- Monitoring and logging

For a portfolio website, this represents the **sweet spot** between cost and functionality. The additional cost compared to basic S3 hosting (~$1.08/month) provides significant value in terms of performance, security, and user experience.

**Recommendation**: Keep the current architecture unless budget constraints are extremely tight.

---

_Analysis Date: October 2, 2025_  
_Author: Lui Chu_  
_Project: AWS Portfolio Website_
