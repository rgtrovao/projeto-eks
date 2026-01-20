output "public_route_table_id" {
  description = "ID da tabela de roteamento pública"
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "IDs das tabelas de roteamento privadas"
  value       = aws_route_table.private[*].id
}

output "database_route_table_ids" {
  description = "IDs das tabelas de roteamento de banco de dados"
  value       = aws_route_table.database[*].id
}
