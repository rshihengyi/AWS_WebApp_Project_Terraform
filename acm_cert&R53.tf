resource "aws_acm_certificate" "simple_cert" {
  domain_name       = "dev.robs-portfolio.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "dev_cert_validation" {
  certificate_arn         = aws_acm_certificate.simple_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.dev_DNS_record : record.fqdn]
}

data "aws_route53_zone" "dev_robs_portfolio" {
  name         = "robs-portfolio.com"
  private_zone = false
}

/* A and CNAME records for dev.robs-portfolio.com */

resource "aws_route53_record" "dev_A_record" {
  alias {
    name                   = aws_alb.lb_web.dns_name
    zone_id                = aws_alb.lb_web.zone_id
    evaluate_target_health = true
  }

  zone_id = data.aws_route53_zone.dev_robs_portfolio.zone_id
  name    = "dev.robs-portfolio.com"
  type    = "A"
}

resource "aws_route53_record" "dev_DNS_record" {

  zone_id = data.aws_route53_zone.dev_robs_portfolio.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60

  for_each = {
    for dvo in aws_acm_certificate.simple_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }
}
