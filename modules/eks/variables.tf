variable "cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
}

variable "cluster_version" {
  description = "Versão do Kubernetes"
  type        = string
  default     = "1.30"
}

variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "IDs das subnets privadas para os nodes"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "IDs das subnets públicas para o control plane"
  type        = list(string)
}

variable "node_group_name" {
  description = "Nome do node group"
  type        = string
}

variable "desired_size" {
  description = "Número desejado de nodes"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Número mínimo de nodes"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Número máximo de nodes"
  type        = number
  default     = 2
}

variable "instance_types" {
  description = "Tipos de instância para os nodes"
  type        = list(string)
  default     = ["t3.micro"]
}

variable "disk_size" {
  description = "Tamanho do disco em GB"
  type        = number
  default     = 20
}

variable "capacity_type" {
  description = "Tipo de capacidade (ON_DEMAND ou SPOT)"
  type        = string
  default     = "SPOT"
  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.capacity_type)
    error_message = "capacity_type deve ser ON_DEMAND ou SPOT"
  }
}

variable "tags" {
  description = "Tags para aplicar aos recursos"
  type        = map(string)
  default     = {}
}
