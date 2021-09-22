locals {
  vpc_id = var.specific_vpc_id != "" ? var.specific_vpc_id : data.aws_vpc.default[0].id
}

data "aws_vpc" "default" {
  default = true
  count = var.specific_vpc_id == "" ? 1 : 0
}

data "aws_subnet_ids" "default" {
  vpc_id = local.vpc_id
}

resource aws_elasticache_cluster redis {
  cluster_id = "edx-${var.customer_name}-${var.environment}-redis-cluster"
  engine = "redis"
  node_type = var.redis_node_type
  num_cache_nodes = 1   # redis doesn't support multiple nodes
  parameter_group_name = var.redis_parameter_group_name

  security_group_ids = [aws_security_group.cache.id]
  port = var.redis_port
}

resource aws_elasticache_cluster memcached {
  cluster_id = "edx-${var.customer_name}-${var.environment}-memcached-cluster"
  engine = "memcached"
  node_type = var.memcached_node_type
  num_cache_nodes = var.memcached_num_cache_nodes
  parameter_group_name = var.memcached_parameter_group_name

  security_group_ids = [aws_security_group.cache.id]
  port = var.memcached_port
}

resource aws_security_group cache {
  vpc_id = local.vpc_id
  name = "${var.customer_name}-${var.environment}-edxapp-cache"
}

resource aws_security_group_rule redis-outbound-rule {
  security_group_id = aws_security_group.cache.id
  type = "egress"
  protocol = "all"
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]

  from_port = 0
  to_port = 0
}

resource aws_security_group_rule redis-inbound-rule {
  type = "ingress"
  security_group_id = aws_security_group.cache.id
  source_security_group_id = var.edxapp_security_group_id

  protocol = "all"
  from_port = 0
  to_port = 0
}
