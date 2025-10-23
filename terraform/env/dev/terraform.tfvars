# Regiones
aws_region_1 = "us-east-1"
aws_region_2 = "us-west-2"

# Datos de la otra cuenta para el peering
peer_account_id = "142644586445"   # ID de la otra cuenta 
peer_vpc_id     = "vpc-0d1b7261d16d4a791"               # VPC ID creada en la otra cuenta
peer_vpc_cidr   = "10.6.0.0/16"    # CIDR que usará la VPC de la otra cuenta


# CIDRs de mis VPCs 
vpc_a_cidr = "10.1.0.0/16"
vpc_b_cidr = "10.2.0.0/16"
vpc_c_cidr = "10.3.0.0/16"
vpc_d_cidr = "10.4.0.0/16"
vpc_e_cidr = "10.5.0.0/16"

# Flags (opcional)
vpc_b_use_region_b = false
