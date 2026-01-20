output "internet_gateway_id" {
  description = "ID do Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "internet_gateway_arn" {
  description = "ARN do Internet Gateway"
  value       = aws_internet_gateway.main.arn
}
