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

variable "ebs_volume_type" {
  description = "Type of EBS volumes attached to the instance."
  default     = "gp2"
}
variable "ebs_volume_size" {
  description = "Size of EBS volumes attached to the instance (in GiB)."
  default     = 8
}
variable "ebs_iops" {
  description = "Baseline input/output (I/O) performance of EBS volumes attached to the instance. Applicable only if `ebs_volume_type` is set to \"gp3\"."
  default     = 3000
}
