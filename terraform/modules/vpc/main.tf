# modules/vpc/main.tf

# 1. Recurso: La VPC en sí
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.name}-vpc"
    Region      = var.aws_region
    Environment = var.environment
  }
}

# 2. Recurso: Obtener la tabla de enrutamiento principal
# Esto es crucial. AWS crea automáticamente una tabla principal. 
# Necesitamos su ID para añadir las rutas de peering más tarde.
data "aws_route_table" "default" {
  vpc_id = aws_vpc.this.id
  
  filter {
    name   = "association.main"
    values = ["true"]
  }
}