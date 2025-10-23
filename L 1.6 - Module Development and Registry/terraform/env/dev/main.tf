terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Providers (dos alias)
provider "aws" {
  alias  = "region1_self"
  region = var.aws_region_1
}

provider "aws" {
  alias  = "region2_self"
  region = var.aws_region_2
}

# Módulos VPC - misma cuenta, misma región
module "vpc_1a" {
  source     = "../../modules/vpc"
  providers  = { aws = aws.region1_self }
  name       = "lab-1A-misma-region"
  vpc_cidr   = var.vpc_a_cidr
  aws_region = var.aws_region_1
}

module "vpc_1b" {
  source     = "../../modules/vpc"
  providers  = { aws = aws.region1_self }
  name       = "lab-1B-misma-region"
  vpc_cidr   = var.vpc_b_cidr
  aws_region = var.aws_region_1
}

# Módulo para el peering cross-account (mi cuenta)
module "vpc_3a_self" {
  source     = "../../modules/vpc"
  providers  = { aws = aws.region1_self }
  name       = "lab-3A-mi-cuenta"
  vpc_cidr   = var.vpc_e_cidr
  aws_region = var.aws_region_1
}

# PEERING - ESCENARIO 1 (misma cuenta, misma región) — auto-accept
resource "aws_vpc_peering_connection" "peer_1" {
  provider    = aws.region1_self
  vpc_id      = module.vpc_1a.vpc_id
  peer_vpc_id = module.vpc_1b.vpc_id
  auto_accept = true
  tags        = { Name = "lab-1-same-region-peering" }
}

# Rutas para peer_1 (misma cuenta) -> referenciando el resource (NO hardcode)
resource "aws_route" "route_1a_to_1b" {
  provider                  = aws.region1_self
  route_table_id            = module.vpc_1a.default_route_table_id
  destination_cidr_block    = module.vpc_1b.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_1.id
}

resource "aws_route" "route_1b_to_1a" {
  provider                  = aws.region1_self
  route_table_id            = module.vpc_1b.default_route_table_id
  destination_cidr_block    = module.vpc_1a.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_1.id
}

# PEERING cross-account: crear request (la otra cuenta debe aceptar en Console)
resource "aws_vpc_peering_connection" "peer_3_request" {
  provider      = aws.region1_self
  vpc_id        = module.vpc_3a_self.vpc_id
  peer_vpc_id   = var.peer_vpc_id        # VPC ID del peer (rellenar en tfvars)
  peer_owner_id = var.peer_account_id    # Account ID del peer (rellenar en tfvars)
  peer_region   = var.peer_region        # región del peer (rellenar en tfvars)
  auto_accept   = false
  tags = {
    Name = "lab-3-cross-account-peering-request"
  }
}

resource "aws_route" "route_e_to_peer" {
  provider                  = aws.region1_self
  route_table_id            = module.vpc_3a_self.default_route_table_id
  destination_cidr_block    = var.peer_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_3_request.id
  depends_on                = [aws_vpc_peering_connection.peer_3_request]
}