/**
This file contains the setup for load balancers and ec2 instances.
Some assumptions:
- Route53 Hosted Zone already exists for the main domain
- Resources were setup and working in the default VPC
- SSL Certificates are setup and we are enabling https for Analytics (TODO: also support http?)
**/

data aws_route53_zone hosted_zone {
  name = var.hosted_zone_domain
}

data aws_vpc "default" {
  default = true
}

data aws_subnet_ids "default" {
  vpc_id = data.aws_vpc.default.id
}

data aws_acm_certificate "customer_subdomains_certificate_arn" {
  domain = "*.${var.hosted_zone_domain}"
  statuses = ["ISSUED", "PENDING_VALIDATION"]
  most_recent = true
}


resource "aws_lb" "analytics_lb" {
  name = "${var.customer_name}-${var.environment}-lb"
  load_balancer_type = "application"
  subnets = data.aws_subnet_ids.default.ids
  security_groups = [aws_security_group.analytics.id]
}

resource "aws_lb_target_group" "analytics_lb_target_group" {
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

resource aws_lb_target_group_attachment edxapp {
  count = length(var.lb_instance_indexes)
  target_group_arn = aws_lb_target_group.analytics_lb_target_group.arn
  target_id = aws_instance.analytics[var.lb_instance_indexes[count.index]].id
  port = 80

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.analytics_lb.arn
  port = 443
  protocol = "HTTPS"

  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = data.aws_acm_certificate.customer_subdomains_certificate_arn.arn

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.analytics_lb_target_group.arn
  }
}

resource "aws_lb_listener" "redirect_http_to_https" {
  load_balancer_arn = aws_lb.analytics_lb.arn
  port = 80
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

resource "aws_route53_record" "analytics" {
  name = "insights.${var.hosted_zone_domain}"
  type = "A"
  zone_id = data.aws_route53_zone.hosted_zone.zone_id

  alias {
    evaluate_target_health = false
    name = aws_lb.analytics_lb.dns_name
    zone_id = aws_lb.analytics_lb.zone_id
  }
}

resource "aws_security_group" "analytics" {
  name = var.analytics_identifier
}

resource "aws_security_group_rule" "analytics-inbound-http" {
  type = "ingress"
  security_group_id = aws_security_group.analytics.id

  from_port = local.http_port
  to_port = local.http_port
  protocol = local.tcp_protocol
  cidr_blocks = local.all_ips
}

resource "aws_security_group_rule" "analytics-inbound-https" {
  type = "ingress"
  security_group_id = aws_security_group.analytics.id

  from_port = local.https_port
  to_port = local.https_port
  protocol = local.tcp_protocol
  cidr_blocks = local.all_ips
}

resource "aws_security_group_rule" "analytics-inbound-ssh" {
  type = "ingress"
  security_group_id = aws_security_group.analytics.id
  source_security_group_id = var.director_security_group_id

  from_port = local.ssh_port
  to_port = local.ssh_port
  protocol = local.tcp_protocol
}

resource "aws_security_group_rule" "analytics-director-inbound-jenkins" {
  type = "ingress"
  security_group_id = aws_security_group.analytics.id
  source_security_group_id = var.director_security_group_id

  from_port = local.jenkins_port
  to_port = local.jenkins_port
  protocol = local.tcp_protocol
}

resource "aws_security_group_rule" "analytics-outbound" {
  type = "egress"
  security_group_id = aws_security_group.analytics.id

  from_port = local.any_port
  to_port = local.any_port
  protocol = local.any_protocol
  cidr_blocks = local.all_ips
}

######################################################
resource "aws_instance" "analytics" {
  count = var.number_of_instances
  ami = var.analytics_image_id
  instance_type = var.analytics_instance_type
  vpc_security_group_ids = [aws_security_group.analytics.id]

  iam_instance_profile = aws_iam_instance_profile.provision-role-instance-profile.name

  key_name = var.analytics_key_pair_name

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
  }

  tags = {
    Name = "analytics-${var.instance_iteration}"
  }
}
