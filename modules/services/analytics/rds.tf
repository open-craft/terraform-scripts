resource "aws_security_group" "emr-rds" {
  name = "EMR RDS"
}

resource "aws_security_group_rule" "emr-rds-master-inbound" {
  type = "ingress"
  security_group_id = aws_security_group.emr-rds.id
  source_security_group_id = aws_security_group.emr-master.id

  from_port = var.edxapp_rds_port
  to_port = var.edxapp_rds_port
  protocol = local.tcp_protocol
}

resource "aws_security_group_rule" "emr-rds-slave-inbound" {
  type = "ingress"
  security_group_id = aws_security_group.emr-rds.id
  source_security_group_id = aws_security_group.emr-slave.id

  from_port = var.edxapp_rds_port
  to_port = var.edxapp_rds_port
  protocol = local.tcp_protocol
}
