resource "aws_efs_file_system" "this" {
  creation_token = var.creation_token

  encrypted = var.encrypted
  kms_key_id = var.kms_key_id
  performance_mode = var.performance_mode

  lifecycle_policy {
    transition_to_ia = var.transition_to_ia
  }

  tags = var.tags
}
