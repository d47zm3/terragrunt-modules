resource "aws_iam_role" "ci_role" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.allow_ci.json
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "gitlab_admin" {
  role       = aws_iam_role.ci_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "aws_iam_policy_document" "allow_ci" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.gitlab.arn]
    }

    condition {
      test     = "ForAllValues:StringLike"
      variable = "${aws_iam_openid_connect_provider.gitlab.url}:sub"
      values   = [for repo in var.gitlab_repos : "project_path:${var.gitlab_org}/${repo}:*"]
    }
  }
}
