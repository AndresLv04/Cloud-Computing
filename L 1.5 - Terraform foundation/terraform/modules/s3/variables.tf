variable "project_name" {
  type = string
}

variable "bucket_name" {
  type = string

  validation {
    condition = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.bucket_name)) && length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "Bucket name must be 3-63 characters long, contain only lowercase letters, numbers, and hyphens, and start/end with alphanumeric characters."
  }
}

variable "enable_versioning" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = true
}

variable "encryption_algorithm" {
  description = "Server-side encryption algorithm"
  type        = string
  default     = "AES256"

  validation {
    condition = contains(["AES256", "aws:kms"], var.encryption_algorithm)
    error_message = "Encryption algorithm must be either AES256 or aws:kms."
  }
}
variable "bucket_key_enabled" {
  description = "Enable bucket key for S3 Bucket Keys with SSE-KMS"
  type        = bool
  default     = false
}

variable "block_public_acls" {
  description = "Block public ACLs for the bucket"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Block public bucket policies"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignore public ACLs for the bucket"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restrict public bucket policies"
  type        = bool
  default     = true
}
