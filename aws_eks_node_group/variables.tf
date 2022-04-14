variable "cluster_name" {
  type = string
}

variable "node_group_name" {
  type = string
}

variable "node_role_arn" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "ami_type" {
  type    = string
  default = "AL2_x86_64"
}

variable "capacity_type" {
  type = string
}

variable "disk_size" {
  type    = number
  default = 100
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "trusted_networks" {
  type    = set(string)
  default = [""]
}

variable "force_update_version" {
  type    = bool
  default = false
}

variable "instance_types" {
  type = set(string)
}

variable "scaling_config_desired_size" {
  type = number
}

variable "scaling_config_max_size" {
  type = number
}

variable "scaling_config_min_size" {
  type = number
}

variable "update_config_max_unavailable" {
  type = number
}

variable "tags" {
  type = map(string)
}
