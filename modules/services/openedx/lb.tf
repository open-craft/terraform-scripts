data aws_vpc "default" {
  default = true
}

data aws_subnet_ids "default" {
  vpc_id = data.aws_vpc.default.id
}

data aws_acm_certificate "customer_subdomains_certificate_arn" {
  domain = "*.${var.customer_domain}"
  statuses = ["ISSUED", "PENDING_VALIDATION"]
  most_recent = true
}

resource aws_lb edxapp {
  name = "${var.customer_name}-${var.environment}-edxapp"
  load_balancer_type = "application"
  subnets = data.aws_subnet_ids.default.ids
  security_groups = [aws_security_group.lb.id]

  idle_timeout = var.lb_idle_timeout
}

resource aws_lb_target_group edxapp {
  port = 80
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default.id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource aws_lb_listener "https" {
  count = var.enable_https ? 1 : 0
  load_balancer_arn = aws_lb.edxapp.arn
  port = local.https_port
  protocol = "HTTPS"

  ssl_policy = var.lb_ssl_security_policy
  certificate_arn = data.aws_acm_certificate.customer_subdomains_certificate_arn.arn


  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.edxapp.arn
  }
}

resource aws_lb_listener redirect_http_to_https {
  count = var.enable_https ? 1 : 0
  load_balancer_arn = aws_lb.edxapp.arn
  port = local.http_port
  protocol = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource aws_lb_listener http {
  count = var.enable_https ? 0 : 1
  load_balancer_arn = aws_lb.edxapp.arn
  port = local.http_port
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.edxapp.arn
  }
}

resource aws_security_group lb {
  name = "${var.customer_name}-${var.environment}-edxapp-lb"
}

resource aws_security_group_rule lb-inbound-http {
  type = "ingress"
  security_group_id = aws_security_group.lb.id

  from_port = local.http_port
  to_port = local.http_port
  protocol = local.tcp_protocol
  cidr_blocks = local.all_ips
}

resource aws_security_group_rule lb-inbound-https {
  type = "ingress"
  security_group_id = aws_security_group.lb.id

  from_port = local.https_port
  to_port = local.https_port
  protocol = local.tcp_protocol
  cidr_blocks = local.all_ips
}

resource aws_security_group_rule lb-inbound-cms {
  type = "ingress"
  security_group_id = aws_security_group.lb.id

  from_port = local.cms_port
  to_port = local.cms_port
  protocol = local.tcp_protocol
  cidr_blocks = local.all_ips
}

resource aws_security_group_rule lb-inbound-tcp-prometheus {
  type = "ingress"
  security_group_id = aws_security_group.lb.id

  from_port = local.prometheus_tcp_port
  to_port = local.prometheus_tcp_port
  protocol = local.tcp_protocol
  cidr_blocks = local.all_ips
}

resource aws_security_group_rule lb-inbound-tcp-consul {
  type = "ingress"
  security_group_id = aws_security_group.lb.id

  from_port = local.consul_tcp_from_port
  to_port = local.consul_tcp_to_port
  protocol = local.tcp_protocol
  cidr_blocks = local.all_ips
}

resource aws_security_group_rule lb-inbound-udp-consul {
  type = "ingress"
  security_group_id = aws_security_group.lb.id

  from_port = local.consul_udp_from_port
  to_port = local.consul_udp_to_port
  protocol = local.udp_protocol
  cidr_blocks = local.all_ips
}

resource aws_security_group_rule lb-outbound {
  type = "egress"
  security_group_id = aws_security_group.lb.id

  from_port = local.any_port
  to_port = local.any_port
  protocol = local.any_protocol
  cidr_blocks = local.all_ips
}

// XXX: This does not work since our load balancer type is "application" and
// those do not allow custom policies. This might work if we changed to
// "network" but that would need testing. Will definitely work with an "elastic"
// load balancer. Both options require a large reorganization of our modules.

// The following security negotiation policies are added to the list of
// predefined policies that may be used by listeners attached to the load
// balancer. To use one of these for your edxapp, set
// `var.lb_ssl_security_policy` to its name.

resource aws_lb_ssl_negotiation_policy edxapp-tls-1-2-no-cbc {

  name          = "edXappSecurityPolicy-TLS-1-2-No-CBC"

  load_balancer = aws_lb.edxapp.id

  lb_port       = 443

  // Only allow TLSv1.2 and above

  attribute {
    name  = "Protocol-TLSv1"
    value = "false"
  }

  attribute {
    name  = "Protocol-TLSv1.1"
    value = "false"
  }

  attribute {
    name  = "Protocol-TLSv1.2"
    value = "true"
  }

  // exclude weak CBC policies

  attribute {
    name  = "ECDHE-RSA-AES256-GCM-SHA384"
    value = "true"
  }

  attribute {
    name  = "ECDHE-RSA-AES128-GCM-SHA256"
    value = "true"
  }

  attribute {
    name  = "DHE-RSA-AES256-GCM-SHA384"
    value = "true"
  }

  attribute {
    name  = "DHE-RSA-AES128-GCM-SHA256"
    value = "true"
  }

  attribute {
    name  = "AES256-GCM-SHA256"
    value = "true"
  }

  attribute {
    name  = "AES128-GCM-SHA256"
    value = "true"
  }
}
