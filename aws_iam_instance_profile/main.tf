resource "aws_iam_instance_profile" "this" {
  name = var.name
  role = var.role
  tags = var.tags
}
