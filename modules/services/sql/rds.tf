locals {
  vpc_id = var.specific_vpc_id != "" ? var.specific_vpc_id : data.aws_vpc.default[0].id
}

data "aws_vpc" "default" {
  default = true
  count = length(var.specific_subnet_ids) > 0 ? 0 : 1
}

data "aws_subnet_ids" "default" {
  vpc_id = local.vpc_id
  count = length(var.specific_subnet_ids) > 0 ? 0 : 1
}

resource aws_db_subnet_group primary {
  name = "${var.customer_name}-${var.environment}-openedx"
  subnet_ids = tolist(data.aws_subnet_ids.default[0].ids)
  count = var.specific_subnet_group_name == "" ? 1 : 0
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
  multi_az = var.enable_multi_az

  deletion_protection = true

  username = var.database_root_username
  password = var.database_root_password

  db_subnet_group_name = var.specific_subnet_group_name != "" ? var.specific_subnet_group_name : aws_db_subnet_group.primary[0].name
  vpc_security_group_ids = concat([aws_security_group.rds.id], var.extra_security_group_ids)

  max_allocated_storage = var.max_allocated_storage
}


## This is exactly the same as the master
resource aws_db_instance mysql_rds_replicas {
  count = var.number_of_replicas
  identifier = "${var.customer_name}-${var.environment}-openedx-replica-${count.index}"
  instance_class = var.instance_class
  engine_version = var.engine_version

  storage_type = "gp2"
  backup_retention_period = 5

  publicly_accessible = var.replica_publicly_accessible
  storage_encrypted = true
  kms_key_id = aws_kms_key.rds_encryption.arn
  auto_minor_version_upgrade = false
  multi_az = var.enable_replica_multi_az
  replicate_source_db = aws_db_instance.mysql_rds.identifier
  vpc_security_group_ids = concat(concat([aws_security_group.rds.id], var.extra_security_group_ids), var.replica_extra_security_group_ids)

  skip_final_snapshot = true

  max_allocated_storage = var.max_allocated_storage
  parameter_group_name = aws_db_parameter_group.uq_daas_replica.name
}

resource "aws_db_parameter_group" "uq_daas_replica" {
  name        = "uq-replicas-parameters"
  description = "Extra parameters required for DaaS team to use Qlic tool with replicas"
  family      = "mysql5.7"

  parameter {
    name         = "binlog_checksum"
    value        = "CRC32"
  }
  parameter {
    name         = "binlog_format"
    value        = "row"
  }
  parameter {
    name         = "binlog_row_image"
    value        = "full"
  }
}

resource aws_kms_key rds_encryption {
  description = "KMS RDS Encryption"
}

resource aws_security_group rds {
  name = "${var.customer_name}-${var.environment}-edxapp-rds"
  vpc_id = var.specific_vpc_id
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
