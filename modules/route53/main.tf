resource aws_route53_zone "primary" {
  name = var.customer_domain

  lifecycle {
    prevent_destroy = true
  }
}

# this was imported
resource aws_acm_certificate "all_subdomains_certificate" {
  lifecycle {
    prevent_destroy = true
  }
}

# this was imported
resource aws_acm_certificate "main_domain_certificate" {
  lifecycle {
    prevent_destroy = true
  }
}
