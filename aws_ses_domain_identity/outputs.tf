output "arn" {
  value = aws_ses_domain_identity.this.arn
}

output "verification_token" {
  value = aws_ses_domain_identity.this.verification_token
}
