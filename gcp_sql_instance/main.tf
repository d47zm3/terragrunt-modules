variable "project" {}
variable "environment" {}
variable "sql_instance_version" {}
variable "sql_instance_region" {}
variable "sql_instance_tier" {}
variable "sql_instance_disk_type" {}
variable "sql_instance_disk_autoresize" {}
variable "sql_instance_type" {}
variable "sql_instance_deletion_protection" {}
variable "sql_instance_availability_type" {}
variable "ipv4_enabled" {
  type    = bool
  default = false
}
variable "master_instance_name" {
  default = null
}
variable "whitelist" {
  type    = list(map(string))
  default = []
}
variable "sql_instance_backup_configuration" {
  type    = list(map(string))
  default = []
}
variable "sql_instance_maintenance_window" {
  type    = list(map(string))
  default = []
}
variable "sql_instance_replica_configuration" {
  type    = list(map(string))
  default = []
}

variable "network_name" {}

resource "google_sql_database_instance" "instance" {
  name                = "${var.project}-${var.sql_instance_type}-${random_id.db_name_suffix.hex}"
  database_version    = var.sql_instance_version
  region              = var.sql_instance_region
  project             = var.project
  deletion_protection = var.sql_instance_deletion_protection

  master_instance_name = var.master_instance_name

  settings {
    tier              = var.sql_instance_tier
    disk_autoresize   = var.sql_instance_disk_autoresize
    disk_type         = var.sql_instance_disk_type
    activation_policy = "ALWAYS"
    availability_type = var.sql_instance_availability_type
    pricing_plan      = "PER_USE"

    ip_configuration {
      ipv4_enabled    = var.ipv4_enabled
      private_network = var.network_name
      require_ssl     = true

      dynamic "authorized_networks" {
        for_each = var.whitelist
        content {
          name  = authorized_networks.value.name
          value = authorized_networks.value.cidr
        }
      }
    }

    dynamic "backup_configuration" {
      for_each = var.sql_instance_backup_configuration

      content {
        enabled                        = backup_configuration.value.enabled
        binary_log_enabled             = backup_configuration.value.binary_log_enabled
        start_time                     = backup_configuration.value.start_time
        transaction_log_retention_days = backup_configuration.value.transaction_log_retention_days
        backup_retention_settings {
          retained_backups = backup_configuration.value.retained_backups
          retention_unit   = "COUNT"
        }
      }
    }

    dynamic "maintenance_window" {
      for_each = var.sql_instance_maintenance_window

      content {
        day          = maintenance_window.value.day
        hour         = maintenance_window.value.hour
        update_track = maintenance_window.value.update_track
      }
    }

    user_labels = {
      environment   = var.environment
      managed       = "terraform"
      instance_type = var.sql_instance_type
    }
  }

  dynamic "replica_configuration" {
    for_each = var.sql_instance_replica_configuration

    content {
      failover_target = replica_configuration.value.failover_target
    }
  }
}

resource "random_id" "db_name_suffix" {
  byte_length = 4
}

output "name" {
  value = google_sql_database_instance.instance.name
}

output "address" {
  value = google_sql_database_instance.instance.ip_address.0.ip_address
}
