output "route53_DNS" {
  value = aws_route53_zone.primary.name_servers
}

output "route53_id" {
  value = aws_route53_zone.primary.id
}
