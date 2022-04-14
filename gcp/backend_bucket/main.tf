variable "project" {}
variable "name" {}
variable "bucket_name" {}

resource "google_compute_backend_bucket" "this" {
  name        = "${var.project}-${var.name}"
  bucket_name = "${var.project}-${var.bucket_name}"
  enable_cdn  = true
}

output "self_link" {
  value = google_compute_backend_bucket.this.self_link
}
