resource "aws_cloudformation_stack" "iam_role" {
  name = var.name

  capabilities = [
    "CAPABILITY_NAMED_IAM"
  ]

  parameters = {
    RoleName = "DeploymentsRole"
  }

  template_body = templatefile("template.json", { aws_trusted_entity = var.aws_trusted_entity })
}
