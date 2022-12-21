variable "project" {}
variable "project_number" {}
variable "log_bucket" {}

variable "buckets" {
  type = map(object({
    suffix        = string
    location      = string
    storage_class = string
    versioning    = string
    cors = map(object({
      origin          = list(string)
      method          = list(string)
      response_header = list(string)
      max_age_seconds = string
    }))
    lifecycle_rule = map(object({
      age = number
    }))
    retention_policy = map(object({
      retention_period = number
    }))
  }))
}

resource "google_storage_bucket" "bucket" {
  for_each = var.buckets

  name          = "${var.project}-${each.value.suffix}"
  location      = each.value.location
  storage_class = each.value.storage_class

  versioning {
    enabled = each.value.versioning
  }

  labels = {
    project = var.project
    managed = "terraform"
  }

  logging {
    log_bucket = var.log_bucket
  }

  uniform_bucket_level_access = true

  dynamic "cors" {
    for_each = each.value.cors

    content {
      origin          = each.value.cors.default["origin"]
      method          = each.value.cors.default["method"]
      response_header = each.value.cors.default["response_header"]
      max_age_seconds = each.value.cors.default["max_age_seconds"]
    }
  }

  dynamic "lifecycle_rule" {
    for_each = each.value.lifecycle_rule

    content {
      condition {
        age = each.value.lifecycle_rule.default["age"]
      }
      action {
        type = "Delete"
      }
    }
  }

  dynamic "retention_policy" {
    for_each = each.value.retention_policy

    content {
      is_locked        = true
      retention_period = each.value.retention_policy.default["retention_period"]
    }
  }

  force_destroy = true
}
