variable "role_id" {}
variable "title" {
  type = string
}
variable "description" {
  type = string
}
variable "permissions" {
  type    = list(string)
  default = []
}

resource "google_project_iam_custom_role" "this" {
  role_id     = var.role_id
  title       = var.title
  description = var.description
  permissions = var.permissions
}

output "id" {
  value = google_project_iam_custom_role.this.id
}
