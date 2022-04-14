variable "project_id" {}
variable "network_name" {}
variable "whitelist" {
  type        = list(any)
  description = "whitelisted cidr blocks that can access resources"
  default     = []
}

resource "google_compute_firewall" "external_firewall" {
  name    = "${var.project_id}-external"
  network = var.network_name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [for r in var.whitelist : r.cidr]
}

resource "google_compute_firewall" "internal_firewall" {
  name    = "${var.project_id}-internal"
  network = var.network_name

  allow {
    protocol = "all"
  }

  priority      = "100"
  source_ranges = ["10.0.0.0/16"]
}
