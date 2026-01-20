# 💰 Detailed Cost Analysis - EKS Project

> Last updated: January 2026  
> Region: us-east-1 (N. Virginia)

## 📊 Executive Summary

### With Spot Instances (Current Configuration)
- **Total Cost**: ~$115.60/month (~$1,387/year)
- **Savings vs On-Demand**: $8.40/month ($100.80/year)
- **Savings Percentage**: 7% overall

### Without NAT Gateway + Spot (Dev)
- **Total Cost**: ~$78.60/month (~$943/year)
- **Savings vs Production**: $45.40/month ($544.80/year)
- **Savings Percentage**: 36%

---

## 🔍 Resource Breakdown

### 1️⃣ Network

| Resource | Quantity | Unit Cost | Total/month | Notes |
|---------|----------|-----------|-------------|-------|
| **VPC** | 1 | $0 | $0 | Free |
| **Subnets** | 4 | $0 | $0 | Free |
| **Internet Gateway** | 1 | $0 | $0 | Free |
| **Route Tables** | 2 | $0 | $0 | Free |
| **NAT Gateway** | 1 | $0.045/hour | **$32.85** | 730 hours/month |
| **NAT Data Processing** | ~100GB | $0.045/GB | **$4.50** | Variable |
| **Elastic IP** | 1 | $0 | $0 | Free (in use) |
| **Network Subtotal** | | | **$37.35** | |

💡 **Cost-Saving Tip**: Disabling NAT in dev saves $37.35/month

---

### 2️⃣ EKS Cluster

| Resource | Quantity | Unit Cost | Total/month | Notes |
|---------|----------|-----------|-------------|-------|
| **EKS Control Plane** | 1 | $0.10/hour | **$73.00** | Fixed (730 hours/month) |
| **EKS Subtotal** | | | **$73.00** | Fixed cost regardless of usage |

---

### 3️⃣ Worker Nodes (Compute)

#### Option A: Spot Instances (Default ✅)

| Resource | Quantity | Unit Cost | Total/month | Savings |
|---------|----------|-----------|-------------|---------|
| **t3.micro Spot** | 2 | $0.0025/hour | **$3.65** | 70% |
| **EBS gp3 (20GB)** | 2 | $0.08/GB-month | **$3.20** | - |
| **Nodes Subtotal (Spot)** | | | **$6.85** | -$11.35 |

#### Option B: On-Demand

| Resource | Quantity | Unit Cost | Total/month | Savings |
|---------|----------|-----------|-------------|---------|
| **t3.micro On-Demand** | 2 | $0.0104/hour | **$15.18** | 0% |
| **EBS gp3 (20GB)** | 2 | $0.08/GB-month | **$3.20** | - |
| **Nodes Subtotal (On-Demand)** | | | **$18.38** | - |

💡 **Savings with Spot**: $11.53/month per node group

---

### 4️⃣ Data Transfer

| Type | Estimate | Unit Cost | Total/month | Notes |
|------|----------|-----------|-------------|-------|
| **Internet Ingress** | Unlimited | $0 | $0 | Free |
| **Internet Egress** | 100GB | $0.09/GB | **$9.00** | First 10TB |
| **Inter-AZ** | 50GB | $0.01/GB | **$0.50** | Between AZs |
| **Transfer Subtotal** | | | **$9.50** | Variable |

---

## 📈 Cost Scenarios

### Scenario 1: Development (Recommended)
**Configuration**: No NAT + Spot Instances

```hcl
enable_nat_gateway = false
eks_node_capacity_type = "SPOT"
eks_node_instance_types = ["t3.micro"]
eks_node_desired_size = 2
```

| Item | Cost |
|------|------|
| EKS Cluster | $73.00 |
| 2x t3.micro Spot | $3.65 |
| EBS (40GB) | $3.20 |
| Data Transfer | $5.00 |
| **Total** | **$84.85/month** |

✅ **Best for**: Dev, testing, ephemeral environments  
💰 **Annual savings**: $496.80 vs Production

---

### Scenario 2: Staging (Balanced)
**Configuration**: NAT + Spot Instances

```hcl
enable_nat_gateway = true
eks_node_capacity_type = "SPOT"
eks_node_instance_types = ["t3.micro"]
eks_node_desired_size = 2
```

| Item | Cost |
|------|------|
| Network (NAT) | $37.35 |
| EKS Cluster | $73.00 |
| 2x t3.micro Spot | $3.65 |
| EBS (40GB) | $3.20 |
| Data Transfer | $9.50 |
| **Total** | **$126.70/month** |

✅ **Best for**: Staging, pre-production  
💰 **Savings**: 50% vs same config On-Demand

---

