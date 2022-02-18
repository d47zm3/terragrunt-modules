resource "aws_guardduty_invite_accepter" "this" {
  detector_id       = var.detector_id
  master_account_id = var.master_account_id
}
