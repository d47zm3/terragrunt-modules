resource "aws_config_aggregate_authorization" "this" {
  account_id = var.account_id
  region     = var.region
}
