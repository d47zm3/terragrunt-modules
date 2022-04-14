variable "name" {}
variable "project" {}
variable "environment" {}
variable "region" {}
variable "start_time" {
  type    = string
  default = "14:00" # means around 1AM in EU
}
variable "days_in_cycle" {
  type    = number
  default = 1
}
variable "max_retention_days" {
  type    = number
  default = 7
}
variable "storage_locations" {
  type    = list(string)
  default = ["eu"]
}
variable "disk_name" {}
variable "disk_zone" {}

resource "google_compute_resource_policy" "this" {
  name   = var.name
  region = var.region
  snapshot_schedule_policy {
    schedule {
      daily_schedule {
        days_in_cycle = var.days_in_cycle
        start_time    = var.start_time
      }
    }
    retention_policy {
      max_retention_days    = var.max_retention_days
      on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
    }
    snapshot_properties {
      labels = {
        environment = var.environment
        managed     = "terraform"
        project     = var.project
      }
      storage_locations = var.storage_locations
      guest_flush       = false
    }
  }
}

resource "google_compute_disk_resource_policy_attachment" "this" {
  name = var.name
  disk = var.disk_name
  zone = var.disk_zone

  depends_on = [
    google_compute_resource_policy.this
  ]
}
