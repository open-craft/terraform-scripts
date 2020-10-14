output "database" {
  value = aws_db_instance.database
}

output "security_group" {
  value = aws_security_group.rds
}
