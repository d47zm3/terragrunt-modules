#tfsec:ignore:AWS002
resource "aws_s3_bucket" "kinesis_firehose_s3_bucket" {
  bucket = var.s3_bucket_name
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }
  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.kinesis_firehose_s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_role" "kinesis_firehose_role" {
  name               = var.kinesis_firehose_role_name
  description        = "IAM Role for Kinesis Firehose"
  assume_role_policy = file("policy.json")
  tags               = var.tags
}

resource "aws_kinesis_firehose_delivery_stream" "kinesis_firehose_stream" {
  name        = var.firehose_name
  destination = "http_endpoint"

  s3_configuration {
    role_arn        = aws_iam_role.kinesis_firehose_role.arn
    bucket_arn      = aws_s3_bucket.kinesis_firehose_s3_bucket.arn
    buffer_size     = var.kinesis_firehose_buffer
    buffer_interval = 300
  }

  extended_s3_configuration {
    s3_backup_mode = "Enabled"

    s3_backup_configuration {
      role_arn        = aws_iam_role.kinesis_firehose_role.arn
      bucket_arn      = aws_s3_bucket.kinesis_firehose_s3_bucket.arn
      buffer_size     = var.kinesis_firehose_buffer
      buffer_interval = 300
    }
  }

  http_endpoint_configuration {
    url                = var.endpoint_url
    name               = "Datadog"
    access_key         = var.access_key
    buffering_size     = var.kinesis_firehose_buffer
    buffering_interval = var.kinesis_firehose_buffer_interval
    role_arn           = aws_iam_role.kinesis_firehose_role.arn
    s3_backup_mode     = var.s3_backup_mode

    request_configuration {
      content_encoding = var.content_encoding
    }
  }

  server_side_encryption {
    enabled  = true
    key_type = "AWS_OWNED_CMK"
  }
}
