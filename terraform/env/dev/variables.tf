variable "aws_region_1" { 

  type = string
  default = "us-east-1" 
 }
variable "aws_region_2" { 
  type = string
 default = "us-west-2" 
 }

variable "peer_account_id" { 
  type = string
  default = "992382628841" 
}
variable "peer_vpc_id" { 
  type = string
  default = "" 
}
variable "peer_vpc_cidr"   { 
  type = string
  default = "10.6.0.0/16" 
}

variable "vpc_a_cidr" { 
  type = string
  default = "10.1.0.0/16" 
}
variable "vpc_b_cidr" { 
  type = string
  default = "10.2.0.0/16" 
}
variable "vpc_c_cidr" { 
  type = string
  default = "10.3.0.0/16" 
}
variable "vpc_d_cidr" { 
  type = string
  default = "10.4.0.0/16" 
}
variable "vpc_e_cidr" { 
  type = string
  default = "10.5.0.0/16" 
}

variable "vpc_b_use_region_b" { 
  type = bool
  default = false 
}

variable "peer_region"     { 
  type = string
  default = "us-east-1" 
}
