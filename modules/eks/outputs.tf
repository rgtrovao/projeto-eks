output "cluster_name" {
  description = "Nome do cluster EKS"
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "Endpoint da API do cluster EKS"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_ca_certificate" {
  description = "Certificado CA do cluster EKS (base64)"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_security_group_id" {
  description = "ID do security group do cluster EKS"
  value       = aws_security_group.cluster.id
}

output "node_group_name" {
  description = "Nome do node group EKS"
  value       = aws_eks_node_group.this.node_group_name
}

output "node_role_arn" {
  description = "ARN da IAM Role dos nós do EKS"
  value       = aws_iam_role.node_group.arn
}

