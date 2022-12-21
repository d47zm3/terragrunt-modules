variable "project" {}
variable "region" {}
variable "name" {}

resource "google_compute_address" "this" {
  name         = "${var.project}-${var.name}"
  region       = var.region
  address_type = "EXTERNAL"
}

output "address" {
  value = google_compute_address.this.address
}
