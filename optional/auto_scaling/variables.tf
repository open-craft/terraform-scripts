variable "client_shortname" {
  description = "A short tag name for the client that will be used in naming resources."
  type        = string
}

variable "environment" {
  description = "The environment name for this deployment (e.g. stage, prod)."
  type        = string
}

variable "release" {
  description = "The name of the Open edX Release."
  type        = string
}

variable "aws_vpc_id" {
  description = "The ID of the AWS VPC that should contain all of the resources."
  type        = string
}

variable "security_group_id" {
  description = "The ID of the security group that should be used for creating resources in Auto Scaling group."
  type        = string
}

variable "lb_target_group_arn" {
  description = "The target group to which the Auto Scaling group will be attached."
  type        = string
}

variable "instances" {
  description = <<EOT
The list of existing "source" EC2 instances. The AMIs will be created from each of them if they don't exist yet.
**Note 1**: existing AMIs cannot be imported into the Terraform state. They will need to be recreated.
**Note 2**: instances will be stopped before taking the snapshots and then started back up again, resulting in a period of downtime.
EOT
  type        = list(object({
    id   = string
    tags = object({
      Name = string
    })
  }))
}

variable "auto_scaling_instance_type" {
  description = "The type of the EC2 instance."
  type        = string
  default     = "t3.xlarge"
}

variable "auto_scaling_min_instances" {
  description = "The minimum size of the Auto Scaling Group."
  type        = number
  default     = 2
}

variable "auto_scaling_max_instances" {
  description = "The maximum size of the Auto Scaling Group."
  type        = number
  default     = 4
}

variable "auto_scaling_desired_capacity" {
  description = "Set this if you want to immediately override a number of existing instances."
  type        = number
  default     = null
}

variable "auto_scaling_iam_instance_profile" {
  description = "The IAM Instance Profile to launch instances with."
  type        = string
  default     = null
}

variable "key_name" {
  description = "You can use a key pair to securely connect to your instance."
  type        = string
  default     = "appserver"
}
