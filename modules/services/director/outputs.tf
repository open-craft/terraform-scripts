output "director_instance_public_ip" {
  value = aws_instance.director.public_ip
}

output "director_security_group_id" {
  value = aws_security_group.director.id
}
