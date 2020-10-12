output "rds" {
  value = module.rds
}

output "security_group" {
  value = aws_security_group.wordpress
}

output "security_group_id" {
  value = aws_security_group.wordpress.id
}
