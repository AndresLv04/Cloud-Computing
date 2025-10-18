aws_region = "us-east-1"

common = {
  project_name = "terraform foundation"
}

s3 = {
  bucket_name = "terraform-s3-andres"

}
ec2 = {
  ec2_name                  = "ec2-terraform-andres"
  instance_type             = "t3.micro"
  key_name                  = "vockey"
  my_ip                     = "187.213.4.230/32"
  iam_instance_profile_name = "myS3Role"
}

