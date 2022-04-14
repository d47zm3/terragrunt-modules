variable "sql_instance_name" {}
variable "sql_database_chartset" { default = "utf8mb4" }
variable "sql_database_collation" { default = "utf8mb4_unicode_ci" }
variable "sql_database_names" { type = list(string) }

resource "google_sql_database" "database" {
  for_each = toset(var.sql_database_names)

  name      = each.value
  instance  = var.sql_instance_name
  charset   = var.sql_database_chartset
  collation = var.sql_database_collation
}
