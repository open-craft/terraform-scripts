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
