locals {
  tcp_22_ingress_groups = [
    var.director_security_group
  ]

  tcp_22_ingress_group_map = {
    for sg in local.tcp_22_ingress_groups :
    sg.name => sg.id
  }
}

resource "aws_security_group" "wordpress" {
  name        = local.security_group_name
  description = local.security_group_description
  vpc_id      = var.aws_vpc_id
}

resource "aws_security_group_rule" "tcp_22_ingress" {
  for_each = local.tcp_22_ingress_group_map

  security_group_id        = aws_security_group.wordpress.id
  source_security_group_id = each.value
  description              = "Allow SSH access from the ${title(var.environment)} ${each.key} security group"
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
}

resource "aws_security_group_rule" "tcp_80_ingress" {
  security_group_id = aws_security_group.wordpress.id
  description       = "Allow HTTP80 access inbound"
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 80
  to_port           = 80
}

resource "aws_security_group_rule" "tcp_19100_ingress" {
  description       = "Used by Prometheus to scrape node-exporter"
  security_group_id = aws_security_group.wordpress.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  from_port         = 19100
  to_port           = 19100
}

resource "aws_security_group_rule" "udp_8301_to_8302_ingress" {
  description       = "Used for consul gossip"
  security_group_id = aws_security_group.wordpress.id
  type              = "ingress"
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  from_port         = 8301
  to_port           = 8302
}

resource "aws_security_group_rule" "tcp_8301_to_8302_ingress" {
  description       = "Used for consul gossip"
  security_group_id = aws_security_group.wordpress.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  from_port         = 8301
  to_port           = 8302
}

resource "aws_security_group_rule" "all_ipv4_egress" {
  security_group_id = aws_security_group.wordpress.id
  type              = "egress"
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
}
