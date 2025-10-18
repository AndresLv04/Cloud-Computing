
output "s3_bucket_name" {
  value = module.s3.bucket_name
}

output "ec2_id" {
  value = module.ec2.instance_id
}

output "ec2_public_ip" {
  value = module.ec2.public_ip
}

output "ec2_sg_id" {
  value = module.ec2.sg_id
}

output "ec2_public_dns" {
  value = module.ec2.public_dns
}