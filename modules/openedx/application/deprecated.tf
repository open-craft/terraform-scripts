### DEPRECATED ############################################
#   DO NOT USE THESE VARIABLES WITH NEW INFRASTRUCTURE
/*
These are specifically to support KKUx having legacy names for
resources that would require being recreated upon a name change
*/
variable "deprecated_load_balancer_name" {
  description = "DEPRECATED - Use client_shortname and environment. Overwrites the load balancer name"
  type        = string
  default     = null
}

variable "deprecated_lb_target_group_name" {
  description = "DEPRECATED - Use client_shortname and environment. Overwrites the lb_target_group name"
  type        = string
  default     = null
}

variable "deprecated_application_security_group_name" {
  description = "DEPRECATED - Use client_shortname and environment. Overwrites the edxapp_appserver security group name"
  type        = string
  default     = null
}

variable "deprecated_application_security_group_description" {
  description = "DEPRECATED - Use environment. Overwrites the edxapp_appserver security group description"
  type        = string
  default     = null
}

variable "deprecated_director_security_group_name" {
  description = "DEPRECATED - Use client_shortname and environment. director Overwrites the security group name"
  type        = string
  default     = null
}

variable "deprecated_director_security_group_description" {
  description = "DEPRECATED - Use environment. Overwrites the director security group description"
  type        = string
  default     = null
}

variable "deprecated_cache_security_group_name" {
  description = "DEPRECATED - Use client_shortname and environment. Overwrites the cache security group name"
  type        = string
  default     = null
}

variable "deprecated_cache_security_group_description" {
  description = "DEPRECATED - Use environment. Overwrites the cache security group description"
  type        = string
  default     = null
}

variable "deprecated_allow_prometheus_security_group_name" {
  description = "DEPRECATED - Use client_shortname and environment. Overwrites the allow_prometheus security group name"
  type        = string
  default     = null
}

variable "deprecated_allow_prometheus_security_group_description" {
  description = "DEPRECATED - Use environment. Overwrites the allow_prometheus security group description"
  type        = string
  default     = null
}

variable "deprecated_memcached_cluster_id" {
  description = "DEPRECATED - Use client_shortname and environment. Overwrites the memcached cluster id"
  type        = string
  default     = null
}

variable "deprecated_redis_cluster_id" {
  description = "DEPRECATED - Use client_shortname and environment. Overwrites the redis cluster id"
  type        = string
  default     = null
}

variable "deprecated_db_subnet_group_name" {
  description = "DEPRECATED - Use client_shortname and environment. Overwrites the db subnet group name"
  type        = string
  default     = null
}

variable "deprecated_db_instance_name" {
  description = "DEPRECATED - Use client_shortname and environment. Overwrites the rds instance name"
  type        = string
  default     = null
}

variable "deprecated_rds_security_group_name" {
  description = "DEPRECATED - Use client_shortname and environment. Overwrites the rds security group name"
  type        = string
  default     = null
}

variable "deprecated_rds_security_group_description" {
  description = "DEPRECATED - Use environment. Overwrites the rds security group description"
  type        = string
  default     = null
}

locals {

  // Apply deprecated overrides
  load_balancer_name = coalesce(
    var.deprecated_load_balancer_name,
    lower(join("-", [var.client_shortname, "edxapp", var.environment]))
  )
  lb_target_group_name = coalesce(
    var.deprecated_lb_target_group_name,
    lower(join("-", [var.client_shortname, "edxapp", var.environment]))
  )

  allow_prometheus_security_group_name = coalesce(
    var.deprecated_allow_prometheus_security_group_name,
    lower(join("-", [var.client_shortname, "allow_prometheus", var.environment]))
  )

  allow_prometheus_default_sg_description = "Security group for the ${title(var.environment)} which allows Prometheus ports."
  allow_prometheus_security_group_description = coalesce(
    var.deprecated_allow_prometheus_security_group_description,
    local.allow_prometheus_default_sg_description
  )

  application_security_group_name = coalesce(
    var.deprecated_application_security_group_name,
    lower(join("-", [var.client_shortname, "application", var.environment]))
  )

  application_default_sg_description = "Security group for the ${title(var.environment)} application servers"
  application_security_group_description = coalesce(
    var.deprecated_application_security_group_description,
    local.application_default_sg_description
  )

  cache_security_group_name = coalesce(
    var.deprecated_cache_security_group_name,
    lower(join("-", [var.client_shortname, "cache", var.environment]))
  )

  cache_default_sg_description = "Security group for the ${title(var.environment)} ElastiCache clusters"
  cache_security_group_description = coalesce(
    var.deprecated_cache_security_group_description,
    local.cache_default_sg_description
  )

  director_security_group_name = coalesce(
    var.deprecated_director_security_group_name,
    lower(join("-", [var.client_shortname, "director", var.environment]))
  )

  director_default_sg_description = "Security group for the ${title(var.environment)} director instance"
  director_security_group_description = coalesce(
    var.deprecated_director_security_group_description,
    local.director_default_sg_description
  )

  memcached_cluster_id = coalesce(
    var.deprecated_memcached_cluster_id,
    lower(join("-", [var.client_shortname, "memcached", var.environment]))
  )

  redis_cluster_id = coalesce(
    var.deprecated_redis_cluster_id,
    lower(join("-", [var.client_shortname, "redis", var.environment]))
  )
}
