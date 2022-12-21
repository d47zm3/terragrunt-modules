variable "project" {}
variable "region" {}
variable "ip_cidr_range" {}

resource "google_compute_network" "network" {
  name                    = "${var.project}-network"
  project                 = var.project
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnetwork" {
  name                     = "${var.project}-subnetwork"
  project                  = var.project
  depends_on               = [google_compute_network.network]
  ip_cidr_range            = var.ip_cidr_range
  network                  = google_compute_network.network.self_link
  region                   = var.region
  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.2
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

output "google_compute_subnetwork_name" {
  value       = google_compute_subnetwork.subnetwork.name
  description = "subnetwork name referenced by other modules, where resources will be created"
}

output "google_compute_network_name" {
  value       = google_compute_network.network.name
  description = "network name referenced by other modules, where resources will be created"
}

output "subnetwork_id" {
  value       = google_compute_subnetwork.subnetwork.id
  description = "subnetwork id"
}

output "network_id" {
  value       = google_compute_network.network.id
  description = "network id"
}
