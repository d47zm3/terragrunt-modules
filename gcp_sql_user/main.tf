variable "sql_instance_name" {}
variable "sql_database_users" {
  type = map(object({
    name     = string
    password = string
    host     = string
  }))
}

resource "google_sql_user" "user" {
  for_each = var.sql_database_users

  instance = var.sql_instance_name
  name     = each.value.name
  password = each.value.password
  host     = each.value.host
}

resource "local_file" "mysql-grants" {
  content  = templatefile("mysql_grants.tmpl", { users = var.sql_database_users })
  filename = "mysql-grants.sql"
}
