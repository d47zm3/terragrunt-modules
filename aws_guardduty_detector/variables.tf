variable "enabled" {
  type    = bool
  default = true
}

variable "finding_publishing_frequency" {
  type    = string
  default = "SIX_HOURS"
}

variable "datasources_s3_logs_enabled" {
  type    = bool
  default = true
}
