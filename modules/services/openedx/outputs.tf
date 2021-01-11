output "edxapp_security_group_id" {
  value = aws_security_group.edxapp.id
}

output "edxapp_lb_target_group_arn" {
  value = aws_lb_target_group.edxapp.arn
}
