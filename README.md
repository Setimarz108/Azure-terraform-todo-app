[![Azure](https://img.shields.io/badge/Azure-Cloud-0078D4?logo=microsoft-azure)](https://azure.microsoft.com)
[![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?logo=terraform)](https://www.terraform.io/)
[![React](https://img.shields.io/badge/React-18-61DAFB?logo=react)](https://reactjs.org/)
[![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF?logo=github-actions)](https://github.com/features/actions)

# 📝 Azure Production-Ready Todo App

A **React Todo application** deployed on **Azure** with **enterprise-grade infrastructure**, **automated CI/CD**, and **comprehensive monitoring** — optimized to run at **€0/month**.

🔗 **Live Demo**: [https://todoapp-demo-spnypd75.azurewebsites.net](https://todoapp-demo-spnypd75.azurewebsites.net)

---

## 🏗 Architecture Highlights
- **8 integrated Azure services** working seamlessly together
- **Infrastructure as Code** with Terraform (180+ lines)
- **Enterprise security** with Azure Key Vault + RBAC
- **Automated CI/CD** pipeline with quality gates
- **Complete observability** via Application Insights
- **Cost optimization** achieving €0/month hosting

---

## ✨ Key Features

### Application
✅ Responsive React frontend  
✅ Full CRUD operations  
✅ HTTPS enforcement  
✅ Professional error handling  

### Infrastructure
✅ Azure App Service (F1 Free tier)  
✅ Azure Key Vault for secrets  
✅ Managed Identity (passwordless auth)  
✅ Application Insights + Log Analytics  
✅ Budget alerts & cost management  
✅ Resource tagging for governance  

### DevOps
✅ GitHub Actions CI/CD  
✅ Terraform validation & format checks  
✅ Automated security scans  
✅ Multi-environment support (dev/staging/prod)  

---

<details>
<summary>🚀 Quick Start (click to expand)</summary>

### **Prerequisites**
- Azure subscription
- Terraform >= 1.5.0
- Node.js >= 18
- Azure CLI

### **Local Development**
```bash
# Clone repo
git clone https://github.com/Setimarz108/Todo-App.git
cd Todo-App

# Install React dependencies
cd react-todo
npm install
npm start
```
App runs at: **http://localhost:3000**

### **Deploy Infrastructure**
```bash
az login
terraform init
terraform plan
terraform apply
terraform output application_url
```
</details>

---

<details>
<summary>📁 Project Structure</summary>

```
.
├── .github/workflows/azure-deploy.yml   # CI/CD pipeline
├── react-todo/                          # React frontend
├── main.tf                               # Terraform config
├── variables.tf                          # Variables
├── outputs.tf                            # Outputs
├── terraform.tfvars                      # Values
└── README.md
```
</details>

---

<details>
<summary>📊 Monitoring & Alerts</summary>

- **Performance Monitoring:** Response times, request rates, failures  
- **Custom Alerts:** Response > 5s, Availability < 99%, Budget > 80%/100%  
- **Live Metrics:** Real-time monitoring  
- **Application Map:** Dependency tracking
</details>

---

<details>
<summary>💰 Cost Optimization</summary>

- F1 Free App Service tier  
- Minimal Key Vault transactions  
- Application Insights sampling  
- Free tier resource usage  
- Budget alerts (80% and 100% thresholds) with email notifications
</details>

---

<details>
<summary>🔐 Security</summary>

- Zero secrets in code (Key Vault)  
- Managed Identity (passwordless)  
- RBAC (least privilege)  
- HTTPS-only enforcement  
- Security headers at App Service level
</details>

---

<details>
<summary>🛠 CI/CD Pipeline</summary>

- **Infrastructure validation:** Terraform fmt, validate, config checks  
- **App build:** React production build + dependency install  
- **Security:** Vulnerability scanning  
- **Quality gates:** All checks must pass before deploy; rollback on failure
</details>

---

<details>
<summary>🏷 Resource Tagging</summary>

```hcl
Project     = "TodoApp"
Environment = "demo"
ManagedBy   = "Terraform"
Owner       = "Sebastian"
CostCenter  = "Development"
```
</details>

---

<details>
<summary>📈 Future Enhancements</summary>

- Backend API with Azure Functions  
- Azure SQL Database integration  
- Azure Redis Cache  
- Container deployment with AKS  
- Multi-region deployment  
- Azure Front Door for global distribution
</details>

---

<details>
<summary>🧪 Testing</summary>

```bash
# React tests
cd react-todo
npm test

# Validate Terraform
terraform validate

# Formatting check
terraform fmt -check
```
</details>

---

<details>
<summary>🚨 Troubleshooting</summary>

**Deployment fails with subscription error**  
- `az login` and check subscription with `az account show`

**Terraform state issues**  
- `terraform init -reconfigure`

**App not accessible**  
- Check App Service in Azure Portal  
- Verify GitHub Actions deploy status
</details>

---

## 👨‍💻 Author
**Sebastian Marquez**  
GitHub: [@Setimarz108](https://github.com/Setimarz108)  
Built for **Skaylink Cloud Engineer** position  

---

**License:** MIT  
Built with ❤️ using **Azure**, **Terraform**, and **React**
