
# /*
#   **Note: Don't need to manually create A record if using ExternalDNS
# */
# resource "aws_route53_record" "my_A_record" {
#   zone_id = aws_route53_zone.primary.zone_id
#   name    = "tracker.robs-portfolio.com"
#   type    = "A"
#   ttl     = 300
#   records = [aws_eip.lb.public_ip]
#   /*To do:

#     Record should point to ALB created by ingress controller.
#     This will require a data source to look it up with a tag

#   */
# }


/*
  **Note: Type "resource" is used to create something that didn't exist before
    - Terraform managed

          Type "data" is used for an existing resource simply to reference it elsewhere
    - Not Terraform managed
*/
// This data resource fetches what ever the Route 53 Zone name is
data "aws_route53_zone" "primary_domain_name" {
  name         = "robs-portfolio.com"
  private_zone = false
}

// Route53 records for ACM cert ownership validation 
resource "aws_route53_record" "ACM_ownership_CNAME_records" {

  zone_id = data.aws_route53_zone.primary_domain_name.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60

  for_each = {
    for dvo in aws_acm_certificate.tracker_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }
}

// ACM Certificate
resource "aws_acm_certificate" "tracker_cert" {
  domain_name       = "tracker.robs-portfolio.com"
  validation_method = "DNS"

  tags = {
    Environment = "dev"
    Terraform   = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "tracker_cert_valid" {
  certificate_arn = aws_acm_certificate.tracker_cert.arn

  // Fully Quialified Domain Name:
  /*
     **Note: when creating acm cert, multiple CNAMES records for that domain name
     This line of code simply validates all the CNAME records
  */
  validation_record_fqdns = [for record in aws_route53_record.ACM_ownership_CNAME_records : record.fqdn]
} 