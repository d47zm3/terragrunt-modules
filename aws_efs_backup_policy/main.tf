resource "aws_efs_backup_policy" "this" {
  file_system_id = var.file_system_id

  backup_policy {
    status = var.status
  }
}
