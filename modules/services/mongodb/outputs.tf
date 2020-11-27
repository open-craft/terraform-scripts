output "mongodb_instances" {
  value = aws_instance.mongodb.*.private_ip
}
