resource "aws_cloudwatch_log_group" "route53_query" {
  name              = "/aws/route53/query"
  retention_in_days = var.log_retention_in_days
}

data "aws_iam_policy_document" "route53_query" {
  statement {
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.route53_query.arn}:*"]

    principals {
      type        = "Service"
      identifiers = ["route53.amazonaws.com"]
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "route53_query" {
  policy_name     = "${var.name_prefix}-route53-query"
  policy_document = data.aws_iam_policy_document.route53_query.json
}

resource "aws_route53_zone" "openmetadata_zone" {
  name          = var.domain_name
  force_destroy = false

  tags = {
    Name = "${var.name_prefix}-dns-${var.region_short_name}-openmetadata"
  }
}

resource "aws_route53_query_log" "route53_query" {
  zone_id                  = aws_route53_zone.openmetadata_zone.zone_id
  cloudwatch_log_group_arn = aws_cloudwatch_log_group.route53_query.arn

  depends_on = [aws_cloudwatch_log_resource_policy.route53_query]
}

resource "aws_route53_record" "dev_ns_record" {
  count   = var.env == "prd" ? 1 : 0
  zone_id = aws_route53_zone.openmetadata_zone.zone_id
  name    = "dev.${var.domain_name}"
  type    = "NS"
  ttl     = 3600
  records = var.dev_ns_records
}

resource "aws_route53_record" "stg_ns_record" {
  count   = var.env == "prd" ? 1 : 0
  zone_id = aws_route53_zone.openmetadata_zone.zone_id
  name    = "stg.${var.domain_name}"
  type    = "NS"
  ttl     = 3600
  records = var.stg_ns_records
}

resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  tags = {
    Name = "${var.name_prefix}-acm-${var.region_short_name}-cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id         = aws_route53_zone.openmetadata_zone.zone_id
  name            = each.value.name
  type            = each.value.type
  records         = [each.value.record]
  ttl             = 60
  allow_overwrite = true
}

