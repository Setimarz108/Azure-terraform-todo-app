markdown# Enterprise Azure Todo Application

[![Azure](https://img.shields.io/badge/Azure-Cloud-0078D4?logo=microsoft-azure)](https://azure.microsoft.com)
[![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?logo=terraform)](https://www.terraform.io/)
[![React](https://img.shields.io/badge/React-18-61DAFB?logo=react)](https://reactjs.org/)
[![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF?logo=github-actions)](https://github.com/features/actions)

A production-ready React Todo application deployed on Azure with enterprise-grade infrastructure, automated CI/CD, and comprehensive monitoring - all optimized to run at €0/month.

🔗 **Live Demo**: [https://todoapp-demo-spnypd75.azurewebsites.net](https://todoapp-demo-spnypd75.azurewebsites.net)

## 🏗️ Architecture Overview

This project demonstrates professional cloud engineering practices with:
- **8 integrated Azure services** working seamlessly together
- **Infrastructure as Code** with Terraform (180+ lines)
- **Enterprise security** with Azure Key Vault and RBAC
- **Automated CI/CD** pipeline with quality gates
- **Complete observability** with Application Insights
- **Cost optimization** achieving €0/month hosting

## ✨ Features

### Application
- ✅ Responsive React frontend with modern UI
- ✅ Full CRUD operations for todo items
- ✅ HTTPS enforcement
- ✅ Professional error handling

### Infrastructure
- ✅ Azure App Service (Windows, F1 Free tier)
- ✅ Azure Key Vault for secrets management
- ✅ Managed Identity for passwordless authentication
- ✅ Application Insights for monitoring
- ✅ Log Analytics Workspace for data retention
- ✅ Budget alerts and cost management
- ✅ Resource tagging for governance

### DevOps
- ✅ GitHub Actions CI/CD pipeline
- ✅ Terraform validation and formatting checks
- ✅ Automated security scanning
- ✅ Multi-environment support (dev/staging/prod)

## 🚀 Quick Start

### Prerequisites
- Azure subscription
- Terraform >= 1.5.0
- Node.js >= 18
- Azure CLI

### Local Development

1. Clone the repository:
```bash
git clone https://github.com/Setimarz108/Todo-App.git
cd Todo-App

Install React dependencies:

bashcd react-todo
npm install
npm start

The app will be available at http://localhost:3000

Infrastructure Deployment

Login to Azure:

bashaz login

Initialize Terraform:

bashterraform init

Review the deployment plan:

bashterraform plan

Deploy the infrastructure:

bashterraform apply

Get the application URL:

bashterraform output application_url
📁 Project Structure
.
├── .github/
│   └── workflows/
│       └── azure-deploy.yml      # CI/CD pipeline
├── react-todo/                   # React application
│   ├── public/
│   ├── src/
│   └── package.json
├── main.tf                       # Main Terraform configuration
├── variables.tf                  # Input variables
├── outputs.tf                    # Output definitions
├── terraform.tfvars             # Variable values
└── README.md
🔧 Configuration
Terraform Variables
VariableDescriptionDefaultproject_nameProject identifierTodoAppenvironmentDeployment environmentdemolocationAzure regionWest Europe
Resource Naming Convention
All resources follow the pattern: {type}-{project}-{environment}-{uniqueid}
Example: app-TodoApp-demo-spnypd75
📊 Monitoring & Alerts
The application includes comprehensive monitoring:

Performance Monitoring: Response times, request rates, failures
Custom Alerts:

Response time > 5 seconds
Availability < 99%
Budget threshold reached (80% and 100%)


Live Metrics: Real-time application performance
Application Map: Dependency tracking and failure analysis

💰 Cost Optimization
Achieved €0/month through:

F1 Free App Service tier
Minimal Key Vault transactions
Application Insights sampling
Smart use of free tiers

Budget alerts ensure no unexpected charges:

Warning at 80% of €5 budget
Critical alert at 100%
Email notifications configured

🔐 Security

Zero secrets in code: All sensitive data in Key Vault
Managed Identity: Passwordless authentication
RBAC: Least privilege access control
HTTPS only: Automatic redirect enforcement
Security headers: Configured at App Service level

🛠️ CI/CD Pipeline
The GitHub Actions workflow includes:

Infrastructure Validation

Terraform format check
Terraform validate
Configuration analysis


Application Build

Dependency installation
React production build
Security vulnerability scanning


Quality Gates

All checks must pass
Automated rollback on failure



🏷️ Resource Tagging Strategy
All resources are tagged for governance:
hclProject     = "TodoApp"
Environment = "demo"
ManagedBy   = "Terraform"
Owner       = "Sebastian"
CostCenter  = "Development"
📈 Future Enhancements

 Backend API with Azure Functions
 Azure SQL Database integration
 Azure Redis Cache for performance
 Container deployment with AKS
 Multi-region deployment
 Azure Front Door for global distribution

🧪 Testing
bash# Run React tests
cd react-todo
npm test

# Validate Terraform
terraform validate

# Check formatting
terraform fmt -check
🚨 Troubleshooting
Common Issues

Deployment fails with subscription error

Ensure you're logged into Azure CLI: az login
Check subscription: az account show


Terraform state issues

Run terraform init -reconfigure


Application not accessible

Check App Service is running in Azure Portal
Verify deployment completed in GitHub Actions



🤝 Contributing

Fork the repository
Create your feature branch (git checkout -b feature/AmazingFeature)
Commit your changes (git commit -m 'Add some AmazingFeature')
Push to the branch (git push origin feature/AmazingFeature)
Open a Pull Request

📝 License
This project is licensed under the MIT License.
👨‍💻 Author
Sebastian Marquez

GitHub: @Setimarz108
Project: Built for Skaylink Cloud Engineer position

🙏 Acknowledgments

Azure documentation for best practices
Terraform Azure Provider examples
React community for the excellent create-react-app


Built with ❤️ using Azure, Terraform, and React