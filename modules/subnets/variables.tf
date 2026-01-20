variable "vpc_id" {
  description = "ID da VPC onde as subnets serão criadas"
  type        = string
}

variable "vpc_name" {
  description = "Nome da VPC (para nomenclatura)"
  type        = string
  default     = "vpc"
}

variable "availability_zones" {
  description = "Lista de Availability Zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Lista de CIDR blocks para subnets públicas"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Lista de CIDR blocks para subnets privadas"
  type        = list(string)
}

variable "database_subnet_cidrs" {
  description = "Lista de CIDR blocks para subnets de banco de dados"
  type        = list(string)
}

variable "internet_gateway_id" {
  description = "ID do Internet Gateway (para dependência dos NAT Gateways)"
  type        = string
}

variable "enable_nat_gateway" {
  description = "Habilitar criação de NAT Gateways"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags para os recursos"
  type        = map(string)
  default     = {}
}
