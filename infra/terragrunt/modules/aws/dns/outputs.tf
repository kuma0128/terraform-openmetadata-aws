output "openmetadata_zone_id" {
  value       = aws_route53_zone.openmetadata_zone.zone_id
  description = "id of the Route53 zone"
}

output "cert_arn" {
  value       = aws_acm_certificate.cert.arn
  description = "ARN of ACM certificate"
}

output "domain_name" {
  value       = var.domain_name
  description = "Primary domain name"
}

