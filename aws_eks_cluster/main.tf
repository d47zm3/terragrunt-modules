resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.iam_role

  vpc_config {
    subnet_ids              = var.vpc_subnets
    public_access_cidrs     = var.public_access_cidrs
    endpoint_private_access = true
    endpoint_public_access  = true #tfsec:ignore:AWS069
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.service_ipv4_cidr
  }

  encryption_config {
    provider {
      key_arn = var.kms_key_arn
    }
    resources = ["secrets"]
  }

  enabled_cluster_log_types = var.eks_enabled_cluster_log_types
  tags                      = var.tags
}

data "tls_certificate" "this" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "this" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.this.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer
}
