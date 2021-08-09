variable "customer_name" {}
variable "environment" {}

variable "instance_class" {}
variable "engine_version" {
  default = "5.7.33"
}
variable "allocated_storage" {}
variable "max_allocated_storage" {
  default = 100
}

variable "extra_security_group_ids" {
  default = []
}

variable "database_root_username" {}
variable "database_root_password" {}

variable "edxapp_security_group_id" {}

variable "number_of_replicas" {
  default = 0
}

variable "enable_multi_az" {
  default = false
}

variable "enable_replica_multi_az" {
  default = false
}

variable "replica_extra_security_group_ids" {
  default = []
}

variable "replica_publicly_accessible" {
  default = false
}
