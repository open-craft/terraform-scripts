variable "image_id" {}
variable "instance_type" {}

variable "director_key_pair_name" {}

variable "environment" {
  default = "prod"
}

variable "custom_security_group_name" {
  default = ""
}

variable "specific_vpc_id" { default = "" }
variable "specific_subnet_id" { default = "" }

variable "custom_instance_name" { default = "" }
