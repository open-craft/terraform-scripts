resource aws_route53_zone "primary" {
  name = var.customer_domain

  lifecycle {
    prevent_destroy = true
  }
}

resource aws_acm_certificate "all_subdomains_certificate" {
  domain_name = var.customer_domain
  validation_method = "DNS"

  lifecycle {
    prevent_destroy = true
  }
}

resource aws_acm_certificate "main_domain_certificate" {
  domain_name = "*.${var.customer_domain}"
  validation_method = "DNS"

  lifecycle {
    prevent_destroy = true
  }
}
