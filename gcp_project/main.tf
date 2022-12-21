variable "project" {
  description = "project name"
  type        = string
}
variable "org_id" {
  description = "organisation id"
  type        = string
}
variable "billing_account" {
  description = "billing account id to use for project charges"
  type        = string
}
variable "api_services" {
  description = "list of api services to enable"
  type        = list(string)
}

resource "google_project" "this" {
  name       = var.project
  project_id = var.project
  labels = {
    managed = "terraform"
    project = var.project
  }
  org_id              = var.org_id
  billing_account     = var.billing_account
  auto_create_network = false # neglected by organisation policy, it won't create default network
}

resource "google_project_service" "cloudresourcemanager" {
  service = "cloudresourcemanager.googleapis.com"

  project            = google_project.this.project_id
  disable_on_destroy = false

  depends_on = [
    google_project.this,
  ]
}

resource "google_project_service" "serviceusage" {
  service = "serviceusage.googleapis.com"

  project            = google_project.this.project_id
  disable_on_destroy = false

  depends_on = [
    google_project.this,
  ]
}

resource "google_project_service" "service" {

  for_each = { for service in var.api_services : service => service }
  service  = each.key

  project            = google_project.this.project_id
  disable_on_destroy = false

  depends_on = [
    google_project.this,
    google_project_service.serviceusage,
    google_project_service.cloudresourcemanager,
  ]
}

resource "google_project_iam_audit_config" "this" {
  project = google_project.this.id
  service = "allServices"
  audit_log_config {
    log_type = "ADMIN_READ"
  }
  audit_log_config {
    log_type = "DATA_READ"
  }

  depends_on = [
    google_project.this,
    google_project_service.service,
  ]
}

output "project_id" {
  value = google_project.this.project_id
}

output "project_number" {
  value = google_project.this.number
}
