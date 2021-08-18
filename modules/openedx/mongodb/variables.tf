### Provider Configurations ####################################

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
  description = "The environment name for this deployment"
  type        = string
}

### Mongo DB Required Settings #####################################

variable "cluster_name" {
  description = "A short descriptive name for the MongoDB cluster"
  type        = string
}

variable "region_name" {
  description = "The name of the AWS region the cluster will be deployed in"
  type        = string
}

variable "instance_size" {
  description = "The instance size for the MongoDB cluster"
  type        = string
}

variable "disk_size_gb" {
  description = "The amount of storage to allocate to the MongoDB cluster"
  type        = number
}

### Mongo DB Optional Settings #####################################

variable "mongodb_version" {
  description = "The version of MongoDB to deploy"
  type        = string
  default     = "3.6"
}

variable "num_shards" {
  description = "The total number of shards for the MongoDB deployment"
  type        = number
  default     = 1
}

variable "replication_factor" {
  description = "Number of replica set members. Each member keeps a copy of your databases, providing high availability and data redundancy. The possible values are 3, 5, or 7"
  type        = number
  default     = 3
}

variable "disk_iops" {
  description = "Indicates the maximum input/output operations per second (IOPS) the system can perform. The possible values are provider dependent, and specific to the selected instance_size and disk_size_gb"
  type        = number
  default     = null
}

variable "volume_type" {
  description = "The type of sotrage volume. Possible values are `STANDARD` and `PROVISIONED`"
  type        = string
  default     = null
}

variable "backup_enabled" {
  description = "Indicates if the cluster uses Cloud Backup Snapshots for backups"
  type        = bool
  default     = false
}

variable "encryption_at_rest" {
  description = "Indicates whether Encryption at Rest is enabled"
  type        = bool
  default     = false
}

variable "auto_scaling_disk_gb_enabled" {
  description = "Indicates whether disk auto-scaling is enabled for the MongoDB cluster"
  type        = bool
  default     = true
}

variable "auto_scaling_compute_enabled" {
  description = "Specifies whether the MongoDB cluster tier auto-scaling is enabled"
  type        = bool
  default     = false
}

variable "auto_scaling_min_instances" {
  description = "Minimum instance size to which the MongoDB cluster can automatically scale"
  type        = string
  default     = null
}

variable "auto_scaling_max_instances" {
  description = "Maximum instance size to which the MongoDB cluster can automatically scale"
  type        = string
  default     = null
}
