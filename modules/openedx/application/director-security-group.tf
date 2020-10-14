resource "aws_security_group" "director" {
  name        = local.director_security_group_name
  description = local.director_security_group_description
  vpc_id      = var.aws_vpc_id
}

// Allow SSH inbound to the director

resource "aws_security_group_rule" "director_tcp_22_ingress" {
  security_group_id = aws_security_group.director.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  from_port         = 22
  to_port           = 22
}

// Allow full egress for the director

resource "aws_security_group_rule" "director_all_ipv4_egress" {
  security_group_id = aws_security_group.director.id
  type              = "egress"
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
}
