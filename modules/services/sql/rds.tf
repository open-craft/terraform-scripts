data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource aws_db_instance mysql_rds {
  identifier = "${var.customer_name}-${var.environment}-openedx"
  instance_class = var.instance_class
  engine = "mysql"
  engine_version = var.engine_version

  allocated_storage = var.allocated_storage
  storage_type = "gp2"
  backup_retention_period = 14

  publicly_accessible = false
  storage_encrypted = true
  kms_key_id = aws_kms_key.rds_encryption.arn
  auto_minor_version_upgrade = false
  multi_az = true

  deletion_protection = true

  username = var.database_root_username
  password = var.database_root_password

  db_subnet_group_name = aws_db_subnet_group.primary.name
  vpc_security_group_ids = [aws_security_group.rds.id]
}


## This is exactly the same as the master
resource aws_db_instance mysql_rds_replicas {
  count = var.number_of_replicas
  identifier = "${var.customer_name}-${var.environment}-openedx"
  instance_class = var.instance_class
  engine = "mysql"
  engine_version = var.engine_version

  allocated_storage = var.allocated_storage
  storage_type = "gp2"
  backup_retention_period = 14

  publicly_accessible = false
  storage_encrypted = true
  kms_key_id = aws_kms_key.rds_encryption.arn
  auto_minor_version_upgrade = false
  multi_az = true
  replicate_source_db = aws_db_instance.mysql_rds.arn

  deletion_protection = true

  username = var.database_root_username
  password = var.database_root_password

  db_subnet_group_name = aws_db_subnet_group.primary.name
  vpc_security_group_ids = [aws_security_group.rds.id]
}

resource aws_kms_key rds_encryption {
  description = "KMS RDS Encryption"
}

resource aws_db_subnet_group primary {
  name = "${var.customer_name}-${var.environment}-openedx"
  subnet_ids = data.aws_subnet_ids.default.ids
}

resource aws_security_group rds {
  name = "${var.customer_name}-${var.environment}-edxapp-rds"
}

resource aws_security_group_rule rds-outbound-rule {
  security_group_id = aws_security_group.rds.id
  type = "egress"
  protocol = "all"
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]

  from_port = 0
  to_port = 0
}

resource aws_security_group_rule rds-inbound-rule {
  type = "ingress"
  security_group_id = aws_security_group.rds.id
  source_security_group_id = var.edxapp_security_group_id

  protocol = "tcp"
  from_port = 3306
  to_port = 3306
}
