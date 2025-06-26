data "aws_acm_certificate" "openmetadata_certificate" {
  domain = var.domain_name
}
data "aws_route53_zone" "openmetadata_zone" {
  name = var.domain_name
}