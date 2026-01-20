# 💰 Análise Detalhada de Custos - Projeto EKS

> Última atualização: Janeiro 2026  
> Região: us-east-1 (N. Virginia)

## 📊 Resumo Executivo

### Com Spot Instances (Configuração Atual)
- **Custo Total**: ~$115.60/mês (~$1,387/ano)
- **Economia vs On-Demand**: $8.40/mês ($100.80/ano)
- **Economia Percentual**: 7% no total

### Sem NAT Gateway + Spot (Dev)
- **Custo Total**: ~$78.60/mês (~$943/ano)
- **Economia vs Produção**: $45.40/mês ($544.80/ano)
- **Economia Percentual**: 36%

---

## 🔍 Detalhamento por Recurso

### 1️⃣ Rede (Network)

| Recurso | Quantidade | Custo Unitário | Total/mês | Observações |
|---------|------------|----------------|-----------|-------------|
| **VPC** | 1 | $0 | $0 | Grátis |
| **Subnets** | 4 | $0 | $0 | Grátis |
| **Internet Gateway** | 1 | $0 | $0 | Grátis |
| **Route Tables** | 2 | $0 | $0 | Grátis |
| **NAT Gateway** | 1 | $0.045/hora | **$32.85** | 730 horas/mês |
| **NAT Data Processing** | ~100GB | $0.045/GB | **$4.50** | Variável |
| **Elastic IP** | 1 | $0 | $0 | Grátis (em uso) |
| **Subtotal Rede** | | | **$37.35** | |

💡 **Dica de Economia**: Desabilitar NAT em dev economiza $37.35/mês

---

### 2️⃣ EKS Cluster

| Recurso | Quantidade | Custo Unitário | Total/mês | Observações |
|---------|------------|----------------|-----------|-------------|
| **EKS Control Plane** | 1 | $0.10/hora | **$73.00** | Fixo (730 horas/mês) |
| **Subtotal EKS** | | | **$73.00** | Custo fixo independente do uso |

---

### 3️⃣ Worker Nodes (Compute)

#### Opção A: Spot Instances (Padrão ✅)

| Recurso | Quantidade | Custo Unitário | Total/mês | Economia |
|---------|------------|----------------|-----------|----------|
| **t3.micro Spot** | 2 | $0.0025/hora | **$3.65** | 70% |
| **EBS gp3 (20GB)** | 2 | $0.08/GB-mês | **$3.20** | - |
| **Subtotal Nodes (Spot)** | | | **$6.85** | -$11.35 |

#### Opção B: On-Demand

| Recurso | Quantidade | Custo Unitário | Total/mês | Economia |
|---------|------------|----------------|-----------|----------|
| **t3.micro On-Demand** | 2 | $0.0104/hora | **$15.18** | 0% |
| **EBS gp3 (20GB)** | 2 | $0.08/GB-mês | **$3.20** | - |
| **Subtotal Nodes (On-Demand)** | | | **$18.38** | - |

💡 **Economia com Spot**: $11.53/mês por node group

---

### 4️⃣ Data Transfer

| Tipo | Estimativa | Custo Unitário | Total/mês | Observações |
|------|------------|----------------|-----------|-------------|
| **Internet Ingress** | Ilimitado | $0 | $0 | Grátis |
| **Internet Egress** | 100GB | $0.09/GB | **$9.00** | Primeiros 10TB |
| **Inter-AZ** | 50GB | $0.01/GB | **$0.50** | Entre AZs |
| **Subtotal Transfer** | | | **$9.50** | Variável |

---

## 📈 Cenários de Custo

### Cenário 1: Desenvolvimento (Recomendado)
**Configuração**: Sem NAT + Spot Instances

```hcl
enable_nat_gateway = false
eks_node_capacity_type = "SPOT"
eks_node_instance_types = ["t3.micro"]
eks_node_desired_size = 2
```

| Item | Custo |
|------|-------|
| EKS Cluster | $73.00 |
| 2x t3.micro Spot | $3.65 |
| EBS (40GB) | $3.20 |
| Data Transfer | $5.00 |
| **Total** | **$84.85/mês** |

✅ **Melhor para**: Dev, testes, ambientes efêmeros  
💰 **Economia anual**: $496.80 vs Produção

---

### Cenário 2: Staging (Balanceado)
**Configuração**: NAT + Spot Instances

```hcl
enable_nat_gateway = true
eks_node_capacity_type = "SPOT"
eks_node_instance_types = ["t3.micro"]
eks_node_desired_size = 2
```

| Item | Custo |
|------|-------|
| Rede (NAT) | $37.35 |
| EKS Cluster | $73.00 |
| 2x t3.micro Spot | $3.65 |
| EBS (40GB) | $3.20 |
| Data Transfer | $9.50 |
| **Total** | **$126.70/mês** |

✅ **Melhor para**: Staging, pré-produção  
💰 **Economia**: 50% vs mesma config On-Demand

---

### Cenário 3: Produção (Estável)
**Configuração**: NAT + On-Demand + Mais Nodes

