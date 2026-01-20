variable "cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
}

variable "cluster_version" {
  description = "Versão do Kubernetes para o cluster EKS"
  type        = string
  default     = "1.30"
}

variable "vpc_id" {
  description = "ID da VPC onde o EKS será criado"
  type        = string
}

variable "private_subnet_ids" {
  description = "IDs das subnets privadas usadas pelos nós do EKS"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "IDs das subnets públicas (para load balancers)"
  type        = list(string)
}

variable "node_group_name" {
  description = "Nome do node group padrão"
  type        = string
}

variable "desired_size" {
  description = "Número desejado de nós no node group"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Número mínimo de nós no node group"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Número máximo de nós no node group"
  type        = number
  default     = 3
}

variable "instance_types" {
  description = "Lista de tipos de instância para os nós do EKS"
  type        = list(string)
  default     = ["t3.micro"]
}

variable "node_disk_size" {
  description = "Tamanho do disco em GB para cada nó do EKS"
  type        = number
  default     = 20
}

variable "tags" {
  description = "Tags adicionais para os recursos do EKS"
  type        = map(string)
  default     = {}
}

