output "mysql_host_name" {
  value = aws_db_instance.mysql_rds.endpoint
}

output "mysql_instance_id" {
  value = aws_db_instance.mysql_rds.id
}