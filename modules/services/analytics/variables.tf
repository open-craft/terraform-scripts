variable "customer_name" {}
variable "environment" {}
variable "analytics_image_id" {}
variable "analytics_instance_type" {}
variable "analytics_key_pair_name" {}
variable "hosted_zone_domain" {}
variable "number_of_instances" {
  default = 1
}
variable "instance_iteration" {
  default = 1
}
variable "lb_instance_indexes" {
  default = [0]
}

variable "analytics_identifier" {
  default = "edx-analytics"
}

variable "provision_role_description" {
  default = "Terraform managed - Opencraft"
}

variable "emr_service_role_policy" {
  # Deprecated service role, cf
  # https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-managed-iam-policies.html
  default = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceRole"

  # Use for new deployments made after May 1 2020
  # default = "arn:aws:iam::aws:policy/service-role/AmazonEMRServicePolicy_v2"
}

variable "emr_ec2_service_role_policy" {
  # Deprecated service role, cf
  # https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-managed-iam-policies.html
  default = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforEC2Role"

  # No replacement service role was provided for V2.
  # For new deployments made after May 1 2020, a new policy will need to be created which allows access to the required resources.
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
