output "analytics_security_group_id" {
  value = aws_security_group.analytics.id
}

output "emr_rds_security_group_id" {
  value = aws_security_group.emr-rds.id
}

output "elasticsearch_host" {
  value = module.elasticsearch.elasticsearch
}

output "analytics_instance_private_ips" {
  value = aws_instance.analytics.*.private_ip
}

output "analytics_instance_public_ips" {
  value = aws_instance.analytics.*.public_ip
}
