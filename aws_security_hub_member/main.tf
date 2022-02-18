resource "aws_securityhub_account" "this" {}

resource "aws_securityhub_member" "this" {
  depends_on = [aws_securityhub_account.this]
  account_id = var.account_id
  email      = var.account_email
  invite     = var.invite
}
