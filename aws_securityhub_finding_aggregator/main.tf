resource "aws_securityhub_finding_aggregator" "this" {
  linking_mode = var.linking_mode
}
