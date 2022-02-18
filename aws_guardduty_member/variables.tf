variable "account_id" {
  type        = string
  description = "(Required) AWS account ID for member account."
}

variable "detector_id" {
  type        = string
  description = "(Required) The detector ID of the GuardDuty account where you want to create member accounts."
}

variable "email" {
  type        = string
  description = "(Required) Email address for member account."
}

variable "invite" {
  type        = bool
  description = "(Optional) Boolean whether to invite the account to GuardDuty as a member."
  default     = true
}

variable "invitation_message" {
  type    = string
  default = "Please Accept AWS Guard Duty Invitation."
}

variable "disable_email_notifications" {
  type        = bool
  description = "(Optional) Boolean whether an email notification is sent to the accounts."
  default     = false
}
