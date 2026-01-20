variable "aws_region" {
  description = "Região AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "rgtrovao-project"
}

variable "environment" {
  description = "Ambiente de deploy (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_name" {
  description = "Nome da VPC"
  type        = string
  default     = "rgtrovao-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block para a VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Lista de Availability Zones a serem utilizadas"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks para as subnets públicas"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks para as subnets privadas"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

variable "database_subnet_cidrs" {
  description = "CIDR blocks para as subnets de banco de dados"
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
}

variable "enable_dns_hostnames" {
  description = "Habilitar DNS hostnames na VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Habilitar suporte DNS na VPC"
  type        = bool
  default     = true
}

variable "enable_nat_gateway" {
  description = "Habilitar NAT Gateway para subnets privadas"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags adicionais para os recursos"
  type        = map(string)
  default     = {}
}
<<<<<<< HEAD
<<<<<<< HEAD

variable "eks_cluster_version" {
  description = "Versão do Kubernetes para o cluster EKS"
  type        = string
  default     = "1.30"
}

variable "eks_node_desired_size" {
  description = "Número desejado de nós no node group EKS"
  type        = number
  default     = 2
}

variable "eks_node_min_size" {
  description = "Número mínimo de nós no node group EKS"
  type        = number
  default     = 2
}

variable "eks_node_max_size" {
  description = "Número máximo de nós no node group EKS"
  type        = number
  default     = 3
}

variable "eks_node_instance_types" {
  description = "Tipos de instância para os nós do EKS"
  type        = list(string)
  default     = ["t3.micro"]
}

variable "eks_node_disk_size" {
  description = "Tamanho do disco em GB para os nós do EKS"
  type        = number
  default     = 20
}

variable "enable_vpc_cni_addon" {
  description = "Habilitar add-on VPC CNI gerenciado pela AWS"
  type        = bool
  default     = true
}

variable "enable_coredns_addon" {
  description = "Habilitar add-on CoreDNS gerenciado pela AWS"
  type        = bool
  default     = true
}

variable "enable_kube_proxy_addon" {
  description = "Habilitar add-on kube-proxy gerenciado pela AWS"
  type        = bool
  default     = true
}
=======
>>>>>>> parent of e1972b4 (Inclusão do módulo de EKS)
=======
>>>>>>> parent of e1972b4 (Inclusão do módulo de EKS)
