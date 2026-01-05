# MLOps Portfolio

<p align="center">
  <img src="https://img.shields.io/badge/MLOps-Engineer-blue?style=for-the-badge" alt="MLOps Engineer"/>
  <img src="https://img.shields.io/badge/AWS-Certified-FF9900?style=for-the-badge&logo=amazon-aws&logoColor=white" alt="AWS Certified"/>
  <img src="https://img.shields.io/badge/Terraform-Associate-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" alt="Terraform"/>
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="License"/>
</p>

<p align="center">
  <strong>Live Site:</strong> <a href="https://luichu.dev/">luichu.dev</a> | 
  <strong>Role:</strong> MLOps Engineer & ML Infrastructure Specialist | 
  <strong>Location:</strong> Vancouver, BC, Canada
</p>

---

## 🎯 What This Demonstrates

**Production-Ready MLOps Infrastructure** built from the ground up, showcasing end-to-end ML system design, deployment, and operations.

- ✅ **Serverless ML Inference**: Sub-100ms latency model serving at scale (AWS Lambda + DynamoDB)
- ✅ **Distributed Training Orchestration**: Fault-tolerant job scheduler for multi-hour ML workloads
- ✅ **Infrastructure as Code**: Multi-environment Terraform automation (dev/staging/prod)
- ✅ **Production Engineering**: Real live systems with monitoring, auto-scaling, and crash recovery
- ✅ **CI/CD Automation**: GitHub Actions pipelines for automated ML model deployment

**Key Differentiators for Recruiters:**
- 🚀 Not just toy projects – **live production systems** you can test
- 💰 **Cost-optimized architecture** ($0/month hosting demonstrating cloud financial acumen)
- 📊 **Quantifiable results** (30% performance improvement, sub-100ms latency)
- ��️ **Full-stack MLOps** from data pipeline to model monitoring

---

## 🚀 Featured Projects

### 1. [Chainy](https://github.com/ChuLiYu/chainy-backend) - Serverless ML Inference Platform

![Python](https://img.shields.io/badge/Python-3.9+-blue?logo=python&logoColor=white)
![AWS Lambda](https://img.shields.io/badge/AWS-Lambda-FF9900?logo=amazon-aws)
![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?logo=terraform)
![FastAPI](https://img.shields.io/badge/FastAPI-009688?logo=fastapi&logoColor=white)

**Production-grade serverless ML inference platform** architected for deploying ML models at scale.

**Architecture:**
```
API Gateway → Lambda (Model Inference) → DynamoDB (Predictions)
                ↓
         CloudWatch Monitoring
```

**Key Features:**
- ⚡ **Sub-100ms inference latency** with optimized Lambda cold starts
- 📈 **Auto-scaling**: Handles 0 to 1000+ requests/sec automatically
- 🔒 **Multi-environment**: Separate dev/staging/prod with Terraform
- 📊 **Monitoring**: Prediction logging + performance metrics (CloudWatch)
- 💰 **Cost-efficient**: Pay-per-request serverless model

**Tech Stack**: AWS Lambda, DynamoDB, Terraform, FastAPI, Python  
**Live Demo**: [chainy.luichu.dev](https://chainy.luichu.dev)

---

### 2. [Raft-Recovery](https://github.com/ChuLiYu/raft-recovery) - Distributed Training Orchestrator

![Go](https://img.shields.io/badge/Go-1.20+-00ADD8?logo=go&logoColor=white)
![Distributed Systems](https://img.shields.io/badge/Distributed-Systems-purple)
![Raft Consensus](https://img.shields.io/badge/Raft-Consensus-red)

**Fault-tolerant job orchestration system** engineered in Go for managing large-scale ML training workloads.

**Architecture:**
```
Job Scheduler (Raft Consensus) → Worker Nodes (Parallel Training)
        ↓
  Write-Ahead Log (WAL)
        ↓
  Crash Recovery System
```

**Key Features:**
- 🔄 **Parallel job execution**: Run multiple training jobs simultaneously
- 💾 **Crash recovery**: Write-Ahead Log ensures no data loss on failures
- 🎯 **Optimized for ML**: Designed for multi-hour training workloads
- ⚡ **Go concurrency**: Efficient resource utilization with goroutines
- 🔧 **Distributed consensus**: Raft algorithm for job coordination

**Use Case**: When you need to train multiple ML models (hyperparameter tuning, ensemble methods) with fault tolerance guarantees.

**Tech Stack**: Go, Raft Consensus, WAL, Distributed Systems  
**Repo**: [github.com/ChuLiYu/raft-recovery](https://github.com/ChuLiYu/raft-recovery)

---

### 3. End-to-End MLOps Pipeline *(In Progress)*

![MLflow](https://img.shields.io/badge/MLflow-Tracking-0194E2?logo=mlflow)
![DVC](https://img.shields.io/badge/DVC-Data%20Versioning-945DD6)
![GitHub Actions](https://img.shields.io/badge/GitHub-Actions-2088FF?logo=github-actions&logoColor=white)

**Complete ML lifecycle automation** from training to production deployment.

**Pipeline:**
```
Data Versioning (DVC) → Model Training → MLflow Registry → Automated Testing → Lambda Deployment
                                 ↓
                        Model Monitoring (Drift Detection)
```

**Planned Features:**
- 📊 **MLflow integration**: Model tracking, registry, and versioning
- ��️ **DVC data versioning**: Reproducible training data management
- 🧪 **Automated testing**: Unit tests + integration tests in CI/CD
- 🚀 **Lambda deployment**: Automated model serving with Terraform
- 📈 **Drift detection**: Monitor model performance in production

**Tech Stack**: MLflow, DVC, FastAPI, AWS Lambda, Terraform, GitHub Actions  
**Status**: Active development (2-week timeline)

---

## 🛠️ Technical Skills

### MLOps & ML Engineering
- **Model Deployment**: Serverless inference (AWS Lambda), REST APIs (FastAPI)
- **ML Tools**: MLflow (experiment tracking), DVC (data versioning)
- **Monitoring**: Model drift detection, prediction logging, performance metrics
- **Pipeline Orchestration**: Custom Go orchestrator, job scheduling

### Cloud Infrastructure
- **AWS Services**: Lambda, DynamoDB, S3, EC2, SageMaker, CloudWatch
- **Infrastructure as Code**: Terraform (multi-environment, state management)
- **CI/CD**: GitHub Actions (automated testing, deployment pipelines)
- **Cost Optimization**: Serverless architecture, right-sizing, monitoring

### Backend & Systems Programming
- **Languages**: 
  - Python (FastAPI, Pandas, NumPy, scikit-learn)
  - Go (concurrency, distributed systems, performance-critical code)
- **Architecture Patterns**: Event-driven, microservices, serverless
- **Databases**: DynamoDB, PostgreSQL, Redis
- **Distributed Systems**: Consensus algorithms (Raft), fault tolerance, replication

### Professional Certifications
- ✅ **AWS Certified Solutions Architect – Associate**
- ✅ **HashiCorp Terraform Associate**

---

## 🏗️ Portfolio Architecture

**This portfolio itself demonstrates MLOps best practices:**

```
┌─────────────────────────────────────────────┐
│      luichu.dev (Cloudflare DNS)            │
│         Terraform-managed Records            │
└────────────────┬────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────┐
│           GitHub Pages (Free CDN)           │
│  • Static Site Hosting                      │
│  • Automatic HTTPS                          │
│  • Global CDN Distribution                  │
└────────────────▲────────────────────────────┘
                 │
                 │ Automated Deployment
                 │
┌────────────────┴────────────────────────────┐
│          GitHub Actions CI/CD               │
│  • Triggered on git push                    │
│  • Build & validate                         │
│  • Deploy to GitHub Pages                   │
└─────────────────────────────────────────────┘
```

**Design Principles:**
- ✅ **Zero-cost hosting** ($0/month) – Cloud cost optimization in action
- ✅ **Infrastructure as Code** – All DNS managed with Terraform
- ✅ **Automated CI/CD** – No manual deployments
- ✅ **Production-ready** – HTTPS, CDN, monitoring

---

## 📊 Impact & Results

| Project | Metric | Result |
|---------|--------|--------|
| **Chainy** | Inference Latency | **<100ms** (p95) |
| **Chainy** | Scalability | **0 → 1000+ req/sec** auto-scaling |
| **Raft-Recovery** | Fault Tolerance | **100%** crash recovery with WAL |
| **HiTrust (Professional)** | Performance Improvement | **30%** faster report generation |
| **Portfolio Infrastructure** | Monthly Cost | **$0** (was $1-3 on AWS) |

---

## 💼 Professional Experience

**HiTrust, Inc.** – Software Engineer (Backend) | *Jan 2023 – Dec 2024*
- Developed secure microservices for financial systems handling **millions of requests**
- **Optimized data pipelines**, improving report generation performance by **30%**
- Managed **Kubernetes deployments** for production services (container orchestration)
- Implemented monitoring and logging infrastructure for production systems

**Astra Technology** – Product Planner (Data & ML) | *Oct 2018 – Dec 2019*
- Built **time-series prediction models** using Python (Pandas, NumPy)
- Led **Computer Vision PoC** collaboration with NTT Japan
- Defined technical requirements for ML model deployment to production

---

## 📁 Repository Structure

```
mlops-portfolio/
├── docs/                       # 📚 Documentation
├── website/                    # 🌐 Portfolio Website
│   ├── index.html              # Main portfolio (English)
│   ├── index-zh.html           # Chinese version
│   └── assets/                 # Images and resources
├── infrastructure/             # ☁️ Infrastructure as Code
│   └── cloudflare/             # Terraform DNS management
├── .github/workflows/          # 🔄 CI/CD Pipeline
│   └── deploy-pages.yml        # Automated deployment
├── .gitignore                  # Security exclusions
├── LICENSE                     # MIT License
└── README.md                   # This file
```

---

## 🚀 Quick Start

### View Portfolio
Visit: **[https://luichu.dev/](https://luichu.dev/)**

### Run Locally
```bash
git clone https://github.com/ChuLiYu/mlops-portfolio.git
cd mlops-portfolio/website
python3 -m http.server 8000
# Visit http://localhost:8000
```

### Deploy Infrastructure
```bash
cd infrastructure/cloudflare
terraform init
terraform plan
terraform apply
```

---

## 🎓 Education

**Fairleigh Dickinson University** – M.S. Applied Computer Science (2025-2027)  
*Focus*: Artificial Intelligence, Advanced Operating Systems, Systems Programming

**Institute for Information Industry** – Big Data Analytics Bootcamp (2017-2018)  
*Focus*: Data analytics, machine learning, big data technologies

---

## 📫 Contact & Links

<p align="center">
  <a href="mailto:liyu.chu.work@gmail.com"><img src="https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white"/></a>
  <a href="https://github.com/ChuLiYu"><img src="https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white"/></a>
  <a href="https://linkedin.com/in/chuliyu"><img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white"/></a>
  <a href="https://luichu.dev"><img src="https://img.shields.io/badge/Portfolio-000000?style=for-the-badge&logo=google-chrome&logoColor=white"/></a>
</p>

**📍 Location**: Vancouver, BC, Canada  
**💼 Actively Seeking**: MLOps Engineer | ML Infrastructure Engineer | Production ML Roles  
**📧 Email**: liyu.chu.work@gmail.com

---

## 📄 License

MIT License – Open source and free to use. See [LICENSE](LICENSE) file for details.

---

<p align="center">
  <strong>Built with:</strong> HTML5, CSS3, JavaScript, Terraform, GitHub Actions<br/>
  <strong>Hosted on:</strong> GitHub Pages (Free CDN)<br/>
  <strong>Managed by:</strong> Infrastructure as Code (Terraform)<br/><br/>
  <em>Last updated: January 2026</em>
</p>
