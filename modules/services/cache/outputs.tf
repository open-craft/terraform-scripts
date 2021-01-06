output "redis_nodes" {
  value = aws_elasticache_cluster.redis.cache_nodes
}

output "memcached_nodes" {
  value = aws_elasticache_cluster.memcached.cache_nodes
}
