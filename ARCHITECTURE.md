# Architecture & Decisions

## Diagram (Text)
[Viewer] --HTTPS--> [CloudFront (OAC)] --Read--> [S3 (private)]
(Optional) Frontend --> /api/* --> [EC2 (Flask)] behind Security Group

## Key Choices
- **S3 private + CloudFront OAC**: no public bucket, follows AWS best practice.
- **OIDC for CI/CD**: GitHub Actions assumes an IAM role; no static keys.
- **Least Privilege**: S3 (bucket-only) + CloudFront (CreateInvalidation) permissions.

## Cost Control
- S3/CloudFront within Free Tier for typical portfolio traffic.
- EC2 t2.micro Free Tier; stop instance when idle.
