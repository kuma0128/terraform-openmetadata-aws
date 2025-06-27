resource "aws_lb" "this" {
  name                       = "${var.name_prefix}-alb-${var.region_short_name}"
  load_balancer_type         = "application"
  drop_invalid_header_fields = true
  security_groups            = [var.openmetadata_lb_security_group_id]
  subnets = [
    var.subnet_a_public_id,
    var.subnet_c_public_id
  ]
}

resource "aws_lb_target_group" "to_openmetadata" {
  name                          = "openmetadata-tg"
  port                          = 8585
  protocol                      = "HTTP"
  vpc_id                        = var.vpc_id
  target_type                   = "ip"
  load_balancing_algorithm_type = "least_outstanding_requests"
  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400
    enabled         = true
  }
}

resource "aws_lb_listener" "from_https" {
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.cert_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.to_openmetadata.arn
  }
}

resource "aws_route53_record" "alb_a_record" {
  zone_id = var.route53_zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}