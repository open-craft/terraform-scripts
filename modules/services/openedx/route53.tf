data aws_route53_zone "route53_zone" {
  name = "${var.customer_domain}."
  private_zone = false
}

locals {
  subdomains = [
    "www",
    "preview",
    "studio",
    "ecommerce",
    "discovery",
  ]
}

resource aws_route53_record "subdomain_lb_record" {
  count = length(local.subdomains)
  zone_id = data.aws_route53_zone.route53_zone.zone_id
  name = "${local.subdomains[count.index]}.${data.aws_route53_zone.route53_zone.name}"
  type = "A"

  alias {
    evaluate_target_health = false
    name = aws_lb.edxapp.dns_name
    zone_id = aws_lb.edxapp.zone_id
  }
}

resource aws_route53_record "main_domain_lb_record" {
  zone_id = data.aws_route53_zone.route53_zone.zone_id
  name = data.aws_route53_zone.route53_zone.name
  type = "A"

  alias {
    evaluate_target_health = false
    name = aws_lb.edxapp.dns_name
    zone_id = aws_lb.edxapp.zone_id
  }
}
