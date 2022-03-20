# AWS CDN Setup for static asset caching

This configures an AWS CDN using CloudFront to cache assets from a given origin URL.
This can be used to cache assets from an Open edX instance or a marketing website.

## How to use

1. Add a new section on the instace's terraform configuration:
```
module "openedx_cdn" {
  source = "../common/optional/cloudfront_cdn"

  client_shortname = "client"
  environment = "prod"
  service_name = "cdn-edxapp"
  origin_domain = "courses.client.test"
}
```
Configure the inputs as described below:
- `client_shortname`: slug of the customer to provision the resources
- `environment`: `prod`, `stage`, `test`, etc
- `service_name`: name of the service the CDN is being set up for (`openedx`, `marketing_site`, etc)
- `origin_domain`: domain of the static file origins that the CDN should pull from.
    Example: `my-instance.example.com` (LMS domain name)
- `cache_expiration` (optional): time of cache expiration in seconds.
- `aliases` (optional): a list of domain aliases for the CDN

2. Set up the outputs on your client's TF files by adding this section:
```
output "openedx_cdn_domain_name" {
  value = module.openedx_cdn.aws_cloudfront_distribution.domain_name
}
```

3. Run terraform apply and add the following outputs of this module to the `vars.yml` ansible variable file:
- `EDXAPP_LMS_STATIC_URL_BASE`: retrieve the value `openedx_cdn_domain_name` from the output of this module.

## Custom CDN domain

You can use a custom domain (alias) for the CloudFront distribution by configuring the following optional variables:
1. `aliases`:  A list of aliases that will can be used instead of the Cloudfront distribution's domain.
2. `alias_zone_id`: ID of the Route 53 zone, in which an alias subdomain should be created. Set this if you want the subdomain to be created automatically.
3. `alias_name: `: Prefix for the CDN subdomain. Default: `cdn`.
4. `alias_certificate_arn`: Set this if you have an existing ACM certificate in the `us-east-1` region. Otherwise, a new certificate will be created.
5. `aws_provider_profile`: Set this if you haven't set `alias_certificate_arn`. It determines the source environment for the AWS credentials.

## TODOS

- Add multiple origin support (to support multiple IDAs in a single configuration)
- Support custom cache policies
