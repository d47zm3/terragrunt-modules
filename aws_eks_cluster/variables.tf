variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "vpc_subnets" {
  type = list(string)
}

variable "service_ipv4_cidr" {
  type = string
}

variable "public_access_cidrs" {
  type = list(string)
}

variable "eks_enabled_cluster_log_types" {
  type    = set(string)
  default = ["api", "audit", "scheduler", "controllerManager", "authenticator"]
}

variable "iam_role" {
  type = string
}

variable "kms_key_arn" {
  type = string
}

variable "tags" {
  type = map(string)
}
