variable "project" {}
variable "environment" {}
variable "name" {}
variable "zone" {}
variable "disk_size" {}
variable "disk_type" {}
variable "disk_image" { default = null }
variable "encryption_kms_key_self_link" {}
variable "encryption_kms_key_service_account" {}

resource "google_compute_disk" "disk" {
  name  = "${var.project}-${var.name}"
  zone  = var.zone
  type  = var.disk_type
  size  = var.disk_size
  image = var.disk_image

  disk_encryption_key {
    kms_key_self_link       = var.encryption_kms_key_self_link
    kms_key_service_account = var.encryption_kms_key_service_account
  }

  labels = {
    project     = var.project
    environment = var.environment
    managed     = "terraform"
  }
}

output "self_link" {
  value = google_compute_disk.disk.self_link
}

output "name" {
  value = google_compute_disk.disk.name
}
