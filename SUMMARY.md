# 📦 EKS Project Summary

> Updated and concise documentation - January 2026

## 🎯 Overview

Complete Terraform project to provision **Amazon EKS** cluster (Kubernetes 1.30) on AWS with focus on **cost savings** and **best practices**.

### ✨ Highlights

- 💰 **Up to 94% savings** using on-demand strategy
- ☸️ **Kubernetes 1.30** updated
- 🎯 **Spot Instances** by default (70% cheaper)
- 📦 **2 consolidated modules** (network + eks)
- 📚 **Complete and practical documentation**

## 📁 File Structure

```
eks-project/
├── 📘 README.md                  # Quick start and overview
├── 📗 HOWTO.md                   # Complete step-by-step guide
├── 💰 COSTS.md                   # Detailed cost analysis
├── 📝 CHANGELOG.md               # Change history
├── 🔧 main.tf                    # Main configuration (66 lines)
├── 🔧 variables.tf               # Variables (87 lines)
├── 🔧 outputs.tf                 # Useful outputs
├── 📄 terraform.tfvars.example   # Configuration template
├── 🚫 .gitignore                 # Sensitive file protection
└── 📦 modules/
    ├── network/                  # VPC, Subnets, IGW, NAT, RT
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── eks/                      # Cluster + Node Group
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## 📚 Navigation Guide

### 🚀 For Quick Start
👉 **[README.md](README.md)** - Quick start, architecture, basic commands

### 📖 For Complete Guide
👉 **[HOWTO.md](HOWTO.md)** - Step-by-step tutorial with troubleshooting

### 💵 To Understand Costs
👉 **[COSTS.md](COSTS.md)** - Scenario analysis, savings tips

### 🔄 To See Changes
👉 **[CHANGELOG.md](CHANGELOG.md)** - Optimization history

## 💰 Estimated Costs

### By Usage Pattern

| Usage | Hours/month | Cost/month | Savings |
|-----|-----------|-----------|----------|
| **10h/week** | 43h | $8.08 | 94% 🏆 |
| **20h/week** | 87h | $15.37 | 88% ⭐ |
| **24/7 Spot** | 730h | $126.70 | 8% |
| **24/7 On-Demand** | 730h | $138.23 | 0% |

### Cost Breakdown (24/7 Spot)

| Component | Cost/month | % |
|------------|-----------|---|
| EKS Control Plane | $73.00 | 58% |
| NAT Gateway + Data | $37.35 | 29% |
| 2x t3.micro Spot | $3.65 | 3% |
| EBS + Transfer | $12.70 | 10% |
| **Total** | **$126.70** | 100% |

## 🏗️ Provisioned Resources

**Total: 25 AWS resources**

### Network (13 resources)
- 1 VPC
- 1 Internet Gateway
- 1 NAT Gateway + Elastic IP
- 4 Subnets (2 public + 2 private)
- 2 Route Tables + 5 associations/routes

### EKS (12 resources)
- 1 EKS Cluster
- 1 Node Group (2 t3.micro Spot nodes)
- 2 Security Groups + 1 rule
- 2 IAM Roles + 4 Policy Attachments

## ⚡ Quick Commands

```bash
# Initial setup
terraform init
terraform plan

# Create infrastructure (~20-25 min)
terraform apply

# Configure kubectl
$(terraform output -raw configure_kubectl)

# Verify
kubectl get nodes

# Destroy (~10-15 min)
terraform destroy
```

## 🎯 Use Cases

### ✅ Ideal for:
- 📚 Kubernetes/EKS learning
- 🧪 Testing environment
- 👨‍💻 Development
- 🎓 Certifications (CKA, CKAD, AWS)
- 💼 POCs and demos

### ⚠️ Consider alternatives for:
- 🏭 Critical production 24/7
- 💰 Budget < $50/month
- 🔒 Strict compliance

## 📊 Project Metrics

| Metric | Value |
|---------|-------|
| **Lines of code** | ~600 lines |
| **Modules** | 2 (network + eks) |
| **AWS Resources** | 25 resources |
| **Deploy time** | ~20-25 minutes |
| **Destroy time** | ~10-15 minutes |
| **Minimum cost** | $8.08/month (10h/week) |
| **Maximum savings** | 94% vs 24/7 |

## 🔧 Default Configuration

```hcl
# Profile: Studies with Spot Instances
project_name = "rgtrovao-eks"
aws_region = "us-east-1"
vpc_cidr = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]

# Network
enable_nat_gateway = true  # $32/month

# EKS
eks_cluster_version = "1.30"
eks_node_capacity_type = "SPOT"  # 70% savings
eks_node_instance_types = ["t3.micro"]
eks_node_desired_size = 2
```

## ✨ Changes vs Version 1.0

| Aspect | Before | After | Improvement |
|---------|-------|--------|----------|
| **Modules** | 5 | 2 | -60% complexity |
| **NAT Gateways** | 3 | 1 | -$64/month |
| **Compute** | On-Demand | Spot | -70% |
| **Kubernetes** | 1.28 | 1.30 | Updated |
| **Database Subnets** | Yes | No | Simplified |
| **Documentation** | Basic | Complete | +400% |
| **Cost 24/7** | $181 | $127 | -30% |

## 🎓 Learning Resources

### Documentation
- [AWS EKS Docs](https://docs.aws.amazon.com/eks/)
- [Kubernetes Docs](https://kubernetes.io/docs/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/)

### Guides and Workshops
- [EKS Workshop](https://www.eksworkshop.com/)
- [EKS Best Practices](https://aws.github.io/aws-eks-best-practices/)
- [Terraform Learn](https://learn.hashicorp.com/terraform)

## 🤝 Contributing

This project is community-maintained:

1. 🍴 Fork the project
2. 🌿 Create a branch (`feature/improvement`)
3. 💬 Commit your changes
4. 📤 Push and open a PR
5. ⭐ Leave a star!

## 📞 Support

- 🐛 **Issues**: Problems and bugs
- 💡 **Discussions**: Questions and ideas
- 📧 **Email**: Direct contact

## 📄 License

MIT License - Use freely!

---

## 🎉 Quick Links

| 📖 Documentation | 🔗 Link |
|----------------|---------|
| Quick Start | [README.md](README.md) |
| Complete Guide | [HOWTO.md](HOWTO.md) |
| Cost Analysis | [COSTS.md](COSTS.md) |
| History | [CHANGELOG.md](CHANGELOG.md) |
| Config Example | [terraform.tfvars.example](terraform.tfvars.example) |

---

**Created with ❤️ for the developer community**

*Last updated: January 2026*
