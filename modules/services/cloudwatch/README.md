# AWS CloudWatch for monitoring AWS resources

This configures a few standard monitoring metrics for AWS resources along with two
SNS topics subscribed to OpenCrafts ops@ and urgent@ mailing lists respectively.

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

## Input

- `customer_name`: Name of organization for which resources are being provisioned
- `environment`: Environment for which resources being provisioned.
- `default_ec2_alarms_enabled`: Default `false`. Set to `true` to enable default EC2 monitoring setups
- `ec2_instances`: List of EC2 instance ids for which monitoring being setup
- `default_rds_alarms_enabled`: Default `false`. Set to `true` to enable default RDS monitoring setups
- `rds_instances`: List of RDS instances ids for which monitoring being setup
- `override_default_low_priority_email` : Set new email address to override the default email for low priority alerts
- `override_default_high_priority_email` : Set new email address to override the default email for high priority alerts


## TODOS

- Add other standard high and low priority monitoring metrics for different AWS resources.
