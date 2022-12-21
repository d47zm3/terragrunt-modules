variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "network_id" {
  type = string
}

resource "google_compute_router" "router" {
  name    = "${var.project}-cloud-router"
  region  = var.region
  network = var.network_id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.project}-nat-gateway"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
