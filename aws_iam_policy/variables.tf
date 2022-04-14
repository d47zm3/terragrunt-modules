variable "name" {
  type = string
}

variable "path" {
  type    = string
  default = "/"
}

variable "description" {
  type = string
}

variable "policy" {
  type = string
}

variable "tags" {
  type = map(string)
}
