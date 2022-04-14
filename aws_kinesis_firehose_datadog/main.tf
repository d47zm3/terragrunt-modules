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

resource "aws_cloudwatch_log_group" "this" {
  name              = "/datadog-logs-firehose"
  retention_in_days = 7

  tags = var.tags
}

resource "aws_cloudwatch_log_stream" "s3" {
  name           = "s3"
  log_group_name = aws_cloudwatch_log_group.this.name
}

resource "aws_cloudwatch_log_stream" "firehose" {
  name           = "firehose"
  log_group_name = aws_cloudwatch_log_group.this.name
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.kinesis_firehose_s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_kinesis_firehose_delivery_stream" "kinesis_firehose_stream" {
  name        = var.firehose_name
  destination = "http_endpoint"

  s3_configuration {
    role_arn           = var.kinesis_firehose_role_arn
    bucket_arn         = aws_s3_bucket.kinesis_firehose_s3_bucket.arn
    buffer_size        = var.kinesis_firehose_buffer
    buffer_interval    = 60
    compression_format = "GZIP"

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.this.name
      log_stream_name = aws_cloudwatch_log_stream.s3.name
    }
  }

  http_endpoint_configuration {
    url                = var.endpoint_url
    name               = "Datadog"
    access_key         = var.endpoint_key
    buffering_size     = var.kinesis_firehose_buffer
    buffering_interval = var.kinesis_firehose_buffer_interval
    role_arn           = var.kinesis_firehose_role_arn
    s3_backup_mode     = var.s3_backup_mode

    request_configuration {
      content_encoding = var.content_encoding

      common_attributes {
        name  = "account_alias"
        value = data.aws_iam_account_alias.current.account_alias
      }

      common_attributes {
        name  = "region"
        value = data.aws_region.current.name
      }
    }

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.this.name
      log_stream_name = aws_cloudwatch_log_stream.firehose.name
    }
  }

  server_side_encryption {
    enabled  = true
    key_type = "AWS_OWNED_CMK"
  }
}
