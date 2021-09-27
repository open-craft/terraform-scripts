locals {
  allow_prometheus_0_to_65535_ingress_groups = [
    aws_security_group.director,
    aws_security_group.edxapp_appserver
  ]

  allow_prometheus_0_to_65535_ingress_group_map = {
    for sg in local.allow_prometheus_0_to_65535_ingress_groups :
    sg.name => sg.id
  }
}

resource "aws_security_group" "allow_prometheus" {
  name        = local.allow_prometheus_security_group_name
  description = local.allow_prometheus_security_group_description
  vpc_id      = var.aws_vpc_id
}

resource "aws_security_group_rule" "allow_prometheus_monitoring_tcp_19100_ingress" {
  security_group_id        = aws_security_group.allow_prometheus.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 19100
  to_port                  = 19100
  cidr_blocks              = ["0.0.0.0/0"]
  ipv6_cidr_blocks         = ["::/0"]
}

/*
This group provides full IPv4 egress access,
and allows for inbound access on all ports
*/

resource "aws_security_group_rule" "allow_prometheus_tcp_0_to_65535_ingress" {
  for_each = local.allow_prometheus_0_to_65535_ingress_group_map

  security_group_id        = aws_security_group.allow_prometheus.id
  source_security_group_id = each.value
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 0
  to_port                  = 65535
}

resource "aws_security_group_rule" "allow_prometheus_udp_0_to_65535_ingress" {
  for_each = local.allow_prometheus_0_to_65535_ingress_group_map

  security_group_id        = aws_security_group.allow_prometheus.id
  source_security_group_id = each.value
  type                     = "ingress"
  protocol                 = "udp"
  from_port                = 0
  to_port                  = 65535
}

resource "aws_security_group_rule" "allow_prometheus_all_ipv4_egress" {
  security_group_id = aws_security_group.allow_prometheus.id
  type              = "egress"
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
}
