variable "name" {
  type = string
}

variable "delay_seconds" {
  type = number
}

variable "max_message_size" {
  type = number
}

variable "message_retention_seconds" {
  type = number
}

variable "receive_wait_time_seconds" {
  type = number
}

variable "visibility_timeout_seconds" {
  type    = number
  default = 30
}

variable "redrive_policy" {
  type    = string
  default = ""
}

variable "redrive_allow_policy" {
  type    = string
  default = ""
}

variable "kms_master_key_id" {
  type = string
}

variable "kms_data_key_reuse_period_seconds" {
  type = number
}

variable "tags" {
  type = map(string)
}
