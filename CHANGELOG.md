# 📝 Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto adere ao [Versionamento Semântico](https://semver.org/lang/pt-BR/).

## [2.0.0] - 2026-01-20

### 🎉 Versão Otimizada - Economia de até 94%

Esta versão representa uma refatoração completa do projeto com foco em:
- Economia de custos (Spot Instances)
- Modularidade (consolidação de módulos)
- Documentação (guias práticos)

### ✨ Adicionado

- **Spot Instances por padrão**: Economia de 70% nos custos de compute
- **Módulo network consolidado**: VPC + IGW + NAT + Route Tables em um único módulo
- **Documentação completa**:
  - `HOWTO.md`: Guia passo a passo detalhado
  - `CUSTOS.md`: Análise completa de custos por cenário
  - `.gitignore`: Proteção de arquivos sensíveis
- **Variável `capacity_type`**: Permite alternar entre SPOT e ON_DEMAND facilmente
- **Tags EKS nas subnets**: `kubernetes.io/cluster/*` para descoberta automática
- **Validação de variáveis**: `capacity_type` valida apenas SPOT ou ON_DEMAND
- **Lifecycle rules**: Node group ignora mudanças no `desired_size`

### 🔄 Modificado

- **Estrutura de módulos**: 5 módulos → 2 módulos (network + eks)
- **NAT Gateway**: 3 NAT Gateways (1 por AZ) → 1 NAT Gateway (economia de $64/mês)
- **CIDRs dinâmicos**: Uso de `cidrsubnet()` em vez de listas hardcoded
- **Security Group do EKS**: Egress restrito ao CIDR da VPC (antes: 0.0.0.0/0)
- **Versão do Kubernetes**: 1.28 → 1.30
- **README.md**: Completamente reescrito com foco em quick start
- **Variables**: Organizadas e documentadas
- **Outputs**: Simplificados e mais úteis

### 🗑️ Removido

- **Subnets de database**: Removidas (não eram utilizadas)
- **Módulos separados**:
  - `modules/vpc` → consolidado em `modules/network`
  - `modules/internet_gateway` → consolidado em `modules/network`
  - `modules/subnets` → consolidado em `modules/network`
  - `modules/route_tables` → consolidado em `modules/network`
- **Tags redundantes**: `Type` e `Tier` (mantidas apenas tags essenciais)
- **Arquivos de output não versionados**: `output/` adicionado ao `.gitignore`
- **Variáveis não utilizadas**: Limpeza de variáveis obsoletas

### 🐛 Corrigido

- **Conflitos de merge** no `variables.tf` e `README.md`
- **Dependências de recursos**: NAT Gateway agora depende explicitamente do IGW
- **IAM Role names**: Adição de sufixos `-cluster-role` e `-node-role` para clareza

### 💰 Impacto nos Custos

| Configuração | Antes | Depois | Economia |
|--------------|-------|--------|----------|
| **NAT Gateway** | 3x $32 = $96/mês | 1x $32 = $32/mês | $64/mês |
| **Compute (24/7)** | ON_DEMAND $15.18 | SPOT $3.65 | $11.53/mês |
| **Total (24/7)** | ~$181/mês | ~$127/mês | $54/mês (30%) |
| **Uso 20h/sem** | - | ~$15.37/mês | $111/mês (88%) |
| **Uso 10h/sem** | - | ~$8.08/mês | $119/mês (94%) |

### 📊 Estatísticas do Projeto

- **Linhas de código**: ~40% redução no `main.tf`
- **Arquivos de módulo**: 15 → 6 (60% redução)
- **Recursos AWS**: 25 recursos provisionados
- **Tempo de deploy**: ~20-25 minutos
- **Tempo de destroy**: ~10-15 minutos

---

## [1.0.0] - 2026-01-15

### ✨ Versão Inicial

- Provisiona VPC completa com 3 AZs
- Subnets públicas, privadas e de database
- Internet Gateway e 3 NAT Gateways
- Cluster EKS com Kubernetes 1.28
- Node Group com instâncias On-Demand
- Módulos separados para cada componente

---

## 🔮 Roadmap Futuro

### [2.1.0] - Planejado

- [ ] Suporte a múltiplos node groups (mix Spot + On-Demand)
- [ ] Add-ons EKS gerenciados (VPC CNI, CoreDNS, kube-proxy)
- [ ] Configuração de Cluster Autoscaler
- [ ] Integração com AWS Load Balancer Controller
- [ ] Exemplos de aplicações (manifests K8s)

### [2.2.0] - Planejado

- [ ] Módulo de observabilidade (Prometheus + Grafana)
- [ ] CI/CD com GitHub Actions
- [ ] Testes automatizados (Terratest)
- [ ] Suporte a EKS on Fargate
- [ ] Política de Pod Security Standards

### [3.0.0] - Futuro

- [ ] Multi-região (DR e HA)
- [ ] Service Mesh (Istio ou Linkerd)
- [ ] GitOps com ArgoCD
- [ ] Secrets management (AWS Secrets Manager)
- [ ] Cost optimization dashboard

---

## 📝 Como Contribuir

Encontrou um bug? Tem uma sugestão? Abra uma issue ou PR!

1. Fork o projeto
2. Crie uma branch (`git checkout -b feature/melhoria`)
3. Commit suas mudanças (`git commit -m 'feat: adiciona xyz'`)
4. Push para a branch (`git push origin feature/melhoria`)
5. Abra um Pull Request

---

## 🏷️ Versionamento

Este projeto usa [Versionamento Semântico](https://semver.org/):

- **MAJOR** (X.0.0): Mudanças incompatíveis (breaking changes)
- **MINOR** (0.X.0): Novas funcionalidades (backwards compatible)
- **PATCH** (0.0.X): Correções de bugs

---

## 📞 Suporte

- 🐛 **Bugs**: Abra uma issue no GitHub
- 💡 **Sugestões**: Use a aba Discussions
- 📧 **Contato**: [seu-email@example.com]

---

**Mantido com ❤️ pela comunidade**
