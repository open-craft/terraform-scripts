variable "customer_name" {}
variable "environment" {}
variable "edxapp_security_group_id" {}

variable "redis_node_type" {
  default = "cache.m4.large"
}
variable "redis_num_cache_nodes" {
  default = 1
}
variable "redis_parameter_group_name" {
  default = "default.redis6.x"
}
variable "redis_cluster_id" {
  default = "edx-redis-cluster"
}
variable "redis_port" {
  default = 6379
}

variable "memcached_cluster_id" {
  default = "edx-memcached-cluster"
}
variable "memcached_node_type" {
  default = "cache.m4.large"
}
variable "memcached_num_cache_nodes" {
  default = 1
}
variable "memcached_parameter_group_name" {
  default = "default.memcached1.5"
}
variable "memcached_port" {
  default = 11211
}
