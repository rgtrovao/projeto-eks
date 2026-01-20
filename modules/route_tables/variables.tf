variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "vpc_name" {
  description = "Nome da VPC (para nomenclatura)"
  type        = string
  default     = "vpc"
}

variable "internet_gateway_id" {
  description = "ID do Internet Gateway"
  type        = string
}

variable "public_subnet_ids" {
  description = "IDs das subnets públicas"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "IDs das subnets privadas"
  type        = list(string)
}

variable "database_subnet_ids" {
  description = "IDs das subnets de banco de dados"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Habilitar NAT Gateway para subnets privadas"
  type        = bool
  default     = true
}

variable "nat_gateway_ids" {
  description = "IDs dos NAT Gateways"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags para os recursos"
  type        = map(string)
  default     = {}
}
