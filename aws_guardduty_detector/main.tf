resource "aws_guardduty_detector" "this" {
  enable = var.enabled

  finding_publishing_frequency = var.finding_publishing_frequency

  datasources {
    s3_logs {
      enable = var.datasources_s3_logs_enabled
    }
  }
}
