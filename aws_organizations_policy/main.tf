resource "aws_organizations_policy" "this" {
  name    = var.name
  content = var.content
}
