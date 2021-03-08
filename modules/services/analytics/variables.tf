variable "customer_name" {}
variable "environment" {}
variable "analytics_image_id" {}
variable "analytics_instance_type" {}
variable "analytics_key_pair_name" {}
variable "analytics_mysql_allocated_storage" {
  default = 5
}

variable "analytics_mysql_root_username" {}
variable "analytics_mysql_root_password" {}
variable "analytics_mysql_instance_class" {
  default = "db.t2.medium"
}

variable "hosted_zone_domain" {}

variable "instance_iteration" {
  default = 1
}


variable "analytics_identifier" {
  default = "edx-analytics"
}

variable "provision_role_description" {
  default = "Terraform managed - Opencraft"
}

variable "emr_master_security_group_description" {
  default = "Managed by Terraform"
}

variable "emr_slave_security_group_description" {
  default = "Managed by Terraform"
}

variable "edxapp_rds_port" {
  default = 3306
}

# these are gotten from the edX provisioning
variable "director_security_group_id" {}
variable "edxapp_s3_grade_bucket_id" {}
variable "edxapp_s3_grade_bucket_arn" {}
variable "edxapp_s3_grade_user_arn" {}

locals {
  http_port = 80
  https_port = 443
  ssh_port = 22
  any_port = 0
  all_ports = -1
  jenkins_port = 8080

  maximum_port = 65535

  tcp_protocol = "tcp"
  udp_protocol = "udp"
  icmp_protocol = "icmp"
  any_protocol = "-1"

  all_ips = ["0.0.0.0/0"]
}
