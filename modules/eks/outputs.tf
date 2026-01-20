output "cluster_id" {
  description = "ID do cluster EKS"
  value       = aws_eks_cluster.main.id
}

output "cluster_name" {
  description = "Nome do cluster EKS"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "Endpoint do cluster EKS"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_version" {
  description = "Versão do Kubernetes"
  value       = aws_eks_cluster.main.version
}

output "cluster_certificate_authority_data" {
  description = "Certificado CA do cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
  sensitive   = true
}

output "cluster_security_group_id" {
  description = "ID do security group do cluster"
  value       = aws_security_group.cluster.id
}

output "node_group_id" {
  description = "ID do node group"
  value       = aws_eks_node_group.main.id
}

output "node_group_status" {
  description = "Status do node group"
  value       = aws_eks_node_group.main.status
}

output "node_role_arn" {
  description = "ARN da IAM role dos nodes"
  value       = aws_iam_role.node.arn
}

output "configure_kubectl" {
  description = "Comando para configurar kubectl"
  value       = "aws eks update-kubeconfig --region $(aws configure get region) --name ${aws_eks_cluster.main.name}"
}