```hcl
enable_nat_gateway = true
eks_node_capacity_type = "ON_DEMAND"
eks_node_instance_types = ["t3.small"]
eks_node_desired_size = 3
```

| Item | Custo |
|------|-------|
| Rede (NAT) | $37.35 |
| EKS Cluster | $73.00 |
| 3x t3.small On-Demand | $45.99 |
| EBS (60GB) | $4.80 |
| Data Transfer | $15.00 |
| **Total** | **$176.14/mês** |

✅ **Melhor para**: Produção, workloads críticos  
⚠️ **Trade-off**: +$49.44/mês para 99.9% de disponibilidade

---

### Cenário 4: Produção Otimizada (Mix)
**Configuração**: NAT + 70% Spot + 30% On-Demand

```hcl
# Usar Cluster Autoscaler com prioridades
enable_nat_gateway = true
# Node group 1 (Spot): 70% da capacidade
# Node group 2 (On-Demand): 30% backup
```

| Item | Custo |
|------|-------|
| Rede (NAT) | $37.35 |
| EKS Cluster | $73.00 |
| 2x t3.small Spot | $10.95 |
| 1x t3.small On-Demand | $15.33 |
| EBS (60GB) | $4.80 |
| Data Transfer | $15.00 |
| **Total** | **$156.43/mês** |

✅ **Melhor para**: Produção cost-optimized  
💰 **Economia**: $19.71/mês vs Produção pura On-Demand

---

## 🎯 Recomendações por Ambiente

### 🟢 Desenvolvimento
```
Configuração: Cenário 1
Custo: $84.85/mês
ROI: Máximo
```

### 🟡 Staging/QA
```
Configuração: Cenário 2
Custo: $126.70/mês
ROI: Alto
```

### 🔴 Produção (Crítico)
```
Configuração: Cenário 3
Custo: $176.14/mês
ROI: Estabilidade
```

### 🟣 Produção (Otimizado)
```
Configuração: Cenário 4
Custo: $156.43/mês
ROI: Balanceado
```

---

## 💡 Estratégias de Otimização

### 1. Desabilitar NAT em Dev
**Economia**: $37.35/mês  
**Como**: `enable_nat_gateway = false`  
**Impacto**: Nodes não podem acessar internet (usar VPN/Bastion se necessário)

### 2. Usar Spot Instances
**Economia**: 50-70% nos nodes  
**Como**: `eks_node_capacity_type = "SPOT"`  
**Impacto**: Possível interrupção (2 min aviso)

### 3. Right-sizing de Instâncias
**Economia**: 30-50%  
**Como**: Monitorar uso e ajustar instance types  
**Ferramentas**: CloudWatch, Kubecost, AWS Compute Optimizer

### 4. EBS Optimization
**Economia**: $1-2/node  
**Como**: 
- Usar gp3 em vez de gp2 (mesmo custo, melhor performance)
- Ajustar tamanho do disco (default: 20GB)
- Considerar snapshot lifecycle

### 5. Reserved Instances (Longo Prazo)
**Economia**: 30-40% vs On-Demand  
**Como**: Comprar 1 ou 3 anos de commitment  
**Melhor para**: Produção estável

### 6. Savings Plans
**Economia**: 20-30%  
**Como**: Comprometer uso de compute por 1-3 anos  
**Flexibilidade**: Pode mudar instance types

---

## 📊 Comparativo de Custos Anuais

| Cenário | Mensal | Anual | vs Dev | vs Prod |
|---------|--------|-------|--------|---------|
| **Dev (Sem NAT + Spot)** | $84.85 | $1,018 | - | -54% |
| **Staging (NAT + Spot)** | $126.70 | $1,520 | +49% | -28% |
| **Prod (NAT + On-Demand)** | $176.14 | $2,114 | +108% | - |
| **Prod Mix (70/30)** | $156.43 | $1,877 | +84% | -11% |

---

## 🔄 Ciclo de Otimização

### Mês 1: Setup
- Usar Spot em Dev/Staging
- Monitorar taxa de interrupção
- Coletar métricas de uso

### Mês 2-3: Análise
- Revisar custos no Cost Explorer
- Identificar recursos subutilizados
- Ajustar node groups

### Mês 4+: Otimização Contínua
- Implementar auto-scaling baseado em métricas
- Considerar Reserved Instances
- Avaliar migração para ARM (Graviton) - 20% mais barato

---

## 🎓 Referências

- [AWS EKS Pricing](https://aws.amazon.com/eks/pricing/)
- [EC2 Spot Instances](https://aws.amazon.com/ec2/spot/pricing/)
- [AWS Pricing Calculator](https://calculator.aws/)
- [EKS Best Practices - Cost Optimization](https://aws.github.io/aws-eks-best-practices/cost_optimization/)

---

## 📞 Suporte

Para questões sobre custos ou otimizações, consulte:
- AWS Cost Explorer
- AWS Trusted Advisor
- AWS Compute Optimizer
