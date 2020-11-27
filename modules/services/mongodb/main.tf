resource aws_instance "mongodb" {
  count = var.number_of_instances
  ami = var.image_id
  instance_type = var.instance_type

  root_block_device {
    volume_type = "gp2"
    volume_size = 100
  }

  vpc_security_group_ids = [aws_security_group.security_group.id]
  key_name = var.openedx_key_pair_name
  user_data = file("scripts/install_mongodb.sh")

  tags = {
    Name = format("${var.customer_name}-${var.environment}-mongodb-%s", count.index > 0 ? join("-", [
      "secondary",
      tostring(count.index)]) : "primary")
  }
}

resource aws_security_group "security_group" {
  name = "${var.customer_name}-${var.environment}-edxapp-mongodb"
}

resource aws_security_group_rule "mongodb_edxapp_ingress_rule_1" {
  security_group_id = aws_security_group.security_group.id
  source_security_group_id = var.edxapp_security_group_id
  type = "ingress"

  from_port = 27017
  to_port = 27017
  protocol = "tcp"
}

resource aws_security_group_rule "mongodb_edxapp_ingress_rule_2" {
  security_group_id = aws_security_group.security_group.id
  source_security_group_id = var.edxapp_security_group_id
  type = "ingress"

  from_port = 27019
  to_port = 27019
  protocol = "tcp"
}

resource aws_security_group_rule "mongodb_edxapp_ingress_ssh_rule" {
  security_group_id = aws_security_group.security_group.id
  source_security_group_id = var.edxapp_security_group_id
  type = "ingress"

  from_port = 22
  to_port = 22
  protocol = "tcp"
}

resource aws_security_group_rule "mongodb_egress_rule" {
  security_group_id = aws_security_group.security_group.id
  type = "egress"

  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource aws_security_group_rule "mongodb_replica_connection_inbound_rule" {
  security_group_id = aws_security_group.security_group.id
  source_security_group_id = aws_security_group.security_group.id
  type = "ingress"
  protocol = "-1"
  from_port = 0
  to_port = 0
}

resource aws_security_group_rule "mongodb_replica_connection_outbound_rule" {
  security_group_id = aws_security_group.security_group.id
  source_security_group_id = aws_security_group.security_group.id
  type = "egress"
  protocol = "-1"
  from_port = 0
  to_port = 0
}