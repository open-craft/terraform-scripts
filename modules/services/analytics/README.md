# Analytics Resources

All AWS resources necessary for provisioning Analytics instances mentioned here:
https://github.com/open-craft/openedx-deployment/blob/master/docs/analytics/AWS_setup.md

## Assumptions

- You already setup an edX instance in AWS too.

## Input

- `customer_name`
- `environment`: you should normally set this to `analytics`
- `analytics_image_id`: The image ID for the Analytics EC2 instance
- `analytics_instance_type`: Instance Type for the ANalytics EC2 instance
- `analytics_key_pair_name`: You should have created a key pair just for analytics from the 
  AWS console (manually) and add that key pair name here
- `hosted_zone_domain`: Hosted Zone domain to create the insights subdomain in. This is normally 
  same as the LMS domain
- `instance_iteration`: Iteration number of the analytics EC2 instance, starts at 1
- `analytics_identifier`: Just an identifier for several resource names, defaults to `analytics_identifier`
- `provision_role_description`(optional): Description of the role used for the EC2 analytics instance
- `emr_master_security_group_description`(optional): Description of the EMR master Security Group
- `emr_slave_security_group_description`(optional): Description of the EMR slave Security Group
- `edxapp_rds_port`: Port to be opened on the RDS security group, defaults to `3306`
- `director_security_group_id`: The director security group ID used also for setting up the edX instance
- `edxapp_s3_grade_bucket_id`: bucket ID of the `grades` bucket used for the edX instance
- `edxapp_s3_grade_bucket_arn`: same as before, but the ARN
- `edxapp_s3_grade_user_arn`: User ARN that's used to read from the `grades` bucket
- `number_of_instances`: Number of ec2 analytics instances, useful for provisioning new ones as we
  normally use only 1 instance. Defaults to 1
- `lb_instance_indexes`: List of indexes of the previous instances to be added to the Load Balancer.
  Defaults to `[0]` (only the first instance)

## Output

- `analytics_security_group_id`: Security Group ID used by the Analytics instance
- `emr_rds_security_group_id`: Security Group ID used by RDS and EMR
