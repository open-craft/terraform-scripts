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
