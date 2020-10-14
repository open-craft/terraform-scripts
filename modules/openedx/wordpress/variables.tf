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
  description = "The ID of the AWS VPC that should contain the wordpress resources"
  type        = string
}

### Security Group Settings ###############################

variable "director_security_group" {
  description = "A the director security group"
  type = object({
    id   = string
    name = string
  })
}

### Load Balancer Settings ################################

/*
NOTE: Do we want to require this variable be submitted, as opposed
to setting up an entirely new load balancer for this module,
thus removing external dependencies?
*/
variable "application_load_balancer_arn" {
  description = "The ARN of the application load balancer that will be directing traffic to wordpress"
  type        = string
}

### RDS Required Settings #################################

variable "rds_instance_class" {
  description = "The machine class to use for the RDS MySQL instance"
  type        = string
}

variable "rds_mysql_engine_version" {
  description = "The version of the MySQL engine to use"
  type        = string
}

variable "rds_username" {
  description = "The root username for the RDS instance"
  type        = string
}

variable "rds_password" {
  description = "The password for the root user for the RDS instance"
  type        = string
}

variable "rds_allocated_storage" {
  description = "The amount of storage to allocate to the RDS instance. This value is in GiB (2^30 bytes)"
  type        = number
}

### RDS Optional Settings #################################

variable "rds_storage_type" {
  description = "The type of database storage to use. Can be one of 'standard', 'gp2' or 'iops'"
  type        = string
  default     = "gp2"
}

variable "rds_storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = true
}

variable "rds_backup_retention_period" {
  description = "The number of days to retain backups for. Must be between 0 and 35"
  type        = number
  default     = 14
}

variable "rds_auto_minor_version_upgrade" {
  description = "Indicates whether minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  type        = bool
  default     = false
}

variable "rds_multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}

variable "rds_publicly_accessible" {
  description = "Controls if instance is publicly accessible"
  type        = bool
  default     = false
}

### DEPRECATED ############################################
#   DO NOT USE THESE VARIABLES WITH NEW INFRASTRUCTURE

variable "deprecated_lb_target_group_name" {
  description = "DEPRECATED - Use client_shortname and environment. Overwrites the lb target group name"
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
  lb_target_group_name = coalesce(
    var.deprecated_lb_target_group_name,
    lower(join("-", [var.client_shortname, "wordpress", var.environment]))
  )
  security_group_name = coalesce(
    var.deprecated_security_group_name,
    lower(join("-", [var.client_shortname, "wordpress", var.environment]))
  )

  default_sg_description = "Security group for the ${title(var.environment)} Wordpress servers"
  security_group_description = coalesce(
    var.deprecated_security_group_description,
    local.default_sg_description
  )
}
