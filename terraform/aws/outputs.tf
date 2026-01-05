output "cloudfront_domain" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.frontend.domain_name
}

output "cloudfront_url" {
  description = "CloudFront distribution URL"
  value       = "https://${aws_cloudfront_distribution.frontend.domain_name}"
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.frontend.id
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.frontend.id
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.frontend.arn
}

# Cost estimation output
output "estimated_monthly_cost" {
  description = "Estimated monthly cost breakdown"
  value = <<-EOT
  
  估计月度成本 (基于 us-east-1):
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  S3 存储 (10GB):              $0.23
  S3 请求 (10k GET):           $0.004
  CloudFront 数据传输 (10GB):  $0.85
  CloudFront 请求 (10k):       $0.01
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  总计:                        ~$1.10/月
  
  注意: 
  - 使用 Free Tier 可能 $0
  - 实际成本取决于流量
  - 详见 docs/COST_OPTIMIZATION.md
  EOT
}
