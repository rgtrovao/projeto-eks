# 🚀 Projeto EKS - Infraestrutura AWS com Terraform

> Cluster Kubernetes completo e otimizado na AWS com **economia de até 94%** usando estratégia sob demanda.

[![Terraform](https://img.shields.io/badge/Terraform-1.0+-623CE4?logo=terraform)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-EKS-FF9900?logo=amazon-aws)](https://aws.amazon.com/eks/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.30-326CE5?logo=kubernetes)](https://kubernetes.io/)

## 📋 O que este projeto faz?

Provisiona uma infraestrutura completa e production-ready de **Amazon EKS** (Kubernetes gerenciado) usando **Terraform**, incluindo:

- ✅ VPC com subnets públicas e privadas em 2 AZs
- ✅ Cluster EKS (Kubernetes 1.30)
- ✅ Node Group com Spot Instances (70% mais barato)
- ✅ NAT Gateway, Internet Gateway e Route Tables
- ✅ IAM Roles e Security Groups configurados
- ✅ Tags para descoberta automática de recursos

## 💰 Custo Estimado

### Uso sob demanda (Recomendado para estudos)
```
20h/semana: ~$15.37/mês (94% de economia vs 24/7)
10h/semana: ~$8.08/mês  (94% de economia vs 24/7)
```

### Uso contínuo 24/7
```
Spot Instances:    $126.70/mês
On-Demand:         $138.23/mês
```

💡 **Estratégia**: Criar quando precisar (`terraform apply`), destruir quando terminar (`terraform destroy`)

📊 [Ver análise detalhada de custos](CUSTOS.md)

## 🏗️ Arquitetura

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

**Recursos provisionados:** 25 recursos AWS

## 🚀 Quick Start

### Pré-requisitos

```bash
# Instalar ferramentas
terraform --version  # >= 1.0
aws configure        # Configurar credenciais
kubectl version      # Cliente Kubernetes
```

### 1. Clonar e Configurar

```bash
# Criar bucket S3 para estado do Terraform
aws s3 mb s3://seu-bucket-terraform --region us-east-1

# Editar main.tf e alterar o bucket
# backend "s3" {
#   bucket = "seu-bucket-terraform"  # ← Altere aqui
# }

# Criar arquivo de configuração
cp terraform.tfvars.example terraform.tfvars
# Edite terraform.tfvars com suas preferências
```

### 2. Provisionar Infraestrutura

```bash
# Inicializar Terraform
terraform init

# Visualizar o que será criado
terraform plan

# Criar infraestrutura (~20-25 minutos)
terraform apply
```

### 3. Configurar kubectl

```bash
# Configurar acesso ao cluster
aws eks update-kubeconfig --region us-east-1 --name SEU-PROJETO-eks

# Verificar nodes
kubectl get nodes
```

### 4. Testar o Cluster

```bash
# Deploy de teste
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=LoadBalancer

# Ver serviços
kubectl get svc

# Acessar aplicação
curl http://<EXTERNAL-IP>
```

### 5. Destruir Infraestrutura (IMPORTANTE!)

```bash
# Limpar recursos Kubernetes
kubectl delete deployment nginx
kubectl delete svc nginx

# Destruir infraestrutura (~10-15 minutos)
terraform destroy
```

## 📁 Estrutura do Projeto

```
projeto-eks/
├── main.tf                    # Configuração principal
├── variables.tf               # Variáveis de entrada
├── outputs.tf                 # Outputs (endpoints, comandos)
├── terraform.tfvars.example   # Exemplo de configuração
├── modules/
│   ├── network/               # VPC, Subnets, IGW, NAT, RT
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── eks/                   # Cluster EKS + Node Group
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── README.md                  # Este arquivo
├── CUSTOS.md                  # Análise detalhada de custos
├── CHANGELOG.md               # Histórico de mudanças
└── HOWTO.md                   # Guia completo passo a passo
```

## ⚙️ Variáveis Principais

| Variável | Descrição | Padrão |
|----------|-----------|--------|
| `project_name` | Nome do projeto | `rgtrovao-project` |
| `aws_region` | Região AWS | `us-east-1` |
| `vpc_cidr` | CIDR da VPC | `10.0.0.0/16` |
| `availability_zones` | AZs a usar | `["us-east-1a", "us-east-1b"]` |
| `enable_nat_gateway` | Habilitar NAT | `true` |
| `eks_cluster_version` | Versão Kubernetes | `1.30` |
| `eks_node_capacity_type` | SPOT ou ON_DEMAND | `SPOT` |
| `eks_node_instance_types` | Tipo de instância | `["t3.micro"]` |
| `eks_node_desired_size` | Número de nodes | `2` |

## 📤 Outputs Disponíveis

Após o deploy, você terá acesso a:

```bash
terraform output cluster_name              # Nome do cluster
terraform output cluster_endpoint          # URL da API
terraform output configure_kubectl         # Comando para configurar kubectl
terraform output vpc_id                    # ID da VPC
terraform output private_subnet_ids        # IDs das subnets privadas
```

## 💡 Configurações Recomendadas

### Para Desenvolvimento/Estudos

```hcl
# terraform.tfvars
enable_nat_gateway = false              # Economiza $32/mês
eks_node_capacity_type = "SPOT"         # Economiza 70%
eks_node_instance_types = ["t3.micro"]
eks_node_desired_size = 2
```

**Custo**: ~$8/mês (usando 10h/semana)

### Para Produção

```hcl
# terraform.tfvars
enable_nat_gateway = true
eks_node_capacity_type = "ON_DEMAND"    # Estabilidade
eks_node_instance_types = ["t3.small"]
eks_node_min_size = 3
eks_node_max_size = 10
eks_node_desired_size = 3
```

**Custo**: ~$176/mês (24/7)

## 🎯 Casos de Uso

### ✅ Ideal para:
- 📚 Aprendizado de Kubernetes e EKS
- 🧪 Ambiente de testes e experimentação
- 👨‍💻 Desenvolvimento de aplicações cloud-native
- 🎓 Preparação para certificações (CKA, CKAD, AWS)
- 💼 Proof of Concepts (POCs)

### ⚠️ Considerar outras opções para:
- 🏭 Produção 24/7 com alta disponibilidade
- 💰 Orçamento muito restrito (<$50/mês)
- 🔒 Ambientes com compliance rigoroso

## 📚 Documentação Adicional

- **[HOWTO.md](HOWTO.md)** - Guia passo a passo detalhado
- **[CUSTOS.md](CUSTOS.md)** - Análise completa de custos por cenário
- **[CHANGELOG.md](CHANGELOG.md)** - Histórico de otimizações

## 🔧 Comandos Úteis

```bash
# Validar configuração
terraform validate

# Formatar código
terraform fmt -recursive

# Ver estado atual
terraform show

# Atualizar apenas rede
terraform apply -target=module.network

# Ver logs de custos
aws ce get-cost-and-usage \
  --time-period Start=2026-01-01,End=2026-01-31 \
  --granularity MONTHLY \
  --metrics BlendedCost
```

## 🐛 Troubleshooting

### Erro: "Error creating EKS Cluster"
- Verifique permissões IAM da sua conta AWS
- Confirme limites de serviço (Service Quotas)

### kubectl não conecta
```bash
# Reconfigurar
aws eks update-kubeconfig --region us-east-1 --name SEU-CLUSTER

# Verificar credenciais
aws sts get-caller-identity
```

### Custo maior que esperado
- Verifique se há recursos não destruídos: `aws resourcegroupstaggingapi get-resources`
- Confirme que Load Balancers foram deletados
- Revise NAT Gateway (maior custo variável)

## 🔒 Segurança

✅ **Implementado:**
- Nodes em subnets privadas
- Security groups restritivos
- IAM roles com princípio do menor privilégio
- Estado do Terraform em S3 com versionamento

⚠️ **Recomendações adicionais para produção:**
- Habilitar encryption de secrets no EKS
- Implementar Pod Security Standards
- Configurar Network Policies
- Ativar audit logs do control plane
- Usar AWS Secrets Manager para credenciais

## 🤝 Contribuindo

Melhorias são bem-vindas! Para contribuir:

1. Fork o projeto
2. Crie uma branch (`git checkout -b feature/melhoria`)
3. Commit suas mudanças (`git commit -m 'feat: adiciona xyz'`)
4. Push para a branch (`git push origin feature/melhoria`)
5. Abra um Pull Request

## 📄 Licença

MIT License - veja arquivo LICENSE para detalhes

## 🎓 Recursos Adicionais

- [Documentação oficial do EKS](https://docs.aws.amazon.com/eks/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [EKS Best Practices](https://aws.github.io/aws-eks-best-practices/)
- [Spot Instances Best Practices](https://aws.amazon.com/ec2/spot/getting-started/)

## ⭐ Apoie o Projeto

Se este projeto te ajudou:
- ⭐ Dê uma estrela no GitHub
- 🔄 Compartilhe com outros desenvolvedores
- 💬 Deixe feedback ou sugestões
- 📝 Escreva um artigo sobre sua experiência

---

**Criado com ❤️ para a comunidade de desenvolvedores**

*Questões? Abra uma issue no GitHub!*
