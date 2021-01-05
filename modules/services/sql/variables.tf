variable "customer_name" {}
variable "environment" {}

variable "instance_class" {}
variable "engine_version" {
  default = "5.6.48"
}
variable "allocated_storage" {}

variable "database_root_username" {}
variable "database_root_password" {}

variable "edxapp_security_group_id" {}

variable "number_of_replicas" {
  default = 0
}
