## Default EC2 monitoring metrics

resource "aws_cloudwatch_metric_alarm" "high_cpu_alert_ec2" {
  count             = length(var.ec2_instances)
  alarm_name        = "High CPU Utilization - EC2 Instance ${element(var.ec2_instances, count.index)}-${var.customer_name}-${var.environment}"
  alarm_description = "CPU utilization exceeded acceptable threshold"

  actions_enabled = var.default_ec2_alarms_enabled
  alarm_actions   = [aws_sns_topic.high_priority_alert.arn]
  ok_actions      = [aws_sns_topic.high_priority_alert.arn]

  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "12"
  threshold           = "90"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = "300"
  namespace           = "AWS/EC2"
  dimensions = {
    InstanceId = "${element(var.ec2_instances, count.index)}"
  }
}
