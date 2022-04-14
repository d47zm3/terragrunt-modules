data "tls_certificate" "github" {
  url = var.github_url
}

resource "aws_iam_openid_connect_provider" "github" {
  url = var.github_url
  client_id_list = [
    "sts.amazonaws.com"
  ]

  # hardcoded due to https://github.blog/changelog/2022-01-13-github-actions-update-on-oidc-based-deployments-to-aws/
  thumbprint_list = ["${data.tls_certificate.github.certificates.0.sha1_fingerprint}", "6938fd4d98bab03faadb97b34396831e3780aea1"]
}
