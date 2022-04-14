variable "region" {
  type = string
}

variable "endpoint_url" {
  type = string
}

variable "endpoint_key" {
  type = string
}

variable "firehose_name" {
  type    = string
  default = "DatadogCWLogsforwarder"
}

variable "kinesis_firehose_buffer" {
  type    = number
  default = 4
}

variable "kinesis_firehose_buffer_interval" {
  type    = number
  default = 60
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "s3_bucket_name" {
  type = string
}

variable "kinesis_firehose_role_arn" {
  type = string
}

variable "content_encoding" {
  type    = string
  default = "GZIP"
}

variable "s3_backup_mode" {
  description = "Valid values are FailedDataOnly and AllData"
  type        = string
  default     = "FailedDataOnly"
}
