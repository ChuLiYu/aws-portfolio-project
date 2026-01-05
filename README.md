# Portfolio Website

> **Live Site**: [https://luichu.dev/](https://luichu.dev/)

Modern personal portfolio website showcasing projects and skills, hosted on GitHub Pages with automated deployment.

## Features

- **Responsive Design**: Optimized for all devices
- **Automated Deployment**: GitHub Actions CI/CD pipeline
- **Free Hosting**: Zero-cost infrastructure using GitHub Pages
- **Auto HTTPS**: Built-in SSL/TLS encryption
- **Multiple Themes**: Different page styles and layouts
- **DNS Management**: Terraform-managed Cloudflare DNS

## Architecture

\`\`\`
┌─────────────────────────────────────────────┐
│           luichu.dev (Cloudflare)           │
│                 DNS Records                  │
└─────────────────┬───────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────┐
│            GitHub Pages                      │
│                                              │
│  • Static Site Hosting (Free)               │
│  • Automatic HTTPS                           │
│  • CDN Distribution                          │
└─────────────────▲───────────────────────────┘
                  │
                  │ git push
                  │
┌─────────────────┴───────────────────────────┐
│          GitHub Actions                      │
│                                              │
│  • Automated Build                           │
│  • Deploy on Push                            │
│  • Enable Pages                              │
└─────────────────────────────────────────────┘
\`\`\`

## Tech Stack

### Frontend
- **HTML5, CSS3, JavaScript**: Core web technologies
- **Responsive Design**: Mobile-first approach
- **Multiple Themes**: Customizable layouts

### Infrastructure
- **GitHub Pages**: Static site hosting
- **GitHub Actions**: CI/CD automation
- **Cloudflare**: DNS and CDN
- **Terraform**: Infrastructure as Code for DNS

### DevOps
- Automated deployment pipeline
- Version-controlled infrastructure
- Zero-downtime deployments

## Project Structure

\`\`\`
portfolio/
├── .github/
│   └── workflows/
│       └── deploy-pages.yml    # GitHub Actions workflow
├── frontend/
│   ├── index.html              # Main page
│   ├── index-zh.html           # Chinese version
│   ├── styles.css              # Styles
│   ├── CNAME                   # Custom domain
│   └── assets/                 # Images and resources
├── terraform/
│   └── cloudflare/             # DNS management
│       ├── main.tf             # Cloudflare config
│       ├── terraform.tfvars.example
│       └── README.md
├── .gitignore
└── README.md
\`\`\`

## Quick Start

### Local Development

\`\`\`bash
# Clone the repository
git clone https://github.com/yourusername/aws-portfolio-project.git
cd aws-portfolio-project

# Serve locally (Python)
cd frontend
python3 -m http.server 3000

# Or use any static server
# Open http://localhost:3000
\`\`\`

### Deployment

The site automatically deploys when you push to the \`main\` branch:

\`\`\`bash
# Make changes
vim frontend/index.html

# Commit and push
git add .
git commit -m "Update portfolio content"
git push origin main

# GitHub Actions will automatically:
# 1. Build and deploy to GitHub Pages
# 2. Site live at https://luichu.dev in ~1 minute
\`\`\`

## DNS Configuration

DNS is managed via Terraform for infrastructure as code:

\`\`\`bash
cd terraform/cloudflare

# Setup (first time)
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your Cloudflare API token

# Apply changes
terraform init
terraform plan
terraform apply
\`\`\`

## Cost Analysis

| Service | Monthly Cost | Notes |
|---------|--------------|-------|
| GitHub Pages | **$0** | Free tier |
| Cloudflare DNS | **$0** | Free tier |
| **Total** | **$0/month** | Zero infrastructure cost |

**Previous AWS Cost**: $12-36/year (S3 + CloudFront)  
**Savings**: 100% cost reduction

## Environment Variables

No environment variables required for basic setup. For DNS management:

\`\`\`bash
# terraform/cloudflare/terraform.tfvars
cloudflare_api_token = "your-token"
zone_id = "your-zone-id"
\`\`\`

## CI/CD Pipeline

GitHub Actions workflow (\`.github/workflows/deploy-pages.yml\`):

\`\`\`yaml
1. Triggered on push to main
2. Checkout code
3. Configure GitHub Pages
4. Deploy frontend/ directory
5. Site live at luichu.dev
\`\`\`

## Featured Projects

Portfolio showcases:
- **Chainy**: Serverless event tracking (AWS Lambda, DynamoDB, Terraform)
- **Raft-Recovery**: Distributed consensus implementation (Go)
- **This Portfolio**: Modern web architecture migration

## Development

### Adding New Content

1. **Edit HTML**: Update \`frontend/index.html\`
2. **Update Styles**: Modify \`frontend/styles.css\`
3. **Add Assets**: Place in \`frontend/assets/\`
4. **Test Locally**: Run local server
5. **Deploy**: Push to main branch

### Customization

- **Domain**: Update \`frontend/CNAME\`
- **DNS**: Modify \`terraform/cloudflare/main.tf\`
- **Workflow**: Edit \`.github/workflows/deploy-pages.yml\`

## Troubleshooting

### DNS Not Resolving
\`\`\`bash
# Check DNS records
dig luichu.dev
nslookup luichu.dev

# Verify Cloudflare settings
cd terraform/cloudflare
terraform plan
\`\`\`

### Pages Not Updating
- Check GitHub Actions run status
- Verify Pages is enabled in repo settings
- Clear browser cache (Ctrl+Shift+R)

### Custom Domain Issues
- Ensure CNAME file contains correct domain
- Verify DNS A records point to GitHub Pages IPs:
  - 185.199.108.153
  - 185.199.109.153
  - 185.199.110.153
  - 185.199.111.153

## Contributing

1. Fork the repository
2. Create feature branch (\`git checkout -b feature/amazing\`)
3. Commit changes (\`git commit -m 'Add amazing feature'\`)
4. Push to branch (\`git push origin feature/amazing\`)
5. Open Pull Request

## License

This project is open source and available under the MIT License.

## Contact

- **Website**: [https://luichu.dev](https://luichu.dev)
- **Email**: chuliyuaw@gmail.com
- **Location**: Vancouver, BC, Canada

## Acknowledgments

- GitHub Pages for free hosting
- Cloudflare for DNS management
- Open source community

---

**Built with ❤️ using modern web technologies and DevOps best practices**
