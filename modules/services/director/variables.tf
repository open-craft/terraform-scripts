variable "image_id" {}
variable "instance_type" {}

variable "director_key_pair_name" {}

variable "environment" {
  default = "prod"
}

variable "custom_security_group_name" {
  default = ""
}
