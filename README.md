# 🚀 AWS Portfolio Project

A modern, production-ready portfolio website featuring AWS cloud deployment, automated CI/CD, and enterprise-grade security.

## ✨ Features

- 🌐 **Responsive Frontend**: Modern HTML/CSS design with multiple themes
- 🔧 **RESTful API**: Flask backend with guestbook functionality
- ☁️ **AWS Cloud Infrastructure**: Automated deployment with CloudFormation
- 🔒 **Enterprise Security**: XSS protection, rate limiting, CORS configuration
- 🚀 **Automated CI/CD**: GitHub Actions for seamless deployment
- 📊 **Monitoring & Logging**: CloudWatch integration
- 🐳 **Containerized**: Docker support for consistent deployments

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   CloudFront    │    │   S3 Bucket     │    │   EC2 Instance  │
│   (CDN)         │◄───┤   (Frontend)    │    │   (API)         │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │ CloudFormation │
                    │   (IaC)        │
                    └─────────────────┘
```

## 🛠️ Tech Stack

### Frontend
- HTML5, CSS3
- Responsive design
- Multiple page themes

### Backend
- Python 3.11
- Flask framework
- Gunicorn WSGI server
- Rate limiting & CORS protection

### Cloud Services
- **AWS S3**: Static website hosting
- **AWS CloudFront**: CDN and caching
- **AWS EC2**: API server
- **AWS CloudFormation**: Infrastructure as Code
- **AWS CloudWatch**: Monitoring and logging

### DevOps
- **GitHub Actions**: CI/CD automation
- **Docker**: Containerization
- **AWS CLI**: Deployment scripts

## 🚀 Quick Start

### Prerequisites
- AWS account
- GitHub account
- AWS CLI installed
- Git installed

### 1. Clone the Repository
```bash
git clone https://github.com/YOUR_USERNAME/aws-portfolio-project.git
cd aws-portfolio-project
```

### 2. Configure AWS Credentials
```bash
aws configure
```

### 3. Set Up GitHub Secrets
Refer to [GitHub Secrets Guide](docs/GITHUB_SECRETS_GUIDE.md)

### 4. Deploy to AWS
```bash
# Using automated script
./scripts/deploy.sh --bucket your-unique-bucket-name

# Or using GitHub Actions (automatic deployment)
git push origin main
```

## 📁 Project Structure

```
aws-portfolio-project/
├── .github/workflows/          # GitHub Actions CI/CD
├── api/                        # Flask API application
│   ├── app.py                  # Main application
│   ├── Dockerfile              # Container configuration
│   ├── requirements.txt        # Python dependencies
│   ├── test_app.py             # API tests
│   └── env.production.example  # Environment configuration
├── frontend/                   # Static website files
│   ├── index.html              # Main page
│   ├── index-chinese.html      # Chinese version
│   ├── simple.html             # Simple theme
│   ├── tech-style.html         # Tech theme
│   ├── styles.css              # Stylesheet
│   └── assets/                 # Static assets
├── iac/cfn/                    # Infrastructure as Code
│   └── template.yaml           # CloudFormation template
├── scripts/                    # Deployment scripts
│   └── deploy.sh               # Main deployment script
├── docs/                       # Documentation
│   ├── ARCHITECTURE.md         # Architecture overview
│   ├── DEPLOYMENT_CHECKLIST.md # Deployment guide
│   ├── GITHUB_SECRETS_GUIDE.md # Secrets configuration
│   ├── SECURITY.md             # Security guidelines
│   └── SECURITY_CHECKLIST.md   # Security checklist
└── README.md                   # This file
```

## 🔒 Security Features

- ✅ **Input Validation**: XSS attack prevention
- ✅ **Rate Limiting**: DDoS attack protection
- ✅ **CORS Configuration**: Cross-origin request control
- ✅ **IAM Roles**: Least privilege principle
- ✅ **Security Groups**: Network access control
- ✅ **HTTPS Encryption**: SSL/TLS secure connections
- ✅ **Container Security**: Non-root user execution

## 🧪 Testing

### Local Testing
```bash
cd api
pip install -r requirements.txt
python test_app.py
```

### Docker Testing
```bash
cd api
docker build -t portfolio-api .
docker run -p 5000:80 portfolio-api
```

## 📊 Monitoring

- **CloudWatch Logs**: Application log collection
- **CloudWatch Metrics**: Performance monitoring
- **Health Checks**: Automatic service status checks
- **Log Rotation**: Automatic log management

## 🔧 Configuration

### Environment Variables
- `FLASK_ENV`: Execution environment (development/production)
- `FLASK_DEBUG`: Debug mode
- `ALLOWED_ORIGINS`: CORS allowed origins
- `RATE_LIMIT_PER_MINUTE`: Requests per minute limit
- `RATE_LIMIT_PER_HOUR`: Requests per hour limit

### CloudFormation Parameters
- `BucketName`: S3 bucket name
- `DomainName`: Custom domain (optional)
- `CertificateArn`: SSL certificate ARN (optional)
- `InstanceType`: EC2 instance type

## 📚 Documentation

- [Architecture Overview](docs/ARCHITECTURE.md)
- [Deployment Checklist](docs/DEPLOYMENT_CHECKLIST.md)
- [Security Guidelines](docs/SECURITY.md)
- [GitHub Secrets Guide](docs/GITHUB_SECRETS_GUIDE.md)
- [Security Checklist](docs/SECURITY_CHECKLIST.md)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

### Development Workflow
1. Fork the project
2. Create a feature branch
3. Commit your changes
4. Create a pull request

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details

## 🆘 Support

If you encounter any issues:

1. Check the [Deployment Checklist](docs/DEPLOYMENT_CHECKLIST.md)
2. Review the [Security Checklist](docs/SECURITY_CHECKLIST.md)
3. Submit an [Issue](https://github.com/YOUR_USERNAME/aws-portfolio-project/issues)

## 🎯 Roadmap

- [ ] Multi-language support
- [ ] Database integration
- [ ] User authentication
- [ ] Admin dashboard
- [ ] Performance optimization
- [ ] Additional cloud service integrations

---

**⭐ If this project helps you, please give it a star!**