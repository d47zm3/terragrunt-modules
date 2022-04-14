variable "tags" {
  type = map(string)
}

variable "creation_token" {
  type = string
}

variable "encrypted" {
  type = bool
  default = true
}

variable "kms_key_id" {
  type = string
}

variable "performance_mode" {
  type = string
  default = "generalPurpose"
}

variable "transition_to_ia" {
  type = string
  default = "AFTER_30_DAYS"
}
