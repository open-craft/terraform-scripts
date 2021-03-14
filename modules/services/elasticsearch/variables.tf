variable "customer_name" {}
variable "environment" {}
variable "edxapp_security_group_id" {}
variable "elasticsearch_instance_type" {
  default = "t2.small.elasticsearch"
}
variable "number_of_nodes" {
  default = 3
}
variable "create_iam_service_linked_role" {
  default = true
}

variable "zone_awareness_enabled" {
  default = true
}
variable "availability_zone_count" {
  default = 2
}

variable "dedicated_master_enabled" {
  default = true
}

variable "instance_count" {
  default = 2
}

variable "start_subnets_index" {
  default = 0
}

variable "end_subnets_index" {
  default = 2
}
