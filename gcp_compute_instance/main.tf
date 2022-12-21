variable "project" {}
variable "environment" {}
variable "name" {}
variable "zone" {}
variable "machine_type" {}
variable "network_name" {}
variable "subnetwork_name" {}
variable "ip_address" {}
variable "deletion_protection" {}
variable "boot_disk" {}
variable "attached_disks" {
  type    = list(any)
  default = []
}
variable "service_account" {
  type = string
}
variable "encryption_kms_key" {}
variable "startup_script" {
  type        = string
  description = "BASE64 encoded startup script"
  default     = null
}

resource "google_compute_instance" "node" {
  name         = "${var.project}-${var.name}"
  project      = var.project
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["terraform", var.project, var.environment]

  allow_stopping_for_update = true

  boot_disk {
    auto_delete       = false
    source            = var.boot_disk
    kms_key_self_link = var.encryption_kms_key
  }

  dynamic "attached_disk" {
    for_each = var.attached_disks

    content {
      source      = attached_disk.value["source"]
      device_name = attached_disk.value["device_name"]
    }
  }

  network_interface {
    network    = var.network_name
    subnetwork = var.subnetwork_name
    network_ip = var.ip_address
  }

  deletion_protection = var.deletion_protection

  metadata = {
    block-project-ssh-keys  = true
    enable-osconfig         = true
    enable-guest-attributes = true
    #startup-script          = file("${path.module}/templates/nfs-startup.tpl")
    startup-script = base64decode(var.startup_script)
  }

  labels = {
    project = var.project
    managed = "terraform"
  }

  scheduling {
    automatic_restart   = "true"
    preemptible         = "false"
    on_host_maintenance = "MIGRATE"
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_integrity_monitoring = true
    enable_vtpm                 = true
  }

  service_account {
    scopes = ["cloud-platform"]
    email  = var.service_account
  }
}

output "id" {
  value = google_compute_instance.node.id
}
