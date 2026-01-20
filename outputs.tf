# Network Outputs
output "vpc_id" {
  description = "ID da VPC"
  value       = module.network.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR block da VPC"
  value       = module.network.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "IDs das subnets públicas"
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs das subnets privadas"
  value       = module.network.private_subnet_ids
}

output "nat_gateway_ip" {
  description = "IP público do NAT Gateway"
  value       = module.network.nat_gateway_public_ip
}

# EKS Outputs
output "eks_cluster_name" {
  description = "Nome do cluster EKS"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint do cluster EKS"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_version" {
  description = "Versão do Kubernetes"
  value       = module.eks.cluster_version
}

output "eks_configure_kubectl" {
  description = "Comando para configurar kubectl"
  value       = module.eks.configure_kubectl
}

output "eks_node_group_status" {
  description = "Status do node group"
  value       = module.eks.node_group_status
}
