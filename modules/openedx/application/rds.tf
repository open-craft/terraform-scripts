module "rds" {
  source = "../rds"

  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  aws_region     = var.aws_region

  instance_name    = "edxapp"
  client_shortname = var.client_shortname
  environment      = var.environment

  aws_vpc_id = var.aws_vpc_id

  instance_class       = var.rds_instance_class
  mysql_engine_version = var.rds_mysql_engine_version
  username             = var.rds_username
  password             = var.rds_password
  allocated_storage    = var.rds_allocated_storage

  storage_type               = var.rds_storage_type
  storage_encrypted          = var.rds_storage_encrypted
  backup_retention_period    = var.rds_backup_retention_period
  auto_minor_version_upgrade = var.rds_auto_minor_version_upgrade
  multi_az                   = var.rds_multi_az
  publicly_accessible        = var.rds_publicly_accessible

  // Give inbound access to the director and appserver security groups
  security_group_ingress_access = {
    tcp_3306 = [
      aws_security_group.director,
      aws_security_group.edxapp_appserver
    ]
  }

  // Deprecated - do not use these anymore
  deprecated_db_subnet_group_name       = var.deprecated_db_subnet_group_name
  deprecated_db_instance_name           = var.deprecated_db_instance_name
  deprecated_security_group_name        = var.deprecated_rds_security_group_name
  deprecated_security_group_description = var.deprecated_rds_security_group_description
}
