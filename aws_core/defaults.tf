resource "aws_ebs_encryption_by_default" "this" {
  enabled = true
}

resource "aws_ebs_default_kms_key" "example" {
  key_arn = aws_kms_key.default.arn
}

resource "aws_kms_key" "default" {
  description             = "Default KMS Key For Account"
  deletion_window_in_days = var.default_kms_key_deletion_window_in_days
}

resource "aws_kms_alias" "default" {
  name          = "alias/default"
  target_key_id = aws_kms_key.default.key_id

  description             = "Default KMS Key For Account"
  deletion_window_in_days = var.default_kms_key_deletion_window_in_days
}
