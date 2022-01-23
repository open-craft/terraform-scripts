# AWS CloudWatch for monitoring AWS resources

This configures a few standard monitoring metrics for AWS resources along with two
SNS topics. One for low priority alerts and other for high priority alerts.

The alerts can be subscribed to, using SNS topic subscription as given in the sample below.

## Sample module configuration

```
module "cloud_watch" {
  source = "../optional/terraform"
  default_ec2_alarm_enabled = true
  ec2_instances = [aws_instance.client_app_server.id, aws_instance.client_app_server_2.id]
  default_rds_alarm_enabled = true
  rds_instances = [aws_db_instance.client_rds_instance.id]
  environment = "prod"
  customer_name = "client"
}
```

## Sample low priority email alert configuration

```
resource "aws_sns_topic_subscription" "low_priority_email_subscription" {
  topic_arn = module.cloud_watch.low_priority_alert_arn
  protocol  = "email"
  endpoint = "low.priority@example.com"
}
```

## Sample high priority email alert configuration

```
resource "aws_sns_topic_subscription" "high_priority_email_subscription" {
  topic_arn = module.cloud_watch.high_priority_alert_arn
  protocol  = "email"
  endpoint = "high.priority@example.com"
}
```

## Input

- `customer_name`: Name of organization for which resources are being provisioned
- `environment`: Environment for which resources being provisioned.
- `default_ec2_alarms_enabled`: Default `false`. Set to `true` to enable default EC2 monitoring setups
- `ec2_instances`: List of EC2 instance ids for which monitoring being setup
- `default_rds_alarms_enabled`: Default `false`. Set to `true` to enable default RDS monitoring setups
- `rds_instances`: List of RDS instances ids for which monitoring being setup


## Output

- `low_priority_alert_arn`: ARN of low priority alert to enable subscriptions
- `high_priority_alert_arn`: ARN of high priority alert to enable subscriptions


## TODOS

- Add other standard high and low priority monitoring metrics for different AWS resources.
