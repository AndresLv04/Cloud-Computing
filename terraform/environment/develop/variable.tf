variable "aws_region" {
  description = "aws region"
  type        = string
  default     = "us-east-1"
}
variable "common" {
  type = object({
    project_name = string
  })
}
variable "s3" {
  type = object({
    bucket_name = string
  })
}

variable "ec2" {
  type = object({
    ec2_name                  = string
    instance_type             = string
    key_name                  = string
    my_ip                     = string
    iam_instance_profile_name = string
  })
}

