variable "bucket" {
  type = string
}

variable "bindings" {
  type = list(object({
    role    = string
    members = list(string)
  }))
}

data "google_iam_policy" "this" {
  dynamic "binding" {
    for_each = var.bindings

    content {
      role    = binding.value.role
      members = binding.value.members
    }
  }
}

resource "google_storage_bucket_iam_policy" "policy" {
  bucket      = var.bucket
  policy_data = data.google_iam_policy.this.policy_data
}
