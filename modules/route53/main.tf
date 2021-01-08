resource aws_route53_zone "primary" {
  name = var.customer_domain
}

resource aws_acm_certificate "main_domain_certificate" {
  count = var.enable_acm_validation ? 1 : 0

  domain_name = "*.${var.customer_domain}"
  validation_method = "DNS"
  subject_alternative_names = [var.customer_domain]
}

resource aws_route53_record "main_domain_validation_records" {
  for_each = {
    for dvo in (var.enable_acm_validation ? aws_acm_certificate.main_domain_certificate.domain_validation_options : []) : dvo.domain_name => {
      name = dvo.resource_record_name
      record = dvo.resource_record_value
      type = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  zone_id = aws_route53_zone.primary.zone_id
  name = each.value.name
  type = each.value.type
  ttl = "60"
  records = [
    each.value.record
  ]
}

resource "aws_acm_certificate_validation" "main_domain_validation" {
  count = var.enable_acm_validation ? 1 : 0

  certificate_arn = aws_acm_certificate.main_domain_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.main_domain_validation_records : record.fqdn]
}
