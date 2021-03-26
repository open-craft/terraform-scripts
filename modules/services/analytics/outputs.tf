output "analytics_security_group_id" {
  value = aws_security_group.analytics.id
}

output "emr_rds_security_group_id" {
  value = aws_security_group.emr-rds.id
}

output "elasticsearch_host" {
  value = module.elasticsearch.elasticsearch
}
