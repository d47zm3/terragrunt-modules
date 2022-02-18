variable "name" {
  type = string
}

variable "image_tag_mutability" {
  type    = string
  default = "IMMUTABLE"
}

variable "kms_key" {
  type = string
}

variable "scan_on_push" {
  type = bool
}

variable "tags" {
  type = map(string)
}
