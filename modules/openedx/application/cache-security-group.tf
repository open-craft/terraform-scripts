locals {
  cache_0_to_65535_ingress_groups = [
    aws_security_group.director,
    aws_security_group.edxapp_appserver
  ]

  cache_0_to_65535_ingress_group_map = {
    for sg in local.cache_0_to_65535_ingress_groups :
    sg.name => sg.id
  }
}

// Manages access to the ElastiCache clusters

resource "aws_security_group" "cache" {
  name        = local.cache_security_group_name
  description = local.cache_security_group_description
  vpc_id      = var.aws_vpc_id
}

/*
This group provides full IPv4 egress access,
and allows for inbound access on all ports
*/

resource "aws_security_group_rule" "cache_tcp_0_to_65535_ingress" {
  for_each = local.cache_0_to_65535_ingress_group_map

  security_group_id        = aws_security_group.cache.id
  source_security_group_id = each.value
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 0
  to_port                  = 65535
}

resource "aws_security_group_rule" "cache_udp_0_to_65535_ingress" {
  for_each = local.cache_0_to_65535_ingress_group_map

  security_group_id        = aws_security_group.cache.id
  source_security_group_id = each.value
  type                     = "ingress"
  protocol                 = "udp"
  from_port                = 0
  to_port                  = 65535
}

resource "aws_security_group_rule" "cache_all_ipv4_egress" {
  security_group_id = aws_security_group.cache.id
  type              = "egress"
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
}
