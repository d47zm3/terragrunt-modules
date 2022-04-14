variable "name" {
  type = string
}

variable "comment" {
  type    = string
  default = "Cloudfront Cache Policy"
}

variable "default_ttl" {
  type    = number
  default = 300
}

variable "max_ttl" {
  type    = number
  default = 900
}

variable "min_ttl" {
  type    = number
  default = 30
}

variable "cookie_behavior" {
  type    = string
  default = "whitelist"
}

variable "cookies_items" {
  type    = list(any)
  default = []
}

variable "header_behavior" {
  type    = string
  default = "whitelist"
}

variable "headers_items" {
  type    = list(any)
  default = []
}

variable "query_string_behavior" {
  type    = string
  default = "whitelist"
}

variable "query_strings_items" {
  type    = list(any)
  default = []
}
