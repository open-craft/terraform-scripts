resource "aws_db_subnet_group" "primary" {
  name       = local.db_subnet_group_name
  subnet_ids = data.aws_subnet_ids.subnets.ids
}

resource "aws_kms_key" "rds_encryption" {
  description = "${title(var.instance_name)} ${var.environment} RDS Encryption"
}

resource "aws_db_instance" "database" {
  identifier     = local.db_instance_name
  instance_class = var.instance_class
  engine         = "mysql"
  engine_version = var.mysql_engine_version

  allocated_storage       = var.allocated_storage
  storage_type            = var.storage_type
  backup_retention_period = local.backup_retention_period

  publicly_accessible    = var.publicly_accessible
  storage_encrypted      = var.storage_encrypted
  kms_key_id             = aws_kms_key.rds_encryption.arn
  db_subnet_group_name   = aws_db_subnet_group.primary.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  username = var.username
  password = var.password

  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  multi_az                   = var.multi_az

  deletion_protection = true
}
