## Default actions which can be overridden using input variables if so desired
locals {
  opencraft_ops_email = "ops@opencraft.com"
  opencraft_urgent_email = "urgent@opencraft.com"
}


## Low priority alert SNS topic and corresponding default subscriptions

resource "aws_sns_topic" "low_priority_alert" {
  name = "low_priority_resource_monitor_${var.customer_name}_${var.environment}"
}

resource "aws_sns_topic_subscription" "opencraft_ops_email_subscription" {
  topic_arn = aws_sns_topic.low_priority_alert.arn
  protocol  = "email"
  endpoint = var.override_default_low_priority_email == null ? local.opencraft_ops_email : var.override_default_low_priority_email
}



# High priority alert SNS topic and corresponding default subscriptions

resource "aws_sns_topic" "high_priority_alert" {
  name = "high_priority_resource_monitor_${var.customer_name}_${var.environment}"
}

resource "aws_sns_topic_subscription" "opencraft_ugrent_email_subscription" {
  topic_arn = aws_sns_topic.high_priority_alert.arn
  protocol  = "email"
  endpoint = var.override_default_high_priority_email == null ? local.opencraft_urgent_email : var.override_default_high_priority_email
}
