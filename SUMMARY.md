# 📦 Resumo do Projeto EKS

> Documentação atualizada e concisa - Janeiro 2026

## 🎯 Visão Geral

Projeto Terraform completo para provisionar cluster **Amazon EKS** (Kubernetes 1.30) na AWS com foco em **economia** e **boas práticas**.

### ✨ Destaques

- 💰 **Economia de até 94%** usando estratégia sob demanda
- ☸️ **Kubernetes 1.30** atualizado
- 🎯 **Spot Instances** por padrão (70% mais barato)
- 📦 **2 módulos** consolidados (network + eks)
- 📚 **Documentação completa** e prática

## 📁 Estrutura de Arquivos

```
projeto-eks/
├── 📘 README.md                  # Início rápido e visão geral
├── 📗 HOWTO.md                   # Guia passo a passo completo
├── 💰 CUSTOS.md                  # Análise detalhada de custos
├── 📝 CHANGELOG.md               # Histórico de mudanças
├── 🔧 main.tf                    # Configuração principal (66 linhas)
├── 🔧 variables.tf               # Variáveis (87 linhas)
├── 🔧 outputs.tf                 # Outputs úteis
├── 📄 terraform.tfvars.example   # Template de configuração
├── 🚫 .gitignore                 # Proteção de arquivos sensíveis
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

## 📚 Guia de Navegação

### 🚀 Para Começar Rápido
👉 **[README.md](README.md)** - Quick start, arquitetura, comandos básicos

### 📖 Para Guia Completo
👉 **[HOWTO.md](HOWTO.md)** - Tutorial passo a passo com troubleshooting

### 💵 Para Entender Custos
👉 **[CUSTOS.md](CUSTOS.md)** - Análise por cenário, dicas de economia

### 🔄 Para Ver Mudanças
👉 **[CHANGELOG.md](CHANGELOG.md)** - Histórico de otimizações

## 💰 Custos Estimados

### Por Padrão de Uso

| Uso | Horas/mês | Custo/mês | Economia |
|-----|-----------|-----------|----------|
| **10h/semana** | 43h | $8.08 | 94% 🏆 |
| **20h/semana** | 87h | $15.37 | 88% ⭐ |
| **24/7 Spot** | 730h | $126.70 | 8% |
| **24/7 On-Demand** | 730h | $138.23 | 0% |

### Breakdown de Custos (24/7 Spot)

| Componente | Custo/mês | % |
|------------|-----------|---|
| EKS Control Plane | $73.00 | 58% |
| NAT Gateway + Data | $37.35 | 29% |
| 2x t3.micro Spot | $3.65 | 3% |
| EBS + Transfer | $12.70 | 10% |
| **Total** | **$126.70** | 100% |

## 🏗️ Recursos Provisionados

**Total: 25 recursos AWS**

### Rede (13 recursos)
- 1 VPC
- 1 Internet Gateway
- 1 NAT Gateway + Elastic IP
- 4 Subnets (2 públicas + 2 privadas)
- 2 Route Tables + 5 associações/rotas

### EKS (12 recursos)
- 1 Cluster EKS
- 1 Node Group (2 nodes t3.micro Spot)
- 2 Security Groups + 1 regra
- 2 IAM Roles + 4 Policy Attachments

## ⚡ Comandos Rápidos

```bash
# Setup inicial
terraform init
terraform plan

# Criar infraestrutura (~20-25 min)
terraform apply

# Configurar kubectl
$(terraform output -raw configure_kubectl)

# Verificar
kubectl get nodes

# Destruir (~10-15 min)
terraform destroy
```

## 🎯 Casos de Uso

### ✅ Ideal para:
- 📚 Aprendizado de Kubernetes/EKS
- 🧪 Ambiente de testes
- 👨‍💻 Desenvolvimento
- 🎓 Certificações (CKA, CKAD, AWS)
- 💼 POCs e demos

### ⚠️ Considerar alternativas para:
- 🏭 Produção crítica 24/7
- 💰 Orçamento < $50/mês
- 🔒 Compliance rigoroso

## 📊 Métricas do Projeto

| Métrica | Valor |
|---------|-------|
| **Linhas de código** | ~600 linhas |
| **Módulos** | 2 (network + eks) |
| **Recursos AWS** | 25 recursos |
| **Tempo de deploy** | ~20-25 minutos |
| **Tempo de destroy** | ~10-15 minutos |
| **Custo mínimo** | $8.08/mês (10h/sem) |
| **Economia máxima** | 94% vs 24/7 |

## 🔧 Configuração Padrão

```hcl
# Perfil: Estudos com Spot Instances
project_name = "meu-projeto"
aws_region = "us-east-1"
vpc_cidr = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]

# Rede
enable_nat_gateway = true  # $32/mês

# EKS
eks_cluster_version = "1.30"
eks_node_capacity_type = "SPOT"  # 70% economia
eks_node_instance_types = ["t3.micro"]
eks_node_desired_size = 2
```

## ✨ Mudanças vs Versão 1.0

| Aspecto | Antes | Depois | Melhoria |
|---------|-------|--------|----------|
| **Módulos** | 5 | 2 | -60% complexidade |
| **NAT Gateways** | 3 | 1 | -$64/mês |
| **Compute** | On-Demand | Spot | -70% |
| **Kubernetes** | 1.28 | 1.30 | Atualizado |
| **Subnets Database** | Sim | Não | Simplificado |
| **Documentação** | Básica | Completa | +400% |
| **Custo 24/7** | $181 | $127 | -30% |

## 🎓 Recursos de Aprendizado

### Documentação
- [AWS EKS Docs](https://docs.aws.amazon.com/eks/)
- [Kubernetes Docs](https://kubernetes.io/docs/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/)

### Guias e Workshops
- [EKS Workshop](https://www.eksworkshop.com/)
- [EKS Best Practices](https://aws.github.io/aws-eks-best-practices/)
- [Terraform Learn](https://learn.hashicorp.com/terraform)

## 🤝 Contribuindo

Este projeto é mantido pela comunidade:

1. 🍴 Fork o projeto
2. 🌿 Crie uma branch (`feature/melhoria`)
3. 💬 Commit suas mudanças
4. 📤 Push e abra um PR
5. ⭐ Deixe uma estrela!

## 📞 Suporte

- 🐛 **Issues**: Problemas e bugs
- 💡 **Discussions**: Perguntas e ideias
- 📧 **Email**: Contato direto

## 📄 Licença

MIT License - Use livremente!

---

## 🎉 Quick Links

| 📖 Documentação | 🔗 Link |
|----------------|---------|
| Início Rápido | [README.md](README.md) |
| Guia Completo | [HOWTO.md](HOWTO.md) |
| Análise de Custos | [CUSTOS.md](CUSTOS.md) |
| Histórico | [CHANGELOG.md](CHANGELOG.md) |
| Exemplo Config | [terraform.tfvars.example](terraform.tfvars.example) |

---

**Criado com ❤️ para a comunidade de desenvolvedores**

*Última atualização: Janeiro 2026*
