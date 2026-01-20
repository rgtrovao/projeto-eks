# 🚀 Como Provisionar um Cluster EKS na AWS com Terraform

> **Guia Completo para Estudantes de Kubernetes e AWS**

---

## ⚠️ ESTRATÉGIA DE CUSTO PARA ESTUDOS

### 🎯 Use sob demanda, destrua quando não estiver usando!

Este guia foi criado para quem está **estudando** Kubernetes e quer **economia máxima**:

✅ **Criar cluster**: `terraform apply` (~20 minutos)  
✅ **Estudar**: Quanto tempo precisar  
✅ **Destruir**: `terraform destroy` (~15 minutos)  

### 💰 Estimativa de Custo (20h/semana)

```
┌────────────────────────────────────────┐
│ Uso Semanal:    20 horas              │
│ Uso Mensal:     ~86.6 horas           │
│ Custo Mensal:   ~$15.37               │
│ Custo por Hora: $0.18                 │
│                                        │
│ 🎉 94% mais barato que manter 24/7!   │
└────────────────────────────────────────┘
```

**Breakdown:**
- EKS Control Plane: $8.66/mês
- 2x EC2 t3.micro Spot: $0.43/mês
- NAT Gateway: $3.90/mês
- Storage + Transfer: $2.38/mês

💡 **Comparação**: Cluster 24/7 = ~$127/mês | Sob demanda (20h/sem) = **$15.37/mês**

---

## 🎯 O que você vai aprender

Ao final deste guia, você terá:

✅ Cluster EKS funcionando (Kubernetes 1.30)  
✅ Infraestrutura de rede completa (VPC, Subnets, NAT, IGW)  
✅ Conhecimento prático de Terraform  
✅ 2 worker nodes configurados  
✅ kubectl configurado e pronto  
✅ Economia de até 94% nos custos  

---

## 📋 Pré-requisitos

### 1. Ferramentas Necessárias

```bash
# Terraform >= 1.0
brew install terraform      # macOS
# ou
choco install terraform     # Windows
# ou
sudo apt install terraform  # Linux

# AWS CLI
brew install awscli         # macOS
pip install awscli         # Qualquer SO

# kubectl
brew install kubectl        # macOS
choco install kubernetes-cli # Windows
```

### 2. Conta AWS

- Criar conta AWS (Free Tier disponível)
- Obter Access Key e Secret Key
- Configurar credenciais:

```bash
aws configure
# AWS Access Key ID: AKIAIOSFODNN7EXAMPLE
# AWS Secret Access Key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
# Default region name: us-east-1
# Default output format: json
```

### 3. Verificar Permissões

Sua conta AWS precisa de permissões para:
- EC2 (criar VPC, subnets, security groups)
- EKS (criar cluster e node groups)
- IAM (criar roles e policies)
- S3 (armazenar estado do Terraform)

---

## 🏗️ Arquitetura Completa

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

**Total de recursos AWS:** 25 recursos

---

## 🚀 Passo a Passo - Instalação

### Passo 1: Obter o Código

```bash
# Opção A: Clonar repositório (se disponível)
git clone https://github.com/seu-usuario/projeto-eks
cd projeto-eks

# Opção B: Download direto ou criar manualmente
mkdir projeto-eks && cd projeto-eks
```

### Passo 2: Backend S3

O Terraform precisa de um local para armazenar o estado da infraestrutura:

```bash
# Criar bucket S3 (nome deve ser único globalmente)
aws s3 mb s3://seu-nome-unico-terraform-state --region us-east-1

# Habilitar versionamento (backup de segurança)
aws s3api put-bucket-versioning \
  --bucket seu-nome-unico-terraform-state \
  --versioning-configuration Status=Enabled

# Habilitar encryption
aws s3api put-bucket-encryption \
  --bucket seu-nome-unico-terraform-state \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'
```

### Passo 3: Configurar Backend

Edite o arquivo `main.tf` e altere o nome do bucket:

```hcl
backend "s3" {
  bucket = "seu-nome-unico-terraform-state"  # ← ALTERE AQUI
  key    = "eks/terraform.tfstate"
  region = "us-east-1"
}
```

### Passo 4: Configurar Variáveis

Copie o arquivo de exemplo:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edite `terraform.tfvars`:

```hcl
# Identificação
project_name = "meu-projeto"     # ← Altere
environment  = "dev"

# Rede
aws_region = "us-east-1"
vpc_cidr = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]

# Economia: false para dev (economiza $32/mês)
enable_nat_gateway = true

# EKS - Spot economiza 70%!
eks_cluster_version = "1.30"
eks_node_capacity_type = "SPOT"              # SPOT ou ON_DEMAND
eks_node_instance_types = ["t3.micro"]
eks_node_desired_size = 2
eks_node_min_size = 2
eks_node_max_size = 2
eks_node_disk_size = 20

# Tags opcionais
tags = {
  Owner = "seu-nome"
  Curso = "kubernetes-na-pratica"
}
```

