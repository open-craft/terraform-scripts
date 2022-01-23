output "low_priority_alert_arn" {
  value = aws_sns_topic.low_priority_alert.arn
}

output "high_priority_alert_arn" {
  value = aws_sns_topic.high_priority_alert.arn
}
