## Low priority alert SNS topic and corresponding default subscriptions

resource "aws_sns_topic" "low_priority_alert" {
  name = "low_priority_resource_monitor_${var.customer_name}_${var.environment}"
}



# High priority alert SNS topic and corresponding default subscriptions

resource "aws_sns_topic" "high_priority_alert" {
  name = "high_priority_resource_monitor_${var.customer_name}_${var.environment}"
}
