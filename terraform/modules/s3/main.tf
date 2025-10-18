resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name
  force_destroy = true

  tags = {
    Name = var.bucket_name
    Project = var.project_name
    Environment = "Test"
  }
}

# Configure bucket versioning
resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

# Configure bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.encryption_algorithm
    }
    bucket_key_enabled = var.bucket_key_enabled
  }
}

# Configure bucket public access block
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls = var.block_public_acls
  block_public_policy = var.block_public_policy
  ignore_public_acls = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}


