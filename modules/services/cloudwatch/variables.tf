variable "customer_name" {
  description = "Client name to be appended to Alerts"
  type        = string
}

variable "environment" {
  description = "Environment where this is being configured"
  type        = string
}

variable "default_ec2_alarms_enabled" {
  description = "Used to enable default EC2 alarms"
  type        = bool
  default     = false
}

variable "ec2_instances" {
  description = "EC2 instances to setup monitoring"
  type        = list(string)
  default     = []
}

variable "default_rds_alarms_enabled" {
  description = "Used to enable default RDS alarms"
  type        = bool
  default     = false
}

variable "rds_instances" {
  description = "RDS instances to setup monitoring"
  type        = list(string)
  default     = []
}

variable "override_default_low_priority_email" {
  description = "Used to override the default email address for low priority alerts"
  type        = string
  default     = null
}

variable "override_default_high_priority_email" {
  description = "Used to override the default email address for high priority alerts"
  type        = string
  default     = null
}
