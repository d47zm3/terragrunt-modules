variable "project" {}
variable "iam_role" {}
variable "iam_members" {
  type = list(string)
}

resource "google_project_iam_binding" "sa_iam" {
  project = var.project
  role    = var.iam_role
  members = var.iam_members
}
