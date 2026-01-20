# 🚀 How to Provision an EKS Cluster on AWS with Terraform

> **Complete Guide for Kubernetes and AWS Students**

---

## ⚠️ COST STRATEGY FOR STUDIES

### 🎯 Use on-demand, destroy when not in use!

This guide was created for those who are **studying** Kubernetes and want **maximum savings**:

✅ **Create cluster**: `terraform apply` (~20 minutes)  
✅ **Study**: As long as you need  
✅ **Destroy**: `terraform destroy` (~15 minutes)  

### 💰 Cost Estimate (20h/week)

```
┌────────────────────────────────────────┐
│ Weekly Usage:   20 hours              │
│ Monthly Usage:  ~86.6 hours           │
│ Monthly Cost:   ~$15.37               │
│ Cost per Hour:  $0.18                 │
│                                        │
│ 🎉 94% cheaper than keeping it 24/7!  │
└────────────────────────────────────────┘
```

**Breakdown:**
- EKS Control Plane: $8.66/month
- 2x EC2 t3.micro Spot: $0.43/month
- NAT Gateway: $3.90/month
- Storage + Transfer: $2.38/month

💡 **Comparison**: Cluster 24/7 = ~$127/month | On-demand (20h/week) = **$15.37/month**

---

## 🎯 What you'll learn

By the end of this guide, you'll have:

✅ Working EKS cluster (Kubernetes 1.30)  
✅ Complete network infrastructure (VPC, Subnets, NAT, IGW)  
✅ Practical Terraform knowledge  
✅ 2 configured worker nodes  
✅ kubectl configured and ready  
✅ Up to 94% savings on costs  

---

## 📋 Prerequisites

### 1. Required Tools

```bash
# Terraform >= 1.0
brew install terraform      # macOS
# or
choco install terraform     # Windows
# or
sudo apt install terraform  # Linux

# AWS CLI
brew install awscli         # macOS
pip install awscli         # Any OS

# kubectl
brew install kubectl        # macOS
choco install kubernetes-cli # Windows
```

### 2. AWS Account

- Create AWS account (Free Tier available)
- Get Access Key and Secret Key
- Configure credentials:

```bash
aws configure
# AWS Access Key ID: AKIAIOSFODNN7EXAMPLE
# AWS Secret Access Key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
# Default region name: us-east-1
# Default output format: json
```

### 3. Verify Permissions

Your AWS account needs permissions for:
- EC2 (create VPC, subnets, security groups)
- EKS (create cluster and node groups)
- IAM (create roles and policies)
- S3 (store Terraform state)

---

## 🏗️ Complete Architecture

```
┌─────────────────────────────────────────────┐
│         AWS Cloud (us-east-1)               │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │     VPC (10.0.0.0/16)               │   │
│  │                                     │   │
│  │  ┌─────────────┐  ┌──────────────┐ │   │
│  │  │Public Subnet│  │Public Subnet │ │   │
│  │  │ us-east-1a  │  │ us-east-1b   │ │   │
│  │  │  10.0.0/24  │  │  10.0.1/24   │ │   │
│  │  │             │  │              │ │   │
│  │  │ [IGW] [NAT] │  │              │ │   │
│  │  └──────┬──────┘  └──────────────┘ │   │
│  │         │                           │   │
│  │  ┌──────▼──────┐  ┌──────────────┐ │   │
│  │  │Private Sub. │  │Private Sub.  │ │   │
│  │  │ us-east-1a  │  │ us-east-1b   │ │   │
│  │  │  10.0.10/24 │  │  10.0.11/24  │ │   │
│  │  │             │  │              │ │   │
│  │  │[EKS Node 1] │  │[EKS Node 2]  │ │   │
│  │  │ t3.micro    │  │ t3.micro     │ │   │
│  │  └─────────────┘  └──────────────┘ │   │
│  │                                     │   │
│  │  EKS Control Plane (AWS Managed)    │   │
│  │  ↑ Kubernetes 1.30                  │   │
│  └─────────────────────────────────────┘   │
└─────────────────────────────────────────────┘
```

**Total AWS resources:** 25 resources

---

## 🚀 Step by Step - Installation

### Step 1: Get the Code

```bash
# Option A: Clone repository (if available)
git clone https://github.com/your-username/eks-project
cd eks-project

# Option B: Direct download or create manually
mkdir eks-project && cd eks-project
```

### Step 2: S3 Backend

Terraform needs a place to store infrastructure state:

```bash
# Create S3 bucket (name must be globally unique)
aws s3 mb s3://your-unique-terraform-state --region us-east-1

# Enable versioning (security backup)
aws s3api put-bucket-versioning \
  --bucket your-unique-terraform-state \
  --versioning-configuration Status=Enabled

# Enable encryption
aws s3api put-bucket-encryption \
  --bucket your-unique-terraform-state \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'
```

### Step 3: Configure Backend

Edit `main.tf` file and change the bucket name:

```hcl
backend "s3" {
  bucket = "your-unique-terraform-state"  # ← CHANGE HERE
  key    = "eks/terraform.tfstate"
  region = "us-east-1"
}
```

