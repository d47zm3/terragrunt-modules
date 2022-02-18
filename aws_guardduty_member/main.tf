resource "aws_guardduty_member" "this" {
  account_id                 = var.account_id
  detector_id                = var.detector_id
  email                      = var.email
  invite                     = var.invite
  invitation_message         = var.invitation_message
  disable_email_notification = var.disable_email_notifications

  lifecycle {
    ignore_changes = [
      email
    ]
  }
}
