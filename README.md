# 🚀 Portfolio Website

> 🌐 **Live Site**: [https://luichu.dev/](https://luichu.dev/)  
> 📖 **中文版**: [README.zh-TW.md](README.zh-TW.md)

Personal portfolio website hosted on GitHub Pages with automated deployment.

## ✨ Features

- 🌐 **Responsive Design**: Adapts to all screen sizes
- 🚀 **Auto Deployment**: Push to deploy via GitHub Actions
- 🆓 **Free Hosting**: Zero cost with GitHub Pages
- 🔒 **Auto HTTPS**: Built-in SSL/TLS encryption
- 🎨 **Multiple Themes**: Different page styles available

## 🏗️ Architecture

\`\`\`
┌──────────────────┐
│   GitHub Pages   │
│                  │
│  • Static Site   │
│  • Free HTTPS    │
│  • Auto Deploy   │
└──────────────────┘
         ▲
         │ Push to master
         │
┌────────┴─────────┐
│ GitHub Actions   │
│                  │
│ • Auto Build     │
│ • Auto Deploy    │
└──────────────────┘
\`\`\`

## 🛠️ Tech Stack

### Frontend
- HTML5, CSS3, JavaScript
- Responsive design
- Multiple page themes

### Deployment
- **GitHub Pages**: Free static site hosting
- **GitHub Actions**: Automated CI/CD pipeline
- **HTTPS**: Automatic SSL/TLS encryption

## 🚀 Quick Start

### Prerequisites

- GitHub account
- Git installed

### 1. Fork/Clone the Repository

\`\`\`bash
git clone https://github.com/YOUR_USERNAME/aws-portfolio-project.git
cd aws-portfolio-project
\`\`\`

### 2. Enable GitHub Pages

1. Go to **Settings** → **Pages**
2. Under **Source**, select **GitHub Actions**
3. Save settings

### 3. Customize Content

Edit files in the \`frontend/\` directory:
- [frontend/index.html](frontend/index.html) - Main page content
- [frontend/styles.css](frontend/styles.css) - Styling
- [frontend/assets/](frontend/assets/) - Images and media

### 4. Deploy (Automatic)

Simply push to the master branch:

\`\`\`bash
git add .
git commit -m "Update portfolio"
git push origin master
\`\`\`

GitHub Actions will automatically deploy to:
\`\`\`
https://YOUR_USERNAME.github.io/aws-portfolio-project/
\`\`\`

### 5. Custom Domain (Optional)

1. Create \`frontend/CNAME\` file with your domain:
   \`\`\`
   www.yoursite.com
   \`\`\`

2. Configure DNS CNAME record with your provider:
   \`\`\`
   CNAME  www  YOUR_USERNAME.github.io
   \`\`\`

## 📁 Project Structure

\`\`\`
aws-portfolio-project/
├── .github/workflows/
│   └── deploy-pages.yml        # GitHub Actions auto-deployment
├── frontend/                   # Static website files
│   ├── index.html              # Main page
│   ├── index-zh.html           # Chinese version
│   ├── simple.html             # Simple theme
│   ├── tech-style.html         # Tech theme
│   ├── styles.css              # Stylesheet
│   └── assets/                 # Static assets (images, etc.)
├── docs/
│   └── GITHUB_PAGES_MIGRATION.md  # Migration guide
├── README.md                   # This file (English)
└── README.zh-TW.md             # Chinese version
\`\`\`

## 🔧 Local Preview

Preview the website using any local server:

\`\`\`bash
# Using Python
cd frontend
python3 -m http.server 8000

# Or using PHP
php -S localhost:8000

# Or using VS Code Live Server extension
\`\`\`

Then open \`http://localhost:8000\` in your browser.

## 📚 Documentation

- [GitHub Pages Migration Guide](docs/GITHUB_PAGES_MIGRATION.md)

## 🤝 Contributing

Contributions are welcome! Feel free to submit Issues or Pull Requests.

### Development Workflow
1. Fork the project
2. Create a feature branch
3. Commit your changes
4. Create a Pull Request

## 📄 License

MIT License

## 🆘 Support

If you encounter any issues:

1. Check the [Migration Guide](docs/GITHUB_PAGES_MIGRATION.md)
2. Submit an [Issue](https://github.com/YOUR_USERNAME/aws-portfolio-project/issues)

---

**⭐ If this project helps you, please give it a star!**
