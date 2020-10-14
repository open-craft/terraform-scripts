/*
Given a list of security groups, get a map of
the security group name to the security group id
*/
locals {
  edxapp_tcp_22_ingress_groups = [
    aws_security_group.director
  ]

  edxapp_tcp_22_ingress_group_map = {
    for sg in local.edxapp_tcp_22_ingress_groups :
    sg.name => sg.id
  }
}

resource "aws_security_group" "edxapp_appserver" {
  name        = local.application_security_group_name
  description = local.application_security_group_description
  vpc_id      = var.aws_vpc_id
}

// SSH Inbound access for specific security groups

resource "aws_security_group_rule" "edxapp_tcp_22_ingress" {
  for_each = local.edxapp_tcp_22_ingress_group_map

  security_group_id        = aws_security_group.edxapp_appserver.id
  source_security_group_id = each.value
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
}

// HTTP and HTTPS inbound requests for any IP

resource "aws_security_group_rule" "edxapp_tcp_80_ingress" {
  security_group_id = aws_security_group.edxapp_appserver.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  from_port         = 80
  to_port           = 80
}

resource "aws_security_group_rule" "edxapp_tcp_443_ingress" {
  security_group_id = aws_security_group.edxapp_appserver.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  from_port         = 443
  to_port           = 443
}

// Give the Node Exporter inbound access on 19100 for all IPs

resource "aws_security_group_rule" "edxapp_tcp_19100_ingress" {
  description       = "Node Exporter"
  security_group_id = aws_security_group.edxapp_appserver.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  from_port         = 19100
  to_port           = 19100
}

// Grant 8301 to 8302 on TCP and UDP for Consul Gossip

resource "aws_security_group_rule" "edxapp_udp_8301_to_8302_ingress" {
  description       = "Consul Gossip"
  security_group_id = aws_security_group.edxapp_appserver.id
  type              = "ingress"
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  from_port         = 8301
  to_port           = 8302
}

resource "aws_security_group_rule" "edxapp_tcp_8301_to_8302_ingress" {
  description       = "Consul Gossip"
  security_group_id = aws_security_group.edxapp_appserver.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  from_port         = 8301
  to_port           = 8302
}

// All full egress access

resource "aws_security_group_rule" "edxapp_all_ipv4_egress" {
  security_group_id = aws_security_group.edxapp_appserver.id
  type              = "egress"
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
}
