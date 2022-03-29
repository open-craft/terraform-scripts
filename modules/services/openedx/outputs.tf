output "edxapp_security_group_id" {
  value = aws_security_group.edxapp.id
}

output "edxapp_lb_target_group_arn" {
  value = aws_lb_target_group.edxapp.arn
}

output "route53_zone_id" {
  value       = var.route53_create_main_domain ? aws_route53_record.main_domain_lb_record[0].zone_id : null
  description = "The ID of the zone in which the main domain was created (**if** it was created)."
}
