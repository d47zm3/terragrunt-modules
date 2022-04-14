variable "name" {
  type = string
}

variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "display_name" {
  type        = string
  description = "describe purpose of service account"
}

resource "google_kms_key_ring" "this" {
  name     = var.name
  location = var.region
}

resource "google_kms_crypto_key" "this" {
  name            = var.name
  key_ring        = google_kms_key_ring.this.id
  rotation_period = "2592000s"
}

resource "google_kms_crypto_key_iam_member" "this" {
  crypto_key_id = google_kms_crypto_key.this.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${google_service_account.this.email}"
}

resource "google_service_account" "this" {
  account_id   = "${var.name}-service-account"
  display_name = var.display_name
}

output "crypto_key_self_link" {
  value = google_kms_crypto_key.this.self_link
}

output "google_service_account_id" {
  value = google_service_account.this.email
}
