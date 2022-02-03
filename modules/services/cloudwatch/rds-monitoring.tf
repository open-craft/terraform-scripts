## Default RDS monitoring metrics

resource "aws_cloudwatch_metric_alarm" "low_storage_space_rds" {
  count             = length(var.rds_instances)
  alarm_name        = "Low Storage Space - RDS Instance ${element(var.rds_instances, count.index)}-${var.customer_name}-${var.environment}"
  alarm_description = "Storage space is below acceptable threshold"

  actions_enabled = var.default_rds_alarms_enabled
  alarm_actions   = [aws_sns_topic.high_priority_alert.arn]
  ok_actions      = [aws_sns_topic.high_priority_alert.arn]

  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "3"
  threshold           = "256000000"
  metric_name         = "FreeStorageSpace"
  statistic           = "Average"
  period              = "300"
  namespace           = "AWS/RDS"

  dimensions = {
    DBInstanceIdentifier = "${element(var.rds_instances, count.index)}"
  }
}
