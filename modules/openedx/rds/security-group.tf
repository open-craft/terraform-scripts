locals {
  tcp_3306_ingress_group_map = {
    for sg in var.security_group_ingress_access.tcp_3306 :
    sg.name => sg.id
  }
}

resource "aws_security_group" "rds" {
  name        = local.security_group_name
  description = local.security_group_description
  vpc_id      = var.aws_vpc_id
}

// Allow TCP 3306 for every group passed in via the variables

resource "aws_security_group_rule" "tcp_3306_ingress" {
  for_each = local.tcp_3306_ingress_group_map

  security_group_id        = aws_security_group.rds.id
  source_security_group_id = each.value
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
}

// Allow full egress access

resource "aws_security_group_rule" "all_egress" {
  security_group_id = aws_security_group.rds.id
  type              = "egress"
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  from_port         = 0
  to_port           = 0
}
