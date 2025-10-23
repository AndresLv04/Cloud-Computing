# modules/vpc/variables.tf

variable "name" {
  description = "Un nombre único para la VPC, usado en las etiquetas (tags)."
  type        = string
}

variable "vpc_cidr" {
  description = "El bloque CIDR (ej: 10.0.0.0/16) para la VPC."
  type        = string
}

variable "aws_region" {
  description = "La región de AWS donde se despliega esta VPC."
  type        = string
}

# (Opcional, para incluir la tabla de enrutamiento por defecto en el output, simplifica el peering)
variable "environment" {
  description = "La etiqueta de entorno."
  type        = string
  default     = "dev"
}