variable "project" {}
variable "name" {}

resource "google_compute_global_address" "this" {
  name         = "${var.project}-${var.name}"
  ip_version   = "IPV4"
  address_type = "EXTERNAL"
}

output "address" {
  value = google_compute_global_address.this.address
}
