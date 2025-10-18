module "ec2" {
  source                    = "../../modules/ec2"
  project_name              = var.common.project_name
  ec2_name                  = var.ec2.ec2_name
  instance_type             = var.ec2.instance_type
  my_ip                     = var.ec2.my_ip
  iam_instance_profile_name = var.ec2.iam_instance_profile_name
  key_name                  = var.ec2.key_name

  bucket_name = var.s3.bucket_name
  region      = var.aws_region
}

module "s3" {
  source       = "../../modules/s3"
  project_name = var.common.project_name
  bucket_name  = var.s3.bucket_name
}