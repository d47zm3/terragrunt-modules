variable "auto_enable" {
  type    = bool
  default = true
}

variable "guardduty_detector_id" {
  type = string
}

variable "datasources_s3_logs_auto_enable" {
  type    = bool
  default = true
}
