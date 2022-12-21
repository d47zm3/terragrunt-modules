variable "project" {}
variable "service_account_id" {}
variable "role" {}
variable "members" { type = list(any) }

resource "google_service_account_iam_binding" "this" {
  service_account_id = var.service_account_id
  role               = var.role

  members = formatlist("serviceAccount:${var.project}.svc.id.goog[%s]", var.members)
}
