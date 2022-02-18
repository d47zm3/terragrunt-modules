resource "aws_guardduty_organization_configuration" "this" {
  auto_enable = var.auto_enable
  detector_id = var.guardduty_detector_id

  datasources {
    s3_logs {
      auto_enable = var.datasources_s3_logs_auto_enable
    }
  }
}
