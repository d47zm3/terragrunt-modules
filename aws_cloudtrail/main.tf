data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_cloudtrail" "this" {
  name                          = "${var.name}-cloudtrail"
  enable_logging                = true
  is_multi_region_trail         = true
  is_organization_trail         = true
  enable_log_file_validation    = true
  s3_bucket_name                = aws_s3_bucket.this.id
  include_global_service_events = true
  kms_key_id                    = aws_kms_key.this.arn
}

resource "aws_kms_key" "this" {
  description              = "KMS Key for Cloudtrail"
  key_usage                = "ENCRYPT_DECRYPT"
  is_enabled               = true
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation      = true
  deletion_window_in_days  = 7
  policy                   = templatefile("kms_key_policy.json", { region = data.aws_region.current.name, aws_account_id = data.aws_caller_identity.current.account_id })
  tags                     = var.tags
}

resource "aws_kms_alias" "this" {
  name          = "alias/cloudtrail"
  target_key_id = aws_kms_key.this.key_id
}

#tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "this" {
  bucket        = "${var.name}-cloudtrail"
  acl           = "private"
  force_destroy = false
  versioning {
    enabled = true
  }
  policy = templatefile("s3_bucket_policy.json", { bucket_name = "${var.name}-cloudtrail", aws_account_id = data.aws_caller_identity.current.account_id })

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.this.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  ignore_public_acls      = true
  restrict_public_buckets = true
  block_public_acls       = true
  block_public_policy     = true
}
