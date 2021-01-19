/*
Creates a subnet group to be used by elasticache clusters.

Needed to properly create Memcached and Redis instances
inside a VPC. This also allows select in which availability
zones the cluster will be deployed in case a multi-AZ
cluster is setup.
*/
resource "aws_elasticache_subnet_group" "elasticache_subnets" {
  name       = lower(join("-", [var.client_shortname, "elasticachesubnetgroup", var.environment]))
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id               = local.redis_cluster_id
  engine                   = "redis"
  node_type                = var.redis_node_type
  num_cache_nodes          = var.redis_num_cache_nodes
  parameter_group_name     = var.redis_parameter_group_name
  engine_version           = var.redis_engine_version
  port                     = var.redis_port
  snapshot_retention_limit = var.redis_snapshot_retention_limit

  subnet_group_name  = aws_elasticache_subnet_group.elasticache_subnets.name
  security_group_ids = [aws_security_group.cache.id]
}

resource "aws_elasticache_cluster" "memcached" {
  cluster_id           = local.memcached_cluster_id
  engine               = "memcached"
  node_type            = var.memcached_node_type
  num_cache_nodes      = var.memcached_num_cache_nodes
  parameter_group_name = var.memcached_parameter_group_name
  engine_version       = var.memcached_engine_version
  port                 = var.memcached_port

  subnet_group_name  = aws_elasticache_subnet_group.elasticache_subnets.name
  security_group_ids = [aws_security_group.cache.id]
}
