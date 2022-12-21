variable "service_account_id" {}
variable "bindings" {
  type = map(object({
    members = list(string)
    role    = string
  }))
}

data "google_iam_policy" "this" {

  dynamic "binding" {
    for_each = var.bindings

    content {
      members = binding.value.members
      role    = binding.value.role
    }
  }
}

resource "google_service_account_iam_policy" "this" {
  service_account_id = var.service_account_id
  policy_data        = data.google_iam_policy.this.policy_data
}
