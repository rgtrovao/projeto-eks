output "vpc_id" {
  description = "ID da VPC criada"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR block da VPC"
  value       = module.vpc.vpc_cidr_block
}

output "internet_gateway_id" {
  description = "ID do Internet Gateway"
  value       = module.internet_gateway.internet_gateway_id
}

output "public_subnet_ids" {
  description = "IDs das subnets públicas"
  value       = module.subnets.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs das subnets privadas"
  value       = module.subnets.private_subnet_ids
}

output "database_subnet_ids" {
  description = "IDs das subnets de banco de dados"
  value       = module.subnets.database_subnet_ids
}

output "public_route_table_id" {
  description = "ID da tabela de roteamento pública"
  value       = module.route_tables.public_route_table_id
}

output "private_route_table_ids" {
  description = "IDs das tabelas de roteamento privadas"
  value       = module.route_tables.private_route_table_ids
}

output "database_route_table_ids" {
  description = "IDs das tabelas de roteamento de banco de dados"
  value       = module.route_tables.database_route_table_ids
}

output "nat_gateway_ids" {
  description = "IDs dos NAT Gateways (se habilitados)"
  value       = var.enable_nat_gateway ? module.subnets.nat_gateway_ids : []
}
