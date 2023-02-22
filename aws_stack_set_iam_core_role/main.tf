#data "aws_iam_policy_document" "AWSCloudFormationStackSetAdministrationRole_assume_role_policy" {
#  statement {
#    actions = ["sts:AssumeRole"]
#    effect  = "Allow"
#
#    principals {
#      identifiers = ["cloudformation.amazonaws.com"]
#      type        = "Service"
#    }
#  }
#}
#
#resource "aws_iam_role" "AWSCloudFormationStackSetAdministrationRole" {
# assume_role_policy = data.aws_iam_policy_document.AWSCloudFormationStackSetAdministrationRole_assume_role_policy.json
#  name               = "AWSCloudFormationStackSetAdministrationRole"
#}

resource "aws_cloudformation_stack_set" "iam_role" {
  #administration_role_arn = aws_iam_role.AWSCloudFormationStackSetAdministrationRole.arn
  name = var.name

  permission_model = "SERVICE_MANAGED"

  capabilities = [
    "CAPABILITY_NAMED_IAM"
  ]


  auto_deployment {
    enabled                          = true
    retain_stacks_on_account_removal = false
  }

  parameters = {
    RoleName = "DeploymentsRole"
  }

  template_body = templatefile("template.json", { aws_trusted_entity = var.aws_trusted_entity })
}

resource "aws_cloudformation_stack_set_instance" "global_iam_role" {
  deployment_targets {
    organizational_unit_ids = [var.aws_organization_root_id]
  }

  region         = var.region
  stack_set_name = aws_cloudformation_stack_set.iam_role.name
}

#data "aws_iam_policy_document" "AWSCloudFormationStackSetAdministrationRole_ExecutionPolicy" {
#  statement {
#    actions   = ["sts:AssumeRole"]
#    effect    = "Allow"
#    resources = ["arn:aws:iam::*:role/${aws_cloudformation_stack_set.iam_role.execution_role_name}"]
#  }
#}
#
#resource "aws_iam_role_policy" "AWSCloudFormationStackSetAdministrationRole_ExecutionPolicy" {
#  name   = "ExecutionPolicy"
#  policy = data.aws_iam_policy_document.AWSCloudFormationStackSetAdministrationRole_ExecutionPolicy.json
#  role   = aws_iam_role.AWSCloudFormationStackSetAdministrationRole.name
#}
