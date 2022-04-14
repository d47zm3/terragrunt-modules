output "endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "name" {
  value = aws_eks_cluster.this.name
}

output "cluster_id" {
  value = aws_eks_cluster.this.id
}

output "vpc_config" {
  value = aws_eks_cluster.this.vpc_config
}

output "aws_iam_openid_connect_provider_url" {
  value = aws_iam_openid_connect_provider.this.url
}

output "aws_iam_openid_connect_provider_arn" {
  value = aws_iam_openid_connect_provider.this.arn
}
