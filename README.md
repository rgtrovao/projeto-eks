# Projeto Terraform - Infraestrutura AWS EKS

Este projeto provisiona uma infraestrutura completa na AWS seguindo as melhores práticas, incluindo VPC, Subnets (públicas, privadas e de banco de dados), Internet Gateway, NAT Gateways e tabelas de roteamento.

## 📋 Estrutura do Projeto

```
Terraform-EKS/
├── main.tf                    # Configuração principal e módulos
├── variables.tf               # Variáveis do projeto
├── outputs.tf                 # Outputs do projeto
├── terraform.tfvars.example   # Exemplo de variáveis
├── .gitignore                # Arquivos ignorados pelo Git
├── README.md                  # Documentação
└── modules/
    ├── vpc/                   # Módulo VPC
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── internet_gateway/      # Módulo Internet Gateway
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── subnets/               # Módulo Subnets
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── route_tables/          # Módulo Route Tables
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## 🏗️ Arquitetura

O projeto cria a seguinte infraestrutura:

- **VPC**: Rede virtual isolada
- **Subnets Públicas**: Para recursos que precisam de acesso à internet (Load Balancers, NAT Gateways)
- **Subnets Privadas**: Para recursos de aplicação que precisam de acesso à internet via NAT Gateway
- **Subnets de Banco de Dados**: Para bancos de dados, sem acesso direto à internet
- **Internet Gateway**: Conecta a VPC à internet
- **NAT Gateways**: Permite que recursos em subnets privadas acessem a internet
- **Route Tables**: Configuram o roteamento de tráfego entre subnets

## 🚀 Pré-requisitos

- Terraform >= 1.0
- AWS CLI configurado com credenciais válidas
- Permissões adequadas na AWS para criar recursos de rede
- Bucket S3 `rgtrovao-terraform-bucket` criado na região `us-east-1` para armazenar o estado do Terraform

## 📦 Instalação

1. Clone o repositório:
```bash
cd /Users/raphaeltrovao/Downloads/Terraform-EKS
```

2. Copie o arquivo de exemplo de variáveis:
```bash
cp terraform.tfvars.example terraform.tfvars
```

3. Edite o arquivo `terraform.tfvars` com suas configurações:
```hcl
aws_region   = "us-east-1"
project_name = "rgtrovao-project"
environment  = "dev"
vpc_name     = "rgtrovao-vpc"
vpc_cidr     = "10.0.0.0/16"
```

## 🔧 Uso

### Backend S3

O projeto está configurado para armazenar o estado do Terraform no bucket S3 `rgtrovao-terraform-bucket`. Certifique-se de que:

1. O bucket S3 existe na região `us-east-1`
2. Você tem permissões para ler/escrever no bucket
3. O versionamento está habilitado (recomendado para segurança)

### Inicializar o Terraform

```bash
terraform init
```

**Nota**: Na primeira inicialização, o Terraform pode solicitar confirmação para migrar o estado local para o backend S3. Digite `yes` para confirmar.

### Validar a configuração

```bash
terraform validate
```

### Visualizar o plano de execução

```bash
terraform plan
```

### Aplicar as mudanças

```bash
terraform apply
```

### Destruir a infraestrutura

```bash
terraform destroy
```

## 📝 Variáveis Principais

| Variável | Descrição | Padrão |
|----------|-----------|--------|
| `aws_region` | Região AWS | `us-east-1` |
| `project_name` | Nome do projeto | `rgtrovao-project` |
| `environment` | Ambiente (dev/staging/prod) | `dev` |
| `vpc_name` | Nome da VPC | `rgtrovao-vpc` |
| `vpc_cidr` | CIDR block da VPC | `10.0.0.0/16` |
| `availability_zones` | Lista de AZs | `["us-east-1a", "us-east-1b", "us-east-1c"]` |
| `public_subnet_cidrs` | CIDRs das subnets públicas | `["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]` |
| `private_subnet_cidrs` | CIDRs das subnets privadas | `["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]` |
| `database_subnet_cidrs` | CIDRs das subnets de BD | `["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]` |
| `enable_nat_gateway` | Habilitar NAT Gateway | `true` |
<<<<<<< HEAD
<<<<<<< HEAD
| `eks_cluster_version` | Versão do Kubernetes no EKS | `"1.30"` |
| `eks_node_desired_size` | Número desejado de nós no node group | `2` |
| `eks_node_min_size` | Número mínimo de nós no node group | `2` |
| `eks_node_max_size` | Número máximo de nós no node group | `3` |
| `eks_node_instance_types` | Tipos de instância dos nós EKS | `["t3.micro"]` |
| `eks_node_disk_size` | Tamanho do disco dos nós EKS (GB) | `20` |
| `enable_vpc_cni_addon` | Habilitar add-on VPC CNI gerenciado | `true` |
| `enable_coredns_addon` | Habilitar add-on CoreDNS gerenciado | `true` |
| `enable_kube_proxy_addon` | Habilitar add-on kube-proxy gerenciado | `true` |
=======
>>>>>>> parent of e1972b4 (Inclusão do módulo de EKS)
=======
>>>>>>> parent of e1972b4 (Inclusão do módulo de EKS)

## 📤 Outputs

O projeto gera os seguintes outputs:

- `vpc_id`: ID da VPC criada
- `vpc_cidr_block`: CIDR block da VPC
- `internet_gateway_id`: ID do Internet Gateway
- `public_subnet_ids`: IDs das subnets públicas
- `private_subnet_ids`: IDs das subnets privadas
- `database_subnet_ids`: IDs das subnets de banco de dados
- `public_route_table_id`: ID da route table pública
- `private_route_table_ids`: IDs das route tables privadas
- `database_route_table_ids`: IDs das route tables de banco de dados
- `nat_gateway_ids`: IDs dos NAT Gateways
<<<<<<< HEAD
<<<<<<< HEAD
- `eks_cluster_name`: Nome do cluster EKS
- `eks_cluster_endpoint`: Endpoint da API do cluster EKS
- `eks_cluster_ca_certificate`: Certificado CA (base64) do cluster EKS
- `eks_node_group_name`: Nome do node group EKS
- `eks_configure_kubectl`: Comando para configurar o kubectl
- `eks_test_connection`: Comando para testar a conexão com o cluster
- `vpc_cni_addon_arn`: ARN do add-on VPC CNI (se habilitado)
- `coredns_addon_arn`: ARN do add-on CoreDNS (se habilitado)
- `kube_proxy_addon_arn`: ARN do add-on kube-proxy (se habilitado)
=======
>>>>>>> parent of e1972b4 (Inclusão do módulo de EKS)
=======
>>>>>>> parent of e1972b4 (Inclusão do módulo de EKS)

## 🏷️ Nomenclatura

O projeto segue uma nomenclatura intuitiva e consistente:

- **VPC**: `{vpc_name}`
- **Internet Gateway**: `{vpc_name}-igw`
- **Subnets Públicas**: `{vpc_name}-public-subnet-{número}`
- **Subnets Privadas**: `{vpc_name}-private-subnet-{número}`
- **Subnets de BD**: `{vpc_name}-database-subnet-{número}`
- **NAT Gateways**: `{vpc_name}-nat-gateway-{número}`
- **Route Tables**: `{vpc_name}-{tipo}-rt-{número}`

## 🔒 Boas Práticas Implementadas

1. **Modularidade**: Código organizado em módulos reutilizáveis
2. **Separação de Concerns**: Cada módulo tem responsabilidade única
3. **Nomenclatura Consistente**: Nomes descritivos e padronizados
4. **Tags Padronizadas**: Tags consistentes em todos os recursos
5. **Alta Disponibilidade**: Recursos distribuídos em múltiplas AZs
6. **Segurança**: Subnets de banco de dados sem acesso à internet
7. **Documentação**: Código e README bem documentados

## 🔐 Segurança

- Subnets de banco de dados não têm rota para internet
- NAT Gateways permitem acesso à internet apenas para subnets privadas
- DNS habilitado para resolução de nomes dentro da VPC
- Tags de segurança aplicadas a todos os recursos

## 💰 Custos

**Importante**: NAT Gateways têm custo associado. Para ambientes de desenvolvimento, considere desabilitar usando:

```hcl
enable_nat_gateway = false
```

## 📚 Módulos

### Módulo VPC
Cria a VPC com configurações de DNS.

### Módulo Internet Gateway
Cria e anexa o Internet Gateway à VPC.

### Módulo Subnets
Cria subnets públicas, privadas e de banco de dados, além de NAT Gateways quando habilitados.

### Módulo Route Tables
Configura as tabelas de roteamento para cada tipo de subnet.

<<<<<<< HEAD
<<<<<<< HEAD
### Módulo EKS
Cria o cluster EKS e um node group gerenciado com nós `t3.micro` em subnets privadas, seguindo boas práticas (IAM Roles dedicadas, security groups separados para control plane e nós, e auto-scaling configurável).

**Add-ons Essenciais Gerenciados:**
- **VPC CNI**: Plugin de rede para conectar pods à VPC
- **CoreDNS**: Servidor DNS para resolução de nomes dentro do cluster
- **kube-proxy**: Componente de rede para gerenciar Services do Kubernetes

Todos os add-ons são gerenciados pela AWS, facilitando atualizações e manutenção.

=======
>>>>>>> parent of e1972b4 (Inclusão do módulo de EKS)
=======
>>>>>>> parent of e1972b4 (Inclusão do módulo de EKS)
## 🐛 Troubleshooting

### Erro: "InvalidParameterValue"
Verifique se os CIDR blocks não se sobrepõem e estão dentro do range da VPC.

### Erro: "InsufficientAddressesInSubnet"
Aumente o tamanho do CIDR block ou reduza o número de subnets.

### NAT Gateway não está funcionando
Verifique se o NAT Gateway está na subnet pública e se a route table privada está configurada corretamente.

### Add-ons EKS não estão instalando
Os add-ons são instalados após a criação do cluster e node group. Se houver problemas:
1. Verifique se o cluster está no estado `ACTIVE`
2. Verifique se o node group está no estado `ACTIVE`
3. Para CoreDNS, aguarde a criação do node group primeiro
4. Verifique os logs do CloudWatch para mais detalhes

## 📄 Licença

Este projeto está sob a licença MIT.

## 👥 Contribuindo

Contribuições são bem-vindas! Por favor, abra uma issue ou pull request.

## 📞 Suporte

Para questões ou problemas, abra uma issue no repositório.
# projeto-eks
