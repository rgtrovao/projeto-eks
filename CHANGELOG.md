# 📝 Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [2.0.0] - 2026-01-20

### 🎉 Optimized Version - Up to 94% Savings

This version represents a complete project refactoring focused on:
- Cost savings (Spot Instances)
- Modularity (module consolidation)
- Documentation (practical guides)

### ✨ Added

- **Spot Instances by default**: 70% savings on compute costs
- **Consolidated network module**: VPC + IGW + NAT + Route Tables in a single module
- **Complete documentation**:
  - `HOWTO.md`: Detailed step-by-step guide
  - `COSTS.md`: Complete cost analysis by scenario
  - `.gitignore`: Protection of sensitive files
- **`capacity_type` variable**: Easily switch between SPOT and ON_DEMAND
- **EKS tags on subnets**: `kubernetes.io/cluster/*` for automatic discovery
- **Variable validation**: `capacity_type` validates only SPOT or ON_DEMAND
- **Lifecycle rules**: Node group ignores `desired_size` changes

### 🔄 Changed

- **Module structure**: 5 modules → 2 modules (network + eks)
- **NAT Gateway**: 3 NAT Gateways (1 per AZ) → 1 NAT Gateway ($64/month savings)
- **Dynamic CIDRs**: Using `cidrsubnet()` instead of hardcoded lists
- **EKS Security Group**: Egress restricted to VPC CIDR (was: 0.0.0.0/0)
- **Kubernetes version**: 1.28 → 1.30
- **README.md**: Completely rewritten with focus on quick start
- **Variables**: Organized and documented
- **Outputs**: Simplified and more useful

### 🗑️ Removed

- **Database subnets**: Removed (not being used)
- **Separate modules**:
  - `modules/vpc` → consolidated into `modules/network`
  - `modules/internet_gateway` → consolidated into `modules/network`
  - `modules/subnets` → consolidated into `modules/network`
  - `modules/route_tables` → consolidated into `modules/network`
- **Redundant tags**: `Type` and `Tier` (kept only essential tags)
- **Unversioned output files**: `output/` added to `.gitignore`
- **Unused variables**: Cleanup of obsolete variables

### 🐛 Fixed

- **Merge conflicts** in `variables.tf` and `README.md`
- **Resource dependencies**: NAT Gateway now explicitly depends on IGW
- **IAM Role names**: Added `-cluster-role` and `-node-role` suffixes for clarity

### 💰 Cost Impact

| Configuration | Before | After | Savings |
|--------------|--------|-------|---------|
| **NAT Gateway** | 3x $32 = $96/month | 1x $32 = $32/month | $64/month |
| **Compute (24/7)** | ON_DEMAND $15.18 | SPOT $3.65 | $11.53/month |
| **Total (24/7)** | ~$181/month | ~$127/month | $54/month (30%) |
| **Usage 20h/week** | - | ~$15.37/month | $111/month (88%) |
| **Usage 10h/week** | - | ~$8.08/month | $119/month (94%) |

### 📊 Project Statistics

- **Lines of code**: ~40% reduction in `main.tf`
- **Module files**: 15 → 6 (60% reduction)
- **AWS resources**: 25 resources provisioned
- **Deploy time**: ~20-25 minutes
- **Destroy time**: ~10-15 minutes

---

## [1.0.0] - 2026-01-15

### ✨ Initial Release

- Provisions complete VPC with 3 AZs
- Public, private, and database subnets
- Internet Gateway and 3 NAT Gateways
- EKS Cluster with Kubernetes 1.28
- Node Group with On-Demand instances
- Separate modules for each component

---

## 🔮 Future Roadmap

### [2.1.0] - Planned

- [ ] Support for multiple node groups (mix Spot + On-Demand)
- [ ] Managed EKS add-ons (VPC CNI, CoreDNS, kube-proxy)
- [ ] Cluster Autoscaler configuration
- [ ] AWS Load Balancer Controller integration
- [ ] Application examples (K8s manifests)

### [2.2.0] - Planned

- [ ] Observability module (Prometheus + Grafana)
- [ ] CI/CD with GitHub Actions
- [ ] Automated testing (Terratest)
- [ ] EKS on Fargate support
- [ ] Pod Security Standards policy

### [3.0.0] - Future

- [ ] Multi-region (DR and HA)
- [ ] Service Mesh (Istio or Linkerd)
- [ ] GitOps with ArgoCD
- [ ] Secrets management (AWS Secrets Manager)
- [ ] Cost optimization dashboard

---

## 📝 How to Contribute

Found a bug? Have a suggestion? Open an issue or PR!

1. Fork the project
2. Create a branch (`git checkout -b feature/improvement`)
3. Commit your changes (`git commit -m 'feat: add xyz'`)
4. Push to the branch (`git push origin feature/improvement`)
5. Open a Pull Request

---

## 🏷️ Versioning

This project uses [Semantic Versioning](https://semver.org/):

- **MAJOR** (X.0.0): Incompatible changes (breaking changes)
- **MINOR** (0.X.0): New features (backwards compatible)
- **PATCH** (0.0.X): Bug fixes

---

## 📞 Support

- 🐛 **Bugs**: Open an issue on GitHub
- 💡 **Suggestions**: Use the Discussions tab
- 📧 **Contact**: [your-email@example.com]

---

**Maintained with ❤️ by the community**
