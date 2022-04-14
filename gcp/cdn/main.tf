variable "project" {}
variable "domains" {
  type = list(string)
}
variable "compute_global_address" {}
variable "default_compute_backend_bucket" {}
variable "path_rules" {
  type    = list(any)
  default = []
}

resource "google_compute_managed_ssl_certificate" "this" {
  provider = google-beta
  project  = var.project

  name = "${var.project}-managed-ssl"

  managed {
    domains = var.domains
  }
}

resource "google_compute_global_forwarding_rule" "http" {
  name       = "${var.project}-frontend-http"
  target     = google_compute_target_http_proxy.this.self_link
  ip_address = var.compute_global_address
  port_range = "80"
}

resource "google_compute_global_forwarding_rule" "https" {
  name       = "${var.project}-frontend-https"
  target     = google_compute_target_https_proxy.this.self_link
  ip_address = var.compute_global_address
  port_range = "443"
}

resource "google_compute_target_http_proxy" "this" {
  name    = "${var.project}-http-proxy"
  url_map = google_compute_url_map.this.self_link
}

resource "google_compute_target_https_proxy" "this" {
  name             = "${var.project}-https-proxy"
  url_map          = google_compute_url_map.this.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.this.id]
}

resource "google_compute_url_map" "this" {
  name            = "${var.project}-forward"
  default_service = var.default_compute_backend_bucket

  host_rule {
    hosts        = var.domains
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = var.default_compute_backend_bucket

    dynamic "path_rule" {
      for_each = [for path_rule in var.path_rules : {
        paths   = path_rule.paths
        service = path_rule.service
      }]

      content {
        paths   = path_rule.value.paths
        service = path_rule.value.service
      }
    }
  }
}
