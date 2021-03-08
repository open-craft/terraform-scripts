output "director_security_group" {
  value = aws_security_group.director
}

output "edxapp_appserver_security_group" {
  value = aws_security_group.edxapp_appserver
}

output "edxapp_s3_bucket" {
  value = module.s3.edxapp_s3_bucket
}

output "edxapp_s3_user_access_key" {
  value = module.s3.edxapp_s3_user_access_key
}

output "edxapp_tracking_logs_s3_bucket" {
  value = module.s3.edxapp_tracking_logs_s3_bucket
}

output "edxapp_tracking_logs_s3_user_access_key" {
  value = module.s3.edxapp_tracking_logs_s3_user_access_key
}

output "edxapp_course_discovery_s3_access_key" {
  value = module.s3.edxapp_course_discovery_s3_access_key
}

output "load_balancer" {
  value = aws_lb.application
}

output "memcached" {
  value = aws_elasticache_cluster.memcached
}

output "rds" {
  value = module.rds
}

output "redis" {
  value = aws_elasticache_cluster.redis
}

output "edxapp_aws_lb_listener" {
  value = aws_lb_listener.edxapp
}