### Scenario 3: Production (Stable)
**Configuration**: NAT + On-Demand + More Nodes

```hcl
enable_nat_gateway = true
eks_node_capacity_type = "ON_DEMAND"
eks_node_instance_types = ["t3.small"]
eks_node_desired_size = 3
```

| Item | Cost |
|------|------|
| Network (NAT) | $37.35 |
| EKS Cluster | $73.00 |
| 3x t3.small On-Demand | $45.99 |
| EBS (60GB) | $4.80 |
| Data Transfer | $15.00 |
| **Total** | **$176.14/month** |

✅ **Best for**: Production, critical workloads  
⚠️ **Trade-off**: +$49.44/month for 99.9% availability

---

### Scenario 4: Optimized Production (Mix)
**Configuration**: NAT + 70% Spot + 30% On-Demand

```hcl
# Use Cluster Autoscaler with priorities
enable_nat_gateway = true
# Node group 1 (Spot): 70% of capacity
# Node group 2 (On-Demand): 30% backup
```

| Item | Cost |
|------|------|
| Network (NAT) | $37.35 |
| EKS Cluster | $73.00 |
| 2x t3.small Spot | $10.95 |
| 1x t3.small On-Demand | $15.33 |
| EBS (60GB) | $4.80 |
| Data Transfer | $15.00 |
| **Total** | **$156.43/month** |

✅ **Best for**: Cost-optimized production  
💰 **Savings**: $19.71/month vs pure On-Demand production

---

## 🎯 Environment Recommendations

### 🟢 Development
```
Configuration: Scenario 1
Cost: $84.85/month
ROI: Maximum
```

### 🟡 Staging/QA
```
Configuration: Scenario 2
Cost: $126.70/month
ROI: High
```

### 🔴 Production (Critical)
```
Configuration: Scenario 3
Cost: $176.14/month
ROI: Stability
```

### 🟣 Production (Optimized)
```
Configuration: Scenario 4
Cost: $156.43/month
ROI: Balanced
```

---

## 💡 Optimization Strategies

### 1. Disable NAT in Dev
**Savings**: $37.35/month  
**How**: `enable_nat_gateway = false`  
**Impact**: Nodes cannot access internet (use VPN/Bastion if needed)

### 2. Use Spot Instances
**Savings**: 50-70% on nodes  
**How**: `eks_node_capacity_type = "SPOT"`  
**Impact**: Possible interruption (2 min warning)

### 3. Instance Right-sizing
**Savings**: 30-50%  
**How**: Monitor usage and adjust instance types  
**Tools**: CloudWatch, Kubecost, AWS Compute Optimizer

### 4. EBS Optimization
**Savings**: $1-2/node  
**How**: 
- Use gp3 instead of gp2 (same cost, better performance)
- Adjust disk size (default: 20GB)
- Consider snapshot lifecycle

### 5. Reserved Instances (Long-term)
**Savings**: 30-40% vs On-Demand  
**How**: Purchase 1 or 3 year commitment  
**Best for**: Stable production

### 6. Savings Plans
**Savings**: 20-30%  
**How**: Commit compute usage for 1-3 years  
**Flexibility**: Can change instance types

---

## 📊 Annual Cost Comparison

| Scenario | Monthly | Annual | vs Dev | vs Prod |
|---------|--------|--------|--------|---------|
| **Dev (No NAT + Spot)** | $84.85 | $1,018 | - | -54% |
| **Staging (NAT + Spot)** | $126.70 | $1,520 | +49% | -28% |
| **Prod (NAT + On-Demand)** | $176.14 | $2,114 | +108% | - |
| **Prod Mix (70/30)** | $156.43 | $1,877 | +84% | -11% |

---

## 🔄 Optimization Cycle

### Month 1: Setup
- Use Spot in Dev/Staging
- Monitor interruption rate
- Collect usage metrics

### Month 2-3: Analysis
- Review costs in Cost Explorer
- Identify underutilized resources
- Adjust node groups

### Month 4+: Continuous Optimization
- Implement metrics-based auto-scaling
- Consider Reserved Instances
- Evaluate migration to ARM (Graviton) - 20% cheaper

---

## 🎓 References

- [AWS EKS Pricing](https://aws.amazon.com/eks/pricing/)
- [EC2 Spot Instances](https://aws.amazon.com/ec2/spot/pricing/)
- [AWS Pricing Calculator](https://calculator.aws/)
- [EKS Best Practices - Cost Optimization](https://aws.github.io/aws-eks-best-practices/cost_optimization/)

---

## 📞 Support

For questions about costs or optimizations, consult:
- AWS Cost Explorer
- AWS Trusted Advisor
- AWS Compute Optimizer
