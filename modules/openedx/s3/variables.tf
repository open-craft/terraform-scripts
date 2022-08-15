### Provider Configurations ####################################

variable "aws_access_key" {
  description = "The AWS Access Key issued for API access"
  type        = string
}

variable "aws_secret_key" {
  description = "The AWS Secret Key issued for API access"
  type        = string
}

variable "aws_region" {
  description = "The AWS Region in which to deploy the resources"
  type        = string
}

### General Settings ######################################

variable "client_shortname" {
  description = "A short tag name for the client that will be used in naming resources"
  type        = string
}

variable "environment" {
  description = "The environment name for this deployment"
  type        = string
}

### Course Discovery Settings ###############################

variable "enable_course_discovery" {
  description = "Switch which enables/disables the creation of bucket for course discovery IDA"
  type        = bool
  default     = false
}