### Passo 5: Inicializar Terraform

```bash
# Inicializar (download de providers)
terraform init

# Deve mostrar: "Terraform has been successfully initialized!"
```

### Passo 6: Validar Configuração

```bash
# Validar sintaxe
terraform validate

# Formatar código
terraform fmt -recursive
```

### Passo 7: Ver o Plano

```bash
# Ver o que será criado (não cria nada ainda)
terraform plan

# Você verá: "Plan: 25 to add, 0 to change, 0 to destroy"
```

### Passo 8: Criar Infraestrutura! 🎉

```bash
# Criar tudo
terraform apply

# Digite 'yes' quando solicitado
# Aguarde ~20-25 minutos ☕

# Progresso:
# ✓ VPC e rede (~3 min)
# ✓ EKS Control Plane (~10-12 min)
# ✓ Node Group (~5-7 min)
# ✓ Configurações finais (~2 min)
```

---

## ⚙️ Configurar kubectl

Após a criação, configure o acesso:

```bash
# Obter comando de configuração
terraform output configure_kubectl

# Ou execute diretamente:
aws eks update-kubeconfig --region us-east-1 --name meu-projeto-eks

# Verificar conexão
kubectl get nodes

# Deve mostrar 2 nodes:
# NAME                         STATUS   ROLES    AGE   VERSION
# ip-10-0-10-xx.ec2.internal  Ready    <none>   3m    v1.30.x
# ip-10-0-11-xx.ec2.internal  Ready    <none>   3m    v1.30.x
```

---

## 🧪 Testar o Cluster

### Deploy de Aplicação Simples

```bash
# Deploy do NGINX
kubectl create deployment nginx --image=nginx:latest

# Verificar pod
kubectl get pods

# Expor com Load Balancer
kubectl expose deployment nginx --port=80 --type=LoadBalancer

# Ver serviços (aguarde EXTERNAL-IP aparecer, ~2-3 min)
kubectl get svc nginx --watch

# Testar acesso
curl http://<EXTERNAL-IP>
# Deve retornar: "Welcome to nginx!"
```

### Deploy com Manifesto

```bash
# Criar arquivo deployment.yaml
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

# Aplicar
kubectl apply -f deployment.yaml

# Ver status
kubectl get all

# Testar
curl http://$(kubectl get svc hello-k8s -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
```

---

## 🗑️ Destruir Infraestrutura

**MUITO IMPORTANTE**: Sempre destrua quando terminar!

### Passo 1: Limpar Recursos Kubernetes

```bash
# Deletar deployments
kubectl delete deployment nginx hello-k8s

# Deletar serviços (IMPORTANTE: remove Load Balancers)
kubectl delete svc nginx hello-k8s

# Verificar se Load Balancers foram removidos
kubectl get svc --all-namespaces

# Aguardar 2-3 minutos para AWS processar
```

### Passo 2: Destruir com Terraform

```bash
# Destruir tudo
terraform destroy

# Digite 'yes' quando solicitado
# Aguarde ~10-15 minutos

# Progresso:
# ✓ Node Group (~5 min)
# ✓ EKS Cluster (~5 min)
# ✓ Rede e VPC (~3 min)
```

### Passo 3: Verificar Limpeza

```bash
# Verificar no console AWS ou CLI
aws eks list-clusters --region us-east-1

# Deve retornar vazio: {"clusters": []}

# Verificar VPCs
aws ec2 describe-vpcs --filters "Name=tag:Project,Values=meu-projeto" --region us-east-1

# Deve retornar vazio
```

---

## 💡 Dicas e Truques

### 1. Scripts de Automação

Crie scripts para facilitar:

**`start.sh`:**
```bash
#!/bin/bash
set -e
echo "🚀 Criando cluster EKS..."
terraform apply -auto-approve
echo "⚙️ Configurando kubectl..."
$(terraform output -raw configure_kubectl)
echo "✅ Pronto! Verificando nodes..."
kubectl get nodes
```

**`stop.sh`:**
```bash
#!/bin/bash
set -e
echo "🧹 Limpando recursos Kubernetes..."
kubectl delete deployments --all
kubectl delete services --all-namespaces -l "app"
sleep 60
echo "🗑️ Destruindo infraestrutura..."
terraform destroy -auto-approve
echo "✅ Infraestrutura destruída!"
```

### 2. Economizar Mais

```hcl
# Para estudos sem acesso externo aos nodes:
enable_nat_gateway = false  # Economiza $32/mês

# Usar apenas quando precisar de:
# - Pull de imagens privadas
# - Acesso à internet dos pods
# - Integração com APIs externas
```

### 3. Monitorar Custos

```bash
# Ver custos no AWS CLI
aws ce get-cost-and-usage \
  --time-period Start=2026-01-01,End=2026-01-31 \
  --granularity DAILY \
  --metrics BlendedCost \
  --group-by Type=TAG,Key=Project

# Configurar alerta de custo no console AWS:
# Billing → Budgets → Create budget
# - Tipo: Cost budget
# - Valor: $20/mês
# - Alerta: 80% ($16)
```

