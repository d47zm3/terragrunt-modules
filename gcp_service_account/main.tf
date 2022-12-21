variable "service_accounts" {
  type = map(object({
    account_id   = string
    display_name = string
  }))
}

resource "google_service_account" "sa" {
  for_each = var.service_accounts

  account_id   = each.value.account_id
  display_name = each.value.display_name
}

resource "google_service_account_key" "sa_key" {
  for_each = var.service_accounts

  service_account_id = each.value.account_id
  public_key_type    = "TYPE_X509_PEM_FILE"
  depends_on         = [google_service_account.sa]
}

output "emails" {

  value = {
    for s in google_service_account.sa : s.account_id => s.email
  }
}

output "private_key" {
  value = {
    for s in google_service_account_key.sa_key : s.service_account_id => s.private_key
  }
  sensitive = true
}
