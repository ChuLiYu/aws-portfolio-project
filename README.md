# MLOps Portfolio

> **Live Site**: [https://luichu.dev/](https://luichu.dev/)  
> **Role**: MLOps Engineer | ML Infrastructure Specialist  
> **Location**: Vancouver, BC, Canada

Professional portfolio showcasing MLOps engineering expertise, production ML infrastructure projects, and cloud-native system design.

## 🎯 What This Repository Demonstrates

This portfolio showcases my capabilities in:

- ✅ **MLOps Infrastructure**: Serverless ML inference systems, distributed training orchestration
- ✅ **Infrastructure as Code**: Multi-environment Terraform management for ML workloads
- ✅ **Cloud Architecture**: AWS-certified solutions for scalable ML systems
- ✅ **CI/CD Automation**: GitHub Actions for automated deployment pipelines
- ✅ **Production Engineering**: Real, live systems with monitoring and fault tolerance

## 🚀 Featured Projects

### 1. [Chainy](https://chainy.luichu.dev) - Serverless ML Inference Infrastructure
Production-ready serverless platform architected for deploying ML models at scale using AWS Lambda, DynamoDB, and Terraform IaC.

**Tech Stack**: AWS Lambda, DynamoDB, Terraform, GitHub Actions  
**Highlights**: Auto-scaling, sub-100ms latency, multi-environment management

### 2. [Raft-Recovery](https://github.com/ChuLiYu/raft-recovery) - Distributed ML Training Orchestrator
Fault-tolerant job orchestration system engineered in Go for managing large-scale ML training workloads with Write-Ahead Log recovery.

**Tech Stack**: Go, Distributed Systems, Concurrency, WAL  
**Highlights**: Parallel job execution, crash recovery, optimized for multi-hour training

### 3. End-to-End MLOps Pipeline *(In Progress)*
Complete ML lifecycle automation with MLflow model registry, DVC data versioning, automated testing, and Lambda deployment.

**Tech Stack**: MLflow, DVC, FastAPI, AWS Lambda, Terraform  
**Highlights**: Model versioning, A/B testing, drift detection, automated deployment

## 📁 Repository Structure

```
mlops-portfolio/
├── docs/                       # 📚 Documentation
│   └── (Architecture diagrams, setup guides)
│
├── website/                    # 🌐 Portfolio Website
│   ├── index.html              # Main portfolio page
│   ├── index-zh.html           # Chinese version
│   ├── assets/                 # Images and resources
│   └── CNAME                   # Custom domain config
│
├── infrastructure/             # ☁️ Infrastructure as Code
│   ├── cloudflare/             # DNS management via Terraform
│   │   ├── main.tf             # Cloudflare DNS records
│   │   ├── variables.tf        # Configuration variables
│   │   └── README.md           # Setup instructions
│   └── README.md               # Infrastructure overview
│
├── .github/                    # 🔄 CI/CD Pipeline
│   └── workflows/
│       └── deploy-pages.yml    # Automated GitHub Pages deployment
│
├── .gitignore                  # Security: Excludes sensitive files
└── README.md                   # This file
```

## 🛠️ Tech Stack

### MLOps & ML Engineering
- **Model Deployment**: Serverless inference (AWS Lambda), FastAPI APIs
- **ML Tools**: MLflow (tracking & registry), DVC (data versioning)
- **Monitoring**: Model drift detection, prediction logging, CloudWatch

### Cloud Infrastructure
- **AWS**: Lambda, DynamoDB, S3, EC2, SageMaker, CloudWatch
- **Infrastructure as Code**: Terraform (multi-environment management)
- **CI/CD**: GitHub Actions, automated testing & deployment

### Backend & Systems
- **Languages**: Python (FastAPI, Pandas), Go (concurrency, distributed systems)
- **Architecture**: Event-driven, microservices, serverless, distributed job queues
- **Databases**: DynamoDB, PostgreSQL, Redis

### Certifications
- ✅ **AWS Solutions Architect – Associate**
- ✅ **HashiCorp Terraform Associate**

## 🏗️ Architecture

This portfolio itself demonstrates MLOps best practices:

```
┌─────────────────────────────────────────────┐
│      luichu.dev (Cloudflare DNS)            │
│         Terraform-managed Records            │
└────────────────┬────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────┐
│           GitHub Pages (Free CDN)           │
│                                             │
│  • Static Site Hosting                      │
│  • Automatic HTTPS                          │
│  • Global CDN Distribution                  │
└────────────────▲────────────────────────────┘
                 │
                 │ Automated Deployment
                 │
┌────────────────┴────────────────────────────┐
│          GitHub Actions CI/CD               │
│                                             │
│  • Triggered on git push                    │
│  • Build & validate website                 │
│  • Deploy to GitHub Pages                   │
└─────────────────────────────────────────────┘
```

**Infrastructure Philosophy**:
- ✅ **Zero-cost hosting** ($0/month) using GitHub Pages
- ✅ **Infrastructure as Code** for DNS management
- ✅ **Automated CI/CD** for reliable deployments
- ✅ **Production-ready** with HTTPS and global CDN

## 🚀 Quick Start

### View Portfolio
Simply visit: [https://luichu.dev/](https://luichu.dev/)

### Run Locally
```bash
# Clone the repository
git clone https://github.com/ChuLiYu/mlops-portfolio.git
cd mlops-portfolio

# Serve the website locally
cd website
python3 -m http.server 8000

# Visit http://localhost:8000
```

### Deploy Infrastructure
```bash
# Navigate to infrastructure directory
cd infrastructure/cloudflare

# Initialize Terraform
terraform init

# Review changes
terraform plan

# Apply DNS configuration
terraform apply
```

## 📊 Cost Analysis

| Component | Service | Cost |
|-----------|---------|------|
| Website Hosting | GitHub Pages | **$0/month** |
| DNS Management | Cloudflare Free Tier | **$0/month** |
| Domain | luichu.dev | ~$12/year |
| CI/CD | GitHub Actions (Free Tier) | **$0/month** |
| **Total** | | **$0/month** |

**Previous AWS Architecture**: $1-3/month (S3 + CloudFront)  
**Current Savings**: 100% reduction ($12-36/year saved)

## 🎓 Education

**Fairleigh Dickinson University**  
M.S. in Applied Computer Science (2025-2027)  
*Coursework*: Artificial Intelligence, Advanced Operating Systems, Systems Programming

**Institute for Information Industry**  
Big Data Analytics Bootcamp (2017-2018)  
*Focus*: Data analytics, machine learning, big data technologies

## 💼 Professional Experience

**HiTrust, Inc.** - Software Engineer (Backend) | *Jan 2023 – Dec 2024*
- Developed secure microservices for financial systems handling millions of requests
- Optimized data pipelines, improving report generation by 30%
- Managed Kubernetes deployments for production services

**Astra Technology** - Product Planner (Data & ML) | *Oct 2018 – Dec 2019*
- Built time-series prediction models using Python (Pandas)
- Led Computer Vision PoC collaboration with NTT Japan
- Defined technical requirements for ML model deployment

## 📫 Contact

**Email**: liyu.chu.work@gmail.com  
**GitHub**: [@ChuLiYu](https://github.com/ChuLiYu)  
**LinkedIn**: [linkedin.com/in/chuliyu](https://www.linkedin.com/in/chuliyu/)  
**Location**: Vancouver, BC, Canada

**Actively seeking**: MLOps Engineer, ML Infrastructure Engineer, Production ML roles

## 📄 License

This portfolio is open source under the MIT License. Feel free to fork and adapt for your own use.

---

**Built with**: HTML5, CSS3, JavaScript, Terraform, GitHub Actions  
**Hosted on**: GitHub Pages (Free CDN)  
**Managed by**: Infrastructure as Code (Terraform)

*Last updated: January 2026*
