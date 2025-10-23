# modules/vpc/outputs.tf

output "vpc_id" {
  description = "El ID de la VPC creada."
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "El bloque CIDR de la VPC."
  value       = aws_vpc.this.cidr_block
}

output "default_route_table_id" {
  description = "El ID de la Tabla de Enrutamiento por defecto/principal de la VPC."
  value       = data.aws_route_table.default.id
}