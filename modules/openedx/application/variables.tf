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

variable "mongodbatlas_project_id" {
  description = "The ID of the MongoDB Atlas Project in which the MongoDB resources will reside"
  type        = string
}

variable "mongodbatlas_public_key" {
  description = "The MongoDB Atlas public key issued for API access"
  type        = string
}

variable "mongodbatlas_private_key" {
  description = "The MongoDB Atlas private key issued for API access"
  type        = string
}

### General Settings ######################################

variable "client_shortname" {
  description = "A short tag name for the client that will be used in naming resources"
  type        = string
}

variable "environment" {
  description = "The environment name for this deployment (e.g. stage, prod)"
  type        = string
}

### AWS VPC Settings ######################################

// The VPC is created automatically by code in the secret repo.
// TODO: Port VPC creation code to application module.
variable "aws_vpc_id" {
  description = "The ID of the AWS VPC that should contain all of the resources"
  type        = string
}

// Required in order to set up elasticache clusters inside a VPC.
variable "subnet_ids" {
  description = "A list of subnet ids from the VPC"
  type        = list(string)
}

// For now, the ACM Certificate must be created manually.
// In the future we may wish to add Terraform code to create the Certificate.
variable "aws_acm_certificate_domain" {
  description = "The domain for which the AWS ACM Certificate has been issued"
  type        = string
}

### Memcached Required Settings ###########################

variable "memcached_node_type" {
  description = "The type of node to use for the ElastiCache Memcached deployment"
  type        = string
}

variable "memcached_num_cache_nodes" {
  description = "The number of nodes to use for the ElastiCache Memcached deployment"
  type        = number
}

### Memcached Optional Settings ###########################

variable "memcached_engine_version" {
  description = "The engine version for the ElastiCache Memcached deployment"
  type        = string
  default     = "1.5.16"
}

variable "memcached_parameter_group_name" {
  description = "The parameter group name for the ElastiCache Memcached deployment"
  type        = string
  default     = "default.memcached1.5"
}

variable "memcached_port" {
  description = "The port to use for the ElastiCache Memcached deployment"
  type        = number
  default     = 11211

}

### Mongo DB Required Settings ############################

variable "mongodb_instance_size" {
  description = "The instance size for the MongoDB cluster"
  type        = string
}

variable "mongodb_disk_size_gb" {
  description = "The amount of storage to allocate to the MongoDB cluster"
  type        = number
}

### Mongo DB Optional Settings ############################

variable "mongodb_version" {
  description = "The version of MongoDB to deploy"
  type        = string
  default     = "4.0"
}

variable "mongodb_num_shards" {
  description = "The total number of shards for the MongoDB deployment"
  type        = number
  default     = 1
}

variable "mongodb_replication_factor" {
  description = "Number of replica set members for the MongoDB cluster. Each member keeps a copy of your databases, providing high availability and data redundancy. The possible values are 3, 5, or 7"
  type        = number
  default     = 3
}

variable "mongodb_disk_iops" {
  description = "Indicates the maximum input/output operations per second (IOPS) the system can perform. The possible values are provider dependent, and specific to the selected instance_size and disk_size_gb"
  type        = number
  default     = null
}

variable "mongodb_volume_type" {
  description = "The type of sotrage volume for the MongoDB cluster. Possible values are `STANDARD` and `PROVISIONED`"
  type        = string
  default     = null
}

variable "mongodb_backup_enabled" {
  description = "Indicates if the MongoDB cluster uses Cloud Backup Snapshots for backups"
  type        = bool
  default     = false
}

variable "mongodb_encryption_at_rest" {
  description = "Indicates whether Encryption at Rest is enabled for the MongoDB cluster"
  type        = bool
  default     = false
}

variable "mongodb_auto_scaling_disk_gb_enabled" {
  description = "Indicates whether disk auto-scaling is enabled for the MongoDB cluster"
  type        = bool
  default     = true
}

variable "mongodb_auto_scaling_compute_enabled" {
  description = "Specifies whether the MongoDB cluster tier auto-scaling is enabled"
  type        = bool
  default     = false
}

variable "mongodb_auto_scaling_min_instance_size" {
  description = "Minimum instance size to which the MongoDB cluster can automatically scale"
  type        = string
  default     = null
}

variable "mongodb_auto_scaling_max_instance_size" {
  description = "Maximum instance size to which the MongoDB cluster can automatically scale"
  type        = string
  default     = null
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

### Redis Required Settings ###############################

variable "redis_node_type" {
  description = "The type of node to use for the ElastiCache Redis deployment"
  type        = string
}

variable "redis_num_cache_nodes" {
  description = "The number of nodes to use for the ElastiCache Redis deployment"
  type        = number
}

### Redis Optional Settings ###############################

variable "redis_parameter_group_name" {
  description = "The parameter group name for the ElastiCache Redis deployment"
  type        = string
  default     = "default.redis5.0"
}

variable "redis_engine_version" {
  description = "The Redis version to use for the deployment"
  type        = string
  default     = "5.0.6"
}

variable "redis_port" {
  description = "The port to use for the ElastiCache Redis deployment"
  type        = number
  default     = 6379
}

variable "redis_snapshot_retention_limit" {
  description = "The number of days to retain backups of ElastiCache Redis deployment snapshots"
  type        = number
  default     = 1
}

### Course Discovery Settings ###############################

variable "enable_course_discovery" {
  description = "Switch which enables/disables the creation of bucket for course discovery IDA"
  type        = bool
  default     = false
}
