
# VPC default
data "aws_vpc" "default" {
  default = true
}

# Create Security Group for EC2 Instance
resource "aws_security_group" "sg" {
  name = "${var.project_name}-sg"
  description = "allow HTTP y SSH"
  vpc_id = data.aws_vpc.default.id

  # SSH access
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  # HTTP access
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-ec2-sg"
    Project     = var.project_name
  }
}

# Data source to get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}


# Create EC2 Instance
resource "aws_instance" "main" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg.id]
  iam_instance_profile = var.iam_instance_profile_name
  key_name = var.key_name
  associate_public_ip_address = true

  user_data_replace_on_change = true

  user_data_base64 = base64encode(
    templatefile("${path.module}/scripts/user_data.sh", {
      bucket_name = var.bucket_name
      region = var.region
    })
  )
  

  tags = {
    Name    = var.ec2_name
    Project = var.project_name
  }
}
