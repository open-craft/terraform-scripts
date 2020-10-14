resource "aws_elasticache_cluster" "redis" {
  cluster_id               = local.redis_cluster_id
  engine                   = "redis"
  node_type                = var.redis_node_type
  num_cache_nodes          = var.redis_num_cache_nodes
  parameter_group_name     = var.redis_parameter_group_name
  engine_version           = var.redis_engine_version
  port                     = var.redis_port
  snapshot_retention_limit = var.redis_snapshot_retention_limit

  security_group_ids = [aws_security_group.cache.id]
}
