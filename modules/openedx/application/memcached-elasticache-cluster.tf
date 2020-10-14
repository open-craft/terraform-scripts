resource "aws_elasticache_cluster" "memcached" {
  cluster_id           = local.memcached_cluster_id
  engine               = "memcached"
  node_type            = var.memcached_node_type
  num_cache_nodes      = var.memcached_num_cache_nodes
  parameter_group_name = var.memcached_parameter_group_name
  port                 = var.memcached_port

  security_group_ids = [aws_security_group.cache.id]
}