### 4. Persistir Dados Entre Destruições

Use S3 para dados importantes:

```bash
# Salvar configs
kubectl get configmaps -o yaml > backup-configs.yaml

# Fazer backup em S3
aws s3 cp backup-configs.yaml s3://seu-bucket/backups/

# Restaurar depois
aws s3 cp s3://seu-bucket/backups/backup-configs.yaml .
kubectl apply -f backup-configs.yaml
```

---

## 📊 Comparativo de Cenários

| Cenário | Horas/mês | Custo | Melhor Para |
|---------|-----------|-------|-------------|
| **24/7 On-Demand** | 730h | $138/mês | Produção |
| **24/7 Spot** | 730h | $127/mês | Staging 24/7 |
| **20h/semana (Destroy)** | 87h | **$15/mês** | **Estudos** ⭐ |
| **10h/semana (Destroy)** | 43h | **$8/mês** | **Estudos** ⭐⭐ |

---

## 🐛 Troubleshooting

### Erro: "Error creating EKS Cluster"

**Causa**: Permissões IAM insuficientes  
**Solução**:
```bash
# Verificar permissões
aws iam get-user

# Adicionar policies necessárias no IAM Console
```

### Erro: "Error creating Node Group"

**Causa**: Limites de Service Quotas  
**Solução**:
```bash
# Ver limites
aws service-quotas list-service-quotas \
  --service-code eks \
  --region us-east-1

# Solicitar aumento no console AWS
```

### kubectl não conecta

```bash
# Reconfigurar
aws eks update-kubeconfig --region us-east-1 --name CLUSTER-NAME --profile default

# Verificar credenciais
aws sts get-caller-identity

# Testar acesso
kubectl cluster-info
```

### Custo maior que esperado

```bash
# Verificar recursos não destruídos
aws resourcegroupstaggingapi get-resources \
  --tag-filters Key=Project,Values=meu-projeto

# Deletar Load Balancers órfãos
aws elb describe-load-balancers --region us-east-1

# Verificar NAT Gateway
aws ec2 describe-nat-gateways --region us-east-1
```

---

## 🎓 Próximos Passos

Agora que você tem um cluster funcionando:

### 1. Kubernetes Básico
- Deployments, Services, ConfigMaps
- Namespaces e Resource Quotas
- Persistent Volumes

### 2. Ferramentas Essenciais
- **Helm**: Gerenciador de pacotes K8s
- **Ingress Controller**: NGINX ou ALB
- **Cert-Manager**: Certificados SSL automáticos

### 3. Observabilidade
- **Prometheus + Grafana**: Métricas
- **ELK Stack**: Logs centralizados
- **Jaeger**: Tracing distribuído

### 4. CI/CD
- **GitHub Actions**: Pipeline automatizado
- **ArgoCD**: GitOps para K8s
- **Flux**: Alternativa ao ArgoCD

### 5. Service Mesh
- **Istio**: Traffic management avançado
- **Linkerd**: Service mesh leve

---

## 📚 Recursos de Aprendizado

### Cursos Gratuitos
- [Kubernetes Basics (Kubernetes.io)](https://kubernetes.io/docs/tutorials/kubernetes-basics/)
- [EKS Workshop](https://www.eksworkshop.com/)
- [Terraform AWS Tutorial](https://learn.hashicorp.com/collections/terraform/aws-get-started)

### Certificações
- **CKA**: Certified Kubernetes Administrator
- **CKAD**: Certified Kubernetes Application Developer
- **AWS Certified Solutions Architect**

### Comunidades
- [Kubernetes Slack](https://slack.k8s.io/)
- [Reddit r/kubernetes](https://reddit.com/r/kubernetes)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/kubernetes)

---

## 🤝 Compartilhe Este Guia

Ajude outros estudantes:

- 👍 LinkedIn: Compartilhe com sua rede
- 🐦 Twitter: Tweet com #Kubernetes #AWS #EKS
- 📝 Blog: Escreva sobre sua experiência
- ⭐ GitHub: Star este repositório

---

## 📞 Suporte

- 🐛 Issues: Abra um issue no GitHub
- 💬 Discussões: Use a aba Discussions
- 📧 Email: [seu-email@example.com]

---

## ✨ Conclusão

Parabéns! 🎉 Você agora sabe:

✅ Provisionar infraestrutura AWS com Terraform  
✅ Criar e gerenciar clusters EKS  
✅ Otimizar custos usando Spot Instances  
✅ Deploy de aplicações em Kubernetes  
✅ Destruir recursos para economizar  

**Custo para estudar Kubernetes**: $8-15/mês (vs $127 24/7)  
**Economia**: 88-94%  
**Conhecimento**: Inestimável 🚀  

---

**Bons estudos e bora codar! 💻**

*Criado com ❤️ para a comunidade de desenvolvedores*
