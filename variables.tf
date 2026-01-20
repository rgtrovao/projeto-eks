variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "rgtrovao-project"
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block da VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "enable_nat_gateway" {
  description = "Habilitar NAT Gateway (recomendado para produção)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags adicionais"
  type        = map(string)
  default     = {}
}

# Variáveis EKS
variable "eks_cluster_version" {
  description = "Versão do Kubernetes"
  type        = string
  default     = "1.30"
}

variable "eks_node_desired_size" {
  description = "Número desejado de nodes"
  type        = number
  default     = 2
}

variable "eks_node_min_size" {
  description = "Número mínimo de nodes"
  type        = number
  default     = 2
}

variable "eks_node_max_size" {
  description = "Número máximo de nodes"
  type        = number
  default     = 2
}

variable "eks_node_instance_types" {
  description = "Tipos de instância dos nodes"
  type        = list(string)
  default     = ["t3.micro"]
}

variable "eks_node_disk_size" {
  description = "Tamanho do disco dos nodes (GB)"
  type        = number
  default     = 20
}

variable "eks_node_capacity_type" {
  description = "Tipo de capacidade dos nodes (ON_DEMAND ou SPOT)"
  type        = string
  default     = "SPOT"
}
