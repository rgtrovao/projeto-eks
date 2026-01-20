variable "vpc_id" {
  description = "ID da VPC onde o Internet Gateway será anexado"
  type        = string
}

variable "vpc_name" {
  description = "Nome da VPC (para nomenclatura)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags para os recursos"
  type        = map(string)
  default     = {}
}