### Step 4: Configure Variables

Copy the example file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars`:

```hcl
# Identification
project_name = "my-project"     # ← Change
environment  = "dev"

# Network
aws_region = "us-east-1"
vpc_cidr = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]

# Savings: false for dev (saves $32/month)
enable_nat_gateway = true

# EKS - Spot saves 70%!
eks_cluster_version = "1.30"
eks_node_capacity_type = "SPOT"              # SPOT or ON_DEMAND
eks_node_instance_types = ["t3.micro"]
eks_node_desired_size = 2
eks_node_min_size = 2
eks_node_max_size = 2
eks_node_disk_size = 20

# Optional tags
tags = {
  Owner = "your-name"
  Course = "kubernetes-in-practice"
}
```

### Step 5: Initialize Terraform

```bash
# Initialize (download providers)
terraform init

# Should show: "Terraform has been successfully initialized!"
```

### Step 6: Validate Configuration

```bash
# Validate syntax
terraform validate

# Format code
terraform fmt -recursive
```

### Step 7: View the Plan

```bash
# See what will be created (doesn't create anything yet)
terraform plan

# You'll see: "Plan: 25 to add, 0 to change, 0 to destroy"
```

### Step 8: Create Infrastructure! 🎉

```bash
# Create everything
terraform apply

# Type 'yes' when prompted
# Wait ~20-25 minutes ☕

# Progress:
# ✓ VPC and network (~3 min)
# ✓ EKS Control Plane (~10-12 min)
# ✓ Node Group (~5-7 min)
# ✓ Final configurations (~2 min)
```

---

## ⚙️ Configure kubectl

After creation, configure access:

```bash
# Get configuration command
terraform output configure_kubectl

# Or execute directly:
aws eks update-kubeconfig --region us-east-1 --name my-project-eks

# Verify connection
kubectl get nodes

# Should show 2 nodes:
# NAME                         STATUS   ROLES    AGE   VERSION
# ip-10-0-10-xx.ec2.internal  Ready    <none>   3m    v1.30.x
# ip-10-0-11-xx.ec2.internal  Ready    <none>   3m    v1.30.x
```

---

## 🧪 Test the Cluster

### Simple Application Deployment

```bash
# Deploy NGINX
kubectl create deployment nginx --image=nginx:latest

# Check pod
kubectl get pods

# Expose with Load Balancer
kubectl expose deployment nginx --port=80 --type=LoadBalancer

# View services (wait for EXTERNAL-IP to appear, ~2-3 min)
kubectl get svc nginx --watch

# Test access
curl http://<EXTERNAL-IP>
# Should return: "Welcome to nginx!"
```

### Deploy with Manifest

```bash
# Create deployment.yaml file
cat <<EOF > deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-k8s
spec:
  replicas: 3
  selector:
    matchLabels:
      app: hello
  template:
    metadata:
      labels:
        app: hello
    spec:
      containers:
      - name: hello
        image: gcr.io/google-samples/hello-app:1.0
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: hello-k8s
spec:
  type: LoadBalancer
  selector:
    app: hello
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
EOF

# Apply
kubectl apply -f deployment.yaml

# View status
kubectl get all

# Test
curl http://$(kubectl get svc hello-k8s -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
```

---

## 🗑️ Destroy Infrastructure

**VERY IMPORTANT**: Always destroy when finished!

### Step 1: Clean Kubernetes Resources

```bash
# Delete deployments
kubectl delete deployment nginx hello-k8s

# Delete services (IMPORTANT: removes Load Balancers)
kubectl delete svc nginx hello-k8s

# Verify Load Balancers were removed
kubectl get svc --all-namespaces

# Wait 2-3 minutes for AWS to process
```

### Step 2: Destroy with Terraform

```bash
# Destroy everything
terraform destroy

# Type 'yes' when prompted
# Wait ~10-15 minutes

# Progress:
# ✓ Node Group (~5 min)
# ✓ EKS Cluster (~5 min)
# ✓ Network and VPC (~3 min)
```

### Step 3: Verify Cleanup

```bash
# Verify in AWS console or CLI
aws eks list-clusters --region us-east-1

# Should return empty: {"clusters": []}

# Check VPCs
aws ec2 describe-vpcs --filters "Name=tag:Project,Values=my-project" --region us-east-1

# Should return empty
```

---

## 💡 Tips and Tricks

### 1. Automation Scripts

Create scripts to make it easier:

**`start.sh`:**
```bash
#!/bin/bash
set -e
echo "🚀 Creating EKS cluster..."
terraform apply -auto-approve
echo "⚙️ Configuring kubectl..."
$(terraform output -raw configure_kubectl)
echo "✅ Ready! Checking nodes..."
kubectl get nodes
```

**`stop.sh`:**
```bash
#!/bin/bash
set -e
echo "🧹 Cleaning Kubernetes resources..."
kubectl delete deployments --all
kubectl delete services --all-namespaces -l "app"
sleep 60
echo "🗑️ Destroying infrastructure..."
terraform destroy -auto-approve
echo "✅ Infrastructure destroyed!"
```

### 2. Save More

```hcl
# For studies without external access to nodes:
enable_nat_gateway = false  # Saves $32/month

