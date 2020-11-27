# AWS Emails Setup

Here we are configuring SES, to be able for the OpenedX to send emails (and some to receive and test).

## Input
- `customer_domain`: Root domain deleted to Route53
- `route53_id`: configured Route53 ID
- `internal_emails`: List of emails to be used by the OpenedX instance (`no-reply` added as default)
- `custom_emails_to_verify`: Test emails to be used as recipients until you get out of the sandbox (check *Note*)
SES configuration to be out of the sandbox
- `customer_name`
- `environment`

*Note*: After this being created, you need to login into AWS Console, go to SES and ask AWS to be
out of the sandbox, so you can send emails from SES to anyone, and not only verified emails
