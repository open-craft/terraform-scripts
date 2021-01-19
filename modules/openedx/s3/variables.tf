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

### DEPRECATED ############################################
#   DO NOT USE THESE VARIABLES WITH NEW INFRASTRUCTURE

/*
This is specifically in order for KKUx to have access to required
S3 functionality which is not supported in their primary region
@Giovanni Cimolin - please confirm this
*/
variable "deprecated_alternate_s3_bucket_region" {
  description = "DEPRECATED - Host S3 buckets in the same region as the rest of your infrastructure. Overwrites the aws_region, ONLY for S3 buckets"
  type        = string
  default     = null
}

locals {
  // Compute Region to store S3 data in
  aws_s3_bucket_region = coalesce(var.deprecated_alternate_s3_bucket_region, var.aws_region)
}
