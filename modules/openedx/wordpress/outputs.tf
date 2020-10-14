output "rds" {
  value = module.rds
}

output "security_group" {
  value = aws_security_group.wordpress
}
