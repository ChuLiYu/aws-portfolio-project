# 🏗️ Project Architecture

## Overview

This AWS Portfolio project implements a modern, scalable web application using AWS cloud services with automated CI/CD deployment.

## Architecture Components

### Frontend Layer
- **S3 Static Website Hosting**: Stores HTML, CSS, and static assets
- **CloudFront CDN**: Global content delivery with caching
- **HTTPS Encryption**: SSL/TLS security for all communications

### Backend Layer
- **EC2 Instance**: Hosts Flask API application
- **Gunicorn WSGI Server**: Production-ready Python web server
- **Rate Limiting**: DDoS protection and resource management

### Infrastructure Layer
- **CloudFormation**: Infrastructure as Code (IaC)
- **IAM Roles**: Secure AWS service access
- **Security Groups**: Network access control
- **CloudWatch**: Monitoring and logging

### CI/CD Pipeline
- **GitHub Actions**: Automated deployment workflow
- **Docker**: Containerized application deployment
- **AWS CLI**: Deployment automation scripts

## Security Features

- Input validation and XSS protection
- Rate limiting and DDoS protection
- CORS configuration
- HTTPS encryption
- IAM least privilege access
- Container security (non-root user)

## Deployment Flow

1. Code push to GitHub triggers CI/CD pipeline
2. Tests and builds application
3. Deploys CloudFormation stack
4. Uploads frontend to S3
5. Deploys API to EC2
6. Invalidates CloudFront cache
7. Verifies deployment success

## Cost Optimization

- Uses t3.micro EC2 instances for cost efficiency
- CloudFront caching reduces S3 requests
- Automated scaling and resource management
- Pay-per-use pricing model