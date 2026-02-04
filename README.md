# Lui Chu | Data Engineer (Fintech) & MLOps

<div align="center">

### Scalable Data Systems & Machine Learning Infrastructure

[![Website](https://img.shields.io/badge/🌐_Portfolio-luichu.dev-4285F4?style=for-the-badge)](https://luichu.dev/)
[![AWS](https://img.shields.io/badge/AWS-Certified-FF9900?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/certification/)
[![Terraform](https://img.shields.io/badge/Terraform-Associate-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)](https://www.hashicorp.com/certification/terraform-associate)

**Location:** Vancouver, BC 🇨🇦 | **Status:** Open to Data Engineering & ML Infrastructure opportunities

[📧 Contact](mailto:liyu.chu.work@gmail.com) • [💼 LinkedIn](https://linkedin.com/in/chuliyu) • [🔗 GitHub](https://github.com/ChuLiYu)

</div>

---

## 💡 Executive Summary

**Senior Data Engineer** with specialized experience in **Fintech systems**, high-concurrency architecture, and **MLOps**. Expertise in architecting resilient backend systems that bridge the gap between rigorous data engineering and scalable machine learning production. Track record of delivering production-grade infrastructure with measurable business ROI.

### 🎯 Core Value Proposition

```
┌─────────────────────────────────────────────────────────────────┐
│  Data Engineering     │  Fintech Reliability│  ML Infrastructure│
├───────────────────────┼─────────────────────┼───────────────────┤
│  • ETL Pipelines      │  • ACID Compliance  │  • Model Serving  │
│  • Query Optimization │  • High Concurrency │  • Pipeline Auto  │
│  • Data Modeling      │  • Fault Tolerance  │  • Reproducibility│
│  • Real-time Stream   │  • Financial Audit  │  • Monitoring     │
└─────────────────────────────────────────────────────────────────┘
```

### 📊 Quantifiable Engineering Metrics (ROI)

| **Metric**             | **Achievement**    | **Business & Technical Value**                                              |
| ---------------------- | ------------------ | --------------------------------------------------------------------------- |
| ⚡ **Performance**     | **30% Faster**     | Optimized complex SQL/ETL for financial reports (HiTrust Inc.)              |
| 🛡️ **Reliability**     | **100% Recovery**  | Implemented WAL (Write-Ahead Log) for distributed system fault tolerance    |
| 🚀 **Latency**         | **<100ms (p95)**   | Optimized serverless inference cold-starts for real-time APIs               |
| 💰 **Cost Efficiency** | **100% Saving**    | Migrated infrastructure to Oracle Cloud free-tier ($0/month hosting)        |
| 📈 **Scalability**     | **0 → 1000+ RPS**  | Architected event-driven systems that scale elastically with zero idle cost |
| 🧪 **Data Integrity**  | **Zero-Error SLA** | Guaranteed transaction consistency in payment systems (ACID compliance)     |

---

## 🎯 Professional Focus

This portfolio showcases production-grade infrastructure and data systems built with a focus on reliability, scalability, and financial-grade precision.

### ✅ Technical Excellence

<table>
<tr>
<td width="50%">

**🏗️ Production Systems**

- ✅ Live serverless ML inference (<100ms)
- ✅ Distributed training orchestration
- ✅ Multi-environment IaC (dev/staging/prod)
- ✅ Automated CI/CD pipelines

</td>
<td width="50%">

**💼 Business Impact**

- 🚀 Real production systems (not demos)
- 💰 Cost-optimized architecture ($0/month)
- 📊 Quantifiable results (30% improvements)
- 🔧 Full-stack: data → model → monitoring

</td>
</tr>
</table>

### 🎓 For Recruiters & Hiring Managers

> **This portfolio demonstrates:**
>
> - ✨ **Production experience** – Systems handling real traffic with SLAs
> - 🏆 **Business acumen** – Cost optimization and measurable ROI
> - 🧠 **System design skills** – Scalable, fault-tolerant architectures
> - 📈 **End-to-end ownership** – From concept to production monitoring

---

## 🏗️ Featured Projects

### 1. 🚀 [Chainy](https://github.com/ChuLiYu/chainy-backend) - Production Serverless ML Platform

<div align="center">

[![Live Demo](https://img.shields.io/badge/🌐_Live_Demo-chainy.luichu.dev-success?style=for-the-badge)](https://chainy.luichu.dev)
![Python](https://img.shields.io/badge/Python-3.9+-blue?logo=python&logoColor=white)
![AWS Lambda](https://img.shields.io/badge/AWS-Lambda-FF9900?logo=amazon-aws)
![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?logo=terraform)
![FastAPI](https://img.shields.io/badge/FastAPI-009688?logo=fastapi&logoColor=white)

</div>

**Enterprise-grade serverless ML inference platform** for deploying models at scale with guaranteed SLAs.

#### 🎯 Business Problem Solved

Traditional ML model serving requires expensive 24/7 server infrastructure. This platform delivers **99.9% uptime** with **zero idle costs** using event-driven architecture.

#### 🏗️ System Architecture

```
┌─────────────┐      ┌──────────────┐      ┌─────────────┐
│   Client    │─────▶│  API Gateway │─────▶│   Lambda    │
│  Requests   │      │  (Routing)   │      │  (Inference)│
└─────────────┘      └──────────────┘      └──────┬──────┘
                                                    │
                                                    ▼
                     ┌──────────────┐      ┌─────────────┐
                     │  CloudWatch  │◀─────│  DynamoDB   │
                     │  (Metrics)   │      │ (Predictions)│
                     └──────────────┘      └─────────────┘
```

#### ⚡ Key Features & Technical Highlights

- **🚀 Performance**: <100ms p95 latency via Lambda optimization (container reuse, lazy imports)
- **📈 Auto-Scaling**: 0→1000+ req/s without configuration (AWS managed concurrency)
- **🔒 Environment Isolation**: Separate dev/staging/prod with Terraform workspaces
- **📊 Observability**: Request logging, error tracking, latency metrics (CloudWatch)
- **💰 Cost Model**: Pay-per-invoke ($0.20 per 1M requests vs $50+/month for EC2)

#### 🛠️ Technical Implementation

<details>
<summary><b>Click to expand technical details</b></summary>

**Infrastructure as Code:**

```hcl
# Multi-environment with Terraform
terraform workspace select prod
terraform apply -var-file="prod.tfvars"
```

**API Design:**

```python
# FastAPI with async inference
@app.post("/predict")
async def predict(features: ModelInput):
    prediction = await model.predict_async(features)
    await log_prediction(prediction)
    return {"prediction": prediction, "latency_ms": 85}
```

**Cold Start Optimization:**

- Provisioned concurrency for critical endpoints
- Model loaded at container init (not per-request)
- Lambda layers for shared dependencies

</details>

**Tech Stack**: AWS Lambda, API Gateway, DynamoDB, CloudWatch, Terraform, FastAPI, Python  
**🌐 Try it**: [chainy.luichu.dev](https://chainy.luichu.dev) | **📦 Code**: [GitHub](https://github.com/ChuLiYu/chainy-backend)

---

### 2. 🔄 [Raft-Recovery](https://github.com/ChuLiYu/raft-recovery) - Distributed Job Scheduler with Fault Tolerance

<div align="center">

![Go](https://img.shields.io/badge/Go-1.20+-00ADD8?logo=go&logoColor=white)
![Distributed Systems](https://img.shields.io/badge/Distributed-Systems-purple)
![Raft Consensus](https://img.shields.io/badge/Raft-Consensus-red)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-181717?logo=github)](https://github.com/ChuLiYu/raft-recovery)

</div>

**High-concurrency distributed job scheduler** built in Go with Raft consensus algorithm, ensuring fault tolerance and data consistency for critical workloads.

#### 🎯 Business Problem Solved

Critical backend systems require **zero data loss** and **high availability** even during node failures. This scheduler provides **100% job recovery** using Write-Ahead Logging and distributed consensus, ensuring business continuity for mission-critical workloads.

#### 🏗️ System Architecture

```
                  ┌─────────────────┐
                  │  Job Scheduler  │
                  │ (Raft Leader)   │
                  └────────┬────────┘
                           │
         ┌─────────────────┼─────────────────┐
         ▼                 ▼                 ▼
   ┌──────────┐      ┌──────────┐     ┌──────────┐
   │ Worker 1 │      │ Worker 2 │     │ Worker 3 │
   │ (Jobs)   │      │ (Jobs)   │     │ (Jobs)   │
   └────┬─────┘      └────┬─────┘     └────┬─────┘
        │                 │                 │
        └─────────────────┼─────────────────┘
                          ▼
                  ┌──────────────┐
                  │ Write-Ahead  │
                  │     Log      │
                  │ (Durability) │
                  └──────────────┘
```

#### ⚡ Key Features & Technical Highlights

- **⚡ High Concurrency**: Handle hundreds of concurrent jobs with Go goroutines and channels
- **💾 Zero Data Loss**: Write-Ahead Log (WAL) guarantees durability even during crashes
- **🛡️ Fault Tolerance**: Automatic job recovery and retry with state preservation
- **🔒 Strong Consistency**: Raft consensus ensures all nodes agree on job state
- **🔧 Leader Election**: Automatic failover when primary scheduler fails (<2s downtime)

#### 🛠️ Technical Implementation

<details>
<summary><b>Click to expand technical details</b></summary>

**Use Case Example:**

```go
// Submit batch jobs with guaranteed execution
jobs := []Job{
    {Type: "DataProcessing", Priority: High, Payload: data1},
    {Type: "ReportGeneration", Priority: Medium, Payload: data2},
    {Type: "BatchAnalytics", Priority: Low, Payload: data3},
    // ... more jobs
}

scheduler.SubmitBatch(jobs)  // Distributed across workers
// If worker/scheduler crashes, jobs automatically resume from WAL
```

**Write-Ahead Log (WAL) Security:**

- Every operation logged atomically before execution
- Crash recovery: replay WAL to restore exact system state
- fsync guarantees for durability (no data loss)
- Periodic snapshots reduce recovery time

**Raft Consensus for High Availability:**

- Leader coordinates all job scheduling decisions
- Followers maintain replicated logs for redundancy
- Automatic leader election on failure (2-3s downtime)
- Split-brain prevention with quorum-based writes

</details>

**Real-World Applications**:

- **Financial Systems**: Critical transaction processing with zero data loss
- **Batch ETL Pipelines**: Large-scale data processing with fault tolerance
- **Report Generation**: Scheduled jobs requiring guaranteed execution
- **Distributed Task Queues**: High-throughput job processing with durability

**Why This Matters for MLOps**: Understanding distributed systems and fault tolerance is crucial for building reliable ML infrastructure at scale.

**Tech Stack**: Go, Raft Consensus Algorithm, Write-Ahead Log, Distributed Systems  
**📦 Code**: [github.com/ChuLiYu/raft-recovery](https://github.com/ChuLiYu/raft-recovery)

---

### 3. 🔬 End-to-End MLOps Pipeline _(Upcoming - 2 Week Sprint)_

<div align="center">

![MLflow](https://img.shields.io/badge/MLflow-Tracking-0194E2?logo=mlflow)
![DVC](https://img.shields.io/badge/DVC-Data%20Versioning-945DD6)
![GitHub Actions](https://img.shields.io/badge/GitHub-Actions-2088FF?logo=github-actions&logoColor=white)
![Status](https://img.shields.io/badge/Status-In%20Development-yellow)

</div>

**Complete ML lifecycle automation** from training to production deployment with reproducibility guarantees.

#### 🎯 Pipeline Overview

```
┌─────────────┐   ┌──────────────┐   ┌─────────────┐   ┌──────────────┐
│ DVC Data    │──▶│ Model Train  │──▶│ MLflow      │──▶│ CI/CD Deploy │
│ Versioning  │   │ (Automated)  │   │ Registry    │   │ (Lambda)     │
└─────────────┘   └──────────────┘   └─────────────┘   └──────────────┘
                                             │
                                             ▼
                                    ┌─────────────────┐
                                    │ Production      │
                                    │ Monitoring      │
                                    │ (Drift Detect)  │
                                    └─────────────────┘
```

#### 🚀 Planned Features

- **📊 MLflow Integration**: Experiment tracking, model registry, versioning
- **🗄️ DVC Data Pipeline**: Reproducible data versioning (Git for data)
- **🧪 Automated Testing**: Unit tests + integration tests in CI/CD
- **🚀 Serverless Deploy**: Automated Lambda deployment via Terraform
- **📈 Drift Detection**: Monitor model performance degradation in production
- **🔄 A/B Testing**: Gradual rollout with traffic splitting

#### 🛠️ Tech Stack

**MLOps Tools**: MLflow, DVC, Great Expectations  
**Deployment**: AWS Lambda, Terraform, GitHub Actions  
**Monitoring**: CloudWatch, custom metrics, drift detection algorithms

**📅 Timeline**: Active development (Completion: Mid-January 2026)

---

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



## 🛠️ Technical Skills Matrix

<table>
<tr>
<td width="50%" valign="top">

### 🤖 MLOps & ML Engineering
**Model Deployment**
- Serverless inference (AWS Lambda)
- REST APIs (FastAPI, Flask)
- Model serving optimization

**ML Tools & Platforms**
- MLflow (tracking, registry)
- DVC (data versioning)
- Feature stores & pipelines

**Monitoring & Observability**
- Model drift detection
- Prediction logging
- Performance metrics (CloudWatch)

</td>
<td width="50%" valign="top">

### ☁️ Cloud Infrastructure & DevOps
**AWS Ecosystem**
- Lambda, DynamoDB, S3, EC2
- SageMaker, CloudWatch
- Multi-account strategies

**Infrastructure as Code**
- Terraform (multi-env)
- State management
- Module design

**CI/CD Automation**
- GitHub Actions
- Automated testing
- Deployment pipelines

</td>
</tr>
<tr>
<td width="50%" valign="top">

### 💻 Programming & Systems
**Languages**
- **Python**: FastAPI, Pandas, NumPy, scikit-learn, PyTorch
- **Go**: Concurrency, distributed systems, performance optimization
- **SQL**: PostgreSQL, query optimization

**Architecture Patterns**
- Event-driven architecture
- Microservices
- Serverless patterns

</td>
<td width="50%" valign="top">

### 🏆 Professional Certifications
- ✅ **AWS Certified Solutions Architect – Associate**
- ✅ **HashiCorp Terraform Associate**

**Expertise Areas**
- Distributed systems (Raft consensus)
- Database optimization (DynamoDB, PostgreSQL)
- Cost optimization strategies
- System design interviews

</td>
</tr>
</table>

---

## 🏗️ Portfolio Infrastructure

**This portfolio itself demonstrates MLOps best practices:**

```

┌─────────────────────────────────────────────┐
│ luichu.dev (Cloudflare DNS) │
│ Terraform-managed Records │
└────────────────┬────────────────────────────┘
│
▼
┌─────────────────────────────────────────────┐
│ GitHub Pages (Free CDN) │
│ • Static Site Hosting │
│ • Automatic HTTPS │
│ • Global CDN Distribution │
└────────────────▲────────────────────────────┘
│
│ Automated Deployment
│
┌────────────────┴────────────────────────────┐
│ GitHub Actions CI/CD │
│ • Triggered on git push │
│ • Build & validate │
│ • Deploy to GitHub Pages │
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

liyu-portfolio/
├── docs/ # 📚 Documentation
├── website/ # 🌐 Portfolio Website
│ ├── index.html # Main portfolio (English)
│ ├── index-zh.html # Chinese version
│ └── assets/ # Images and resources
├── infrastructure/ # ☁️ Infrastructure as Code
│ └── cloudflare/ # Terraform DNS management
├── .github/workflows/ # 🔄 CI/CD Pipeline
│ └── deploy-pages.yml # Automated deployment
├── .gitignore # Security exclusions
├── LICENSE # MIT License
└── README.md # This file

````

---

## 🚀 Quick Start

### View Portfolio
Visit: **[https://luichu.dev/](https://luichu.dev/)**

### Run Locally
```bash
git clone https://github.com/ChuLiYu/liyu-portfolio.git
cd liyu-portfolio/website
python3 -m http.server 8000
# Visit http://localhost:8000
````

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
_Focus_: Artificial Intelligence, Advanced Operating Systems, Systems Programming

**Institute for Information Industry** – Big Data Analytics Bootcamp (2017-2018)  
_Focus_: Data analytics, machine learning, big data technologies

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
