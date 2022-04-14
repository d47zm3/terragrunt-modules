variable "project" {}
variable "iam_members" {
  type = map(object({
    role   = string
    member = string
  }))
}

resource "google_project_iam_member" "this" {

  for_each = var.iam_members

  project = var.project
  role    = each.value.role
  member  = each.value.member
}
