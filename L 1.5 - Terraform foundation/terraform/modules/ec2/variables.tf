variable "project_name" {
  type = string
}

variable "ec2_name" {
  type = string
}
variable "instance_type" {
  type = string
  description = "EC2 instance type"
}

variable "key_name" {
  description = "Existing AWS key pair name (used when create_key_pair=false)"
  type = string
  default = null
}

variable "my_ip" {
  type = string
}
variable "iam_instance_profile_name" {
  type = string
}

variable "bucket_name" {
  description = "Existing S3 bucket to store uploads"
  type = string
}

variable "region" {
  description = "AWS region for the app"
  type = string
}
