# 🚀 EKS Project - AWS Infrastructure with Terraform

> Complete and optimized Kubernetes cluster on AWS with **up to 94% savings** using on-demand strategy.

[![Terraform](https://img.shields.io/badge/Terraform-1.0+-623CE4?logo=terraform)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-EKS-FF9900?logo=amazon-aws)](https://aws.amazon.com/eks/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.30-326CE5?logo=kubernetes)](https://kubernetes.io/)

## ⚠️ IMPORTANT: Initial Setup

**Before using this project, you MUST:**

1. ✅ **Create your S3 bucket** to store Terraform state
2. ✅ **Edit `main.tf`** and replace `YOUR-TERRAFORM-BUCKET` with your bucket name
3. ✅ **Never commit** `.tfvars` files with real credentials (already protected by `.gitignore`)

```bash
# 1. Create S3 bucket
aws s3 mb s3://your-unique-terraform-bucket --region us-east-1

# 2. Edit main.tf (line 12)
# backend "s3" {
#   bucket = "your-unique-terraform-bucket"  # ← Change here
# }
```

## 📋 What this project does

Provisions a complete and production-ready **Amazon EKS** (managed Kubernetes) infrastructure using **Terraform**, including:

- ✅ VPC with public and private subnets in 2 AZs
- ✅ EKS Cluster (Kubernetes 1.30)
- ✅ Node Group with Spot Instances (70% cheaper)
- ✅ NAT Gateway, Internet Gateway, and Route Tables
- ✅ Configured IAM Roles and Security Groups
- ✅ Tags for automatic resource discovery

## 💰 Estimated Cost

### On-demand usage (Recommended for studies)
```
20h/week: ~$15.37/month (94% savings vs 24/7)
10h/week: ~$8.08/month  (94% savings vs 24/7)
```

### Continuous usage 24/7
```
Spot Instances:    $126.70/month
On-Demand:         $138.23/month
```

💡 **Strategy**: Create when needed (`terraform apply`), destroy when done (`terraform destroy`)

📊 [See detailed cost analysis](COSTS.md)

## 🏗️ Architecture

```
┌─────────────────────────────────────────┐
│         AWS Region (us-east-1)          │
│                                         │
│  ┌───────────────────────────────────┐ │
│  │    VPC (10.0.0.0/16)              │ │
│  │                                   │ │
│  │  Public Subnets (2 AZs)           │ │
│  │  ├─ Internet Gateway              │ │
│  │  └─ NAT Gateway                   │ │
│  │                                   │ │
│  │  Private Subnets (2 AZs)          │ │
│  │  └─ EKS Worker Nodes (t3.micro)   │ │
│  │                                   │ │
│  │  EKS Control Plane (Managed)      │ │
│  └───────────────────────────────────┘ │
└─────────────────────────────────────────┘
```

**Provisioned resources:** 25 AWS resources

## 🚀 Quick Start

### Prerequisites

```bash
# Install tools
terraform --version  # >= 1.0
aws configure        # Configure credentials
kubectl version      # Kubernetes client
```

### 1. Clone and Configure

```bash
# Create S3 bucket for Terraform state
aws s3 mb s3://your-terraform-bucket --region us-east-1

# Edit main.tf and change the bucket
# backend "s3" {
#   bucket = "your-terraform-bucket"  # ← Change here
# }

# Create configuration file
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your preferences
```

### 2. Provision Infrastructure

```bash
# Initialize Terraform
terraform init

# View what will be created
terraform plan

# Create infrastructure (~20-25 minutes)
terraform apply
```

### 3. Configure kubectl

```bash
# Configure cluster access
aws eks update-kubeconfig --region us-east-1 --name YOUR-PROJECT-eks

# Verify nodes
kubectl get nodes
```

### 4. Test the Cluster

```bash
# Test deployment
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=LoadBalancer

# View services
kubectl get svc

# Access application
curl http://<EXTERNAL-IP>
```

### 5. Destroy Infrastructure (IMPORTANT!)

```bash
# Clean Kubernetes resources
kubectl delete deployment nginx
kubectl delete svc nginx

# Destroy infrastructure (~10-15 minutes)
terraform destroy
```

## 📁 Project Structure

```
eks-project/
├── main.tf                    # Main configuration
├── variables.tf               # Input variables
├── outputs.tf                 # Outputs (endpoints, commands)
├── terraform.tfvars.example   # Configuration template
├── modules/
│   ├── network/               # VPC, Subnets, IGW, NAT, RT
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── eks/                   # EKS Cluster + Node Group
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── README.md                  # This file
├── COSTS.md                   # Detailed cost analysis
├── CHANGELOG.md               # Change history
└── HOWTO.md                   # Complete step-by-step guide
```

## ⚙️ Main Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `project_name` | Project name | `my-project` |
| `aws_region` | AWS Region | `us-east-1` |
| `vpc_cidr` | VPC CIDR | `10.0.0.0/16` |
| `availability_zones` | AZs to use | `["us-east-1a", "us-east-1b"]` |
| `enable_nat_gateway` | Enable NAT | `true` |
| `eks_cluster_version` | Kubernetes version | `1.30` |
| `eks_node_capacity_type` | SPOT or ON_DEMAND | `SPOT` |
| `eks_node_instance_types` | Instance type | `["t3.micro"]` |
| `eks_node_desired_size` | Number of nodes | `2` |

## 📤 Available Outputs

After deployment, you'll have access to:

```bash
terraform output cluster_name              # Cluster name
terraform output cluster_endpoint          # API URL
terraform output configure_kubectl         # kubectl configuration command
terraform output vpc_id                    # VPC ID
terraform output private_subnet_ids        # Private subnet IDs
```

## 💡 Recommended Configurations

### For Development/Studies

```hcl
# terraform.tfvars
enable_nat_gateway = false              # Saves $32/month
eks_node_capacity_type = "SPOT"         # Saves 70%
eks_node_instance_types = ["t3.micro"]
eks_node_desired_size = 2
```

**Cost**: ~$8/month (using 10h/week)

### For Production

```hcl
# terraform.tfvars
enable_nat_gateway = true
eks_node_capacity_type = "ON_DEMAND"    # Stability
eks_node_instance_types = ["t3.small"]
eks_node_min_size = 3
eks_node_max_size = 10
eks_node_desired_size = 3
```

**Cost**: ~$176/month (24/7)

## 🎯 Use Cases

### ✅ Ideal for:
- 📚 Learning Kubernetes and EKS
- 🧪 Testing and experimentation environment
- 👨‍💻 Cloud-native application development
- 🎓 Certification preparation (CKA, CKAD, AWS)
- 💼 Proof of Concepts (POCs)

### ⚠️ Consider other options for:
- 🏭 24/7 production with high availability
- 💰 Very limited budget (<$50/month)
- 🔒 Environments with strict compliance

## 📚 Additional Documentation

- **[HOWTO.md](HOWTO.md)** - Detailed step-by-step guide
- **[COSTS.md](COSTS.md)** - Complete cost analysis by scenario
- **[CHANGELOG.md](CHANGELOG.md)** - Optimization history

## 🔧 Useful Commands

```bash
# Validate configuration
terraform validate

# Format code
terraform fmt -recursive

# View current state
terraform show

# Update only network
terraform apply -target=module.network

# View cost logs
aws ce get-cost-and-usage \
  --time-period Start=2026-01-01,End=2026-01-31 \
  --granularity MONTHLY \
  --metrics BlendedCost
```

## 🐛 Troubleshooting

### Error: "Error creating EKS Cluster"
- Check your AWS account IAM permissions
- Confirm service limits (Service Quotas)

### kubectl won't connect
```bash
# Reconfigure
aws eks update-kubeconfig --region us-east-1 --name YOUR-CLUSTER

# Check credentials
aws sts get-caller-identity
```

### Cost higher than expected
- Check for undestroyed resources: `aws resourcegroupstaggingapi get-resources`
- Confirm Load Balancers were deleted
- Review NAT Gateway (highest variable cost)

## 🔒 Security

✅ **Implemented:**
- Nodes in private subnets
- Restrictive security groups
- IAM roles with least privilege principle
- Terraform state in S3 with versioning

⚠️ **Additional recommendations for production:**
- Enable EKS secrets encryption
- Implement Pod Security Standards
- Configure Network Policies
- Enable control plane audit logs
- Use AWS Secrets Manager for credentials

## 🤝 Contributing

Improvements are welcome! To contribute:

1. Fork the project
2. Create a branch (`git checkout -b feature/improvement`)
3. Commit your changes (`git commit -m 'feat: add xyz'`)
4. Push to the branch (`git push origin feature/improvement`)
5. Open a Pull Request

## 📄 License

MIT License - see LICENSE file for details

## 🎓 Additional Resources

- [Official EKS Documentation](https://docs.aws.amazon.com/eks/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [EKS Best Practices](https://aws.github.io/aws-eks-best-practices/)
- [Spot Instances Best Practices](https://aws.amazon.com/ec2/spot/getting-started/)

## ⭐ Support the Project

If this project helped you:
- ⭐ Star it on GitHub
- 🔄 Share with other developers
- 💬 Leave feedback or suggestions
- 📝 Write about your experience

---

**Created with ❤️ for the developer community**

*Questions? Open an issue on GitHub!*
