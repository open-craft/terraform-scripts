### Provider Configurations ####################################

variable "aws_access_key" {
  description = "The AWS Access Key issued for API access"
  type        = string
}

variable "aws_secret_key" {
  description = "The AWS Secret Key issued for API access"
  type        = string
}

variable "aws_region" {
  description = "The AWS Region in which to deploy the resources"
  type        = string
}

### General Settings ######################################

variable "instance_name" {
  description = "A short tag name for the purpose of this instance that will be used in naming resources"
  type        = string
}

variable "client_shortname" {
  description = "A short tag name for the client that will be used in naming resources"
  type        = string
}

variable "environment" {
  description = "The environment name for this deployment"
  type        = string
}

### AWS VPC Settings ######################################

variable "aws_vpc_id" {
  description = "The ID of the AWS VPC that should contain all of the resources"
  type        = string
}

### RDS Required Settings #################################

variable "instance_class" {
  description = "The machine class to use for the instance"
  type        = string
}

variable "mysql_engine_version" {
  description = "The version of the MySQL engine to use"
  type        = string
}

variable "username" {
  description = "The root username for the RDS instance"
  type        = string
}

variable "password" {
  description = "The password for the root user for the RDS instance"
  type        = string
}

variable "allocated_storage" {
  description = "The amount of storage to allocate to the RDS instance. This value is in GiB (2^30 bytes)"
  type        = number
}

### RDS Optional Settings #################################

variable "storage_type" {
  description = "The type of database storage to use. Can be one of 'standard', 'gp2' or 'iops'"
  type        = string
  default     = "gp2"
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = true
}

variable "backup_retention_period" {
  description = "The number of days to retain backups for. Must be between 0 and 35"
  type        = number
  default     = 14
}

variable "auto_minor_version_upgrade" {
  description = "Indicates whether minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  type        = bool
  default     = false
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}

variable "publicly_accessible" {
  description = "Controls if instance is publicly accessible"
  type        = bool
  default     = false
}

### Security Group Settings ###############################

variable "security_group_ingress_access" {
  description = "A mapping of protocol/port to the security group objects that will receive ingress access on that protocol/port"

  type = object({
    tcp_3306 = list(object({
      id   = string
      name = string
    }))
  })
}

### DEPRECATED ############################################
#   DO NOT USE THESE VARIABLES WITH NEW INFRASTRUCTURE

/*
This is specifically to support KKUx having legacy names for
resources that would require being recreated upon a name change
*/
variable "deprecated_db_subnet_group_name" {
  description = "DEPRECATED - Use client_shortname and environment. Overwrites the db subnet group name"
  type        = string
  default     = null
}

variable "deprecated_db_instance_name" {
  description = "DEPRECATED - Use client_shortname and environment. Overwrites the rds instance name"
  type        = string
  default     = null
}

variable "deprecated_security_group_name" {
  description = "DEPRECATED - Use client_shortname and environment. Overwrites the security group name"
  type        = string
  default     = null
}

variable "deprecated_security_group_description" {
  description = "DEPRECATED - Use environment. Overwrites the security group description"
  type        = string
  default     = null
}

### Locals ################################################

locals {
  // Properly bound backup_retention_period between 0 and 35
  backup_retention_period = max(min(var.backup_retention_period, 35), 0)

  // Apply deprecated overrides
  db_subnet_group_name = coalesce(
    var.deprecated_db_subnet_group_name,
    lower(join("-", [var.client_shortname, var.instance_name, var.environment]))
  )
  db_instance_name = coalesce(
    var.deprecated_db_instance_name,
    lower(join("-", [var.client_shortname, var.instance_name, var.environment]))
  )
  security_group_name = coalesce(
    var.deprecated_security_group_name,
    lower(join("-", [var.client_shortname, var.instance_name, "rds", var.environment]))
  )

  default_sg_description = "Security group for the ${title(var.environment)} ${title(var.instance_name)} RDS Instance"
  security_group_description = coalesce(
    var.deprecated_security_group_description,
    local.default_sg_description
  )
}