# Use only when you need:
# - Pull private images
# - Internet access from pods
# - Integration with external APIs
```

### 3. Monitor Costs

```bash
# View costs in AWS CLI
aws ce get-cost-and-usage \
  --time-period Start=2026-01-01,End=2026-01-31 \
  --granularity DAILY \
  --metrics BlendedCost \
  --group-by Type=TAG,Key=Project

# Set up cost alert in AWS console:
# Billing → Budgets → Create budget
# - Type: Cost budget
# - Amount: $20/month
# - Alert: 80% ($16)
```

### 4. Persist Data Between Destructions

Use S3 for important data:

```bash
# Save configs
kubectl get configmaps -o yaml > backup-configs.yaml

# Backup to S3
aws s3 cp backup-configs.yaml s3://your-bucket/backups/

# Restore later
aws s3 cp s3://your-bucket/backups/backup-configs.yaml .
kubectl apply -f backup-configs.yaml
```

---

## 📊 Scenario Comparison

| Scenario | Hours/month | Cost | Best For |
|---------|-----------|-------|-------------|
| **24/7 On-Demand** | 730h | $138/month | Production |
| **24/7 Spot** | 730h | $127/month | Staging 24/7 |
| **20h/week (Destroy)** | 87h | **$15/month** | **Studies** ⭐ |
| **10h/week (Destroy)** | 43h | **$8/month** | **Studies** ⭐⭐ |

---

## 🐛 Troubleshooting

### Error: "Error creating EKS Cluster"

**Cause**: Insufficient IAM permissions  
**Solution**:
```bash
# Check permissions
aws iam get-user

# Add necessary policies in IAM Console
```

### Error: "Error creating Node Group"

**Cause**: Service Quotas limits  
**Solution**:
```bash
# View limits
aws service-quotas list-service-quotas \
  --service-code eks \
  --region us-east-1

# Request increase in AWS console
```

### kubectl won't connect

```bash
# Reconfigure
aws eks update-kubeconfig --region us-east-1 --name CLUSTER-NAME --profile default

# Check credentials
aws sts get-caller-identity

# Test access
kubectl cluster-info
```

### Cost higher than expected

```bash
# Check undestroyed resources
aws resourcegroupstaggingapi get-resources \
  --tag-filters Key=Project,Values=my-project

# Delete orphaned Load Balancers
aws elb describe-load-balancers --region us-east-1

# Check NAT Gateway
aws ec2 describe-nat-gateways --region us-east-1
```

---

## 🎓 Next Steps

Now that you have a working cluster:

### 1. Kubernetes Basics
- Deployments, Services, ConfigMaps
- Namespaces and Resource Quotas
- Persistent Volumes

### 2. Essential Tools
- **Helm**: K8s package manager
- **Ingress Controller**: NGINX or ALB
- **Cert-Manager**: Automatic SSL certificates

### 3. Observability
- **Prometheus + Grafana**: Metrics
- **ELK Stack**: Centralized logs
- **Jaeger**: Distributed tracing

### 4. CI/CD
- **GitHub Actions**: Automated pipeline
- **ArgoCD**: GitOps for K8s
- **Flux**: ArgoCD alternative

### 5. Service Mesh
- **Istio**: Advanced traffic management
- **Linkerd**: Lightweight service mesh

---

## 📚 Learning Resources

### Free Courses
- [Kubernetes Basics (Kubernetes.io)](https://kubernetes.io/docs/tutorials/kubernetes-basics/)
- [EKS Workshop](https://www.eksworkshop.com/)
- [Terraform AWS Tutorial](https://learn.hashicorp.com/collections/terraform/aws-get-started)

### Certifications
- **CKA**: Certified Kubernetes Administrator
- **CKAD**: Certified Kubernetes Application Developer
- **AWS Certified Solutions Architect**

### Communities
- [Kubernetes Slack](https://slack.k8s.io/)
- [Reddit r/kubernetes](https://reddit.com/r/kubernetes)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/kubernetes)

---

## 🤝 Share This Guide

Help other students:

- 👍 LinkedIn: Share with your network
- 🐦 Twitter: Tweet with #Kubernetes #AWS #EKS
- 📝 Blog: Write about your experience
- ⭐ GitHub: Star this repository

---

## 📞 Support

- 🐛 Issues: Open an issue on GitHub
- 💬 Discussions: Use the Discussions tab
- 📧 Email: [your-email@example.com]

---

## ✨ Conclusion

Congratulations! 🎉 You now know how to:

✅ Provision AWS infrastructure with Terraform  
✅ Create and manage EKS clusters  
✅ Optimize costs using Spot Instances  
✅ Deploy applications in Kubernetes  
✅ Destroy resources to save money  

**Cost to study Kubernetes**: $8-15/month (vs $127 24/7)  
**Savings**: 88-94%  
**Knowledge**: Priceless 🚀  

---

**Happy learning and let's code! 💻**

*Created with ❤️ for the developer community*
