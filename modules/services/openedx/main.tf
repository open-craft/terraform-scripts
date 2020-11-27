resource aws_security_group edxapp {
  name = "${var.customer_name}-${var.environment}-edxapp"
}

resource aws_security_group_rule edxapp_inbound_rule {
  security_group_id = aws_security_group.edxapp.id
  type = "ingress"

  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource aws_security_group_rule edxapp-inbound-tcp-prometheus {
  type = "ingress"
  security_group_id = aws_security_group.edxapp.id

  from_port = local.prometheus_tcp_port
  to_port = local.prometheus_tcp_port
  protocol = local.tcp_protocol
  cidr_blocks = local.all_ips
}

resource aws_security_group_rule edxapp-inbound-udp-prometheus {
  type = "ingress"
  security_group_id = aws_security_group.edxapp.id

  from_port = local.prometheus_udp_port
  to_port = local.prometheus_udp_port
  protocol = local.udp_protocol
  cidr_blocks = local.all_ips
}

resource aws_security_group_rule edxapp-inbound-tcp-consul {
  type = "ingress"
  security_group_id = aws_security_group.edxapp.id

  from_port = local.consul_tcp_from_port
  to_port = local.consul_tcp_to_port
  protocol = local.tcp_protocol
  cidr_blocks = local.all_ips
}

resource aws_security_group_rule edxapp-inbound-udp-consul {
  type = "ingress"
  security_group_id = aws_security_group.edxapp.id

  from_port = local.consul_udp_from_port
  to_port = local.consul_udp_to_port
  protocol = local.udp_protocol
  cidr_blocks = local.all_ips
}

resource aws_security_group_rule edxapp_director_ssh_rule {
  security_group_id = aws_security_group.edxapp.id
  source_security_group_id = var.director_security_group_id
  type = "ingress"

  from_port = 22
  to_port = 22
  protocol = "tcp"
}

resource aws_security_group_rule edxapp_outbound_rule {
  security_group_id = aws_security_group.edxapp.id
  type = "egress"

  from_port = 0
  to_port = 0
  protocol = "all"
  cidr_blocks = ["0.0.0.0/0"]
}
