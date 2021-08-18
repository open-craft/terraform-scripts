# AWS CDN Setup for static asset caching

This configures an AWS CDN using Cloudfront to cache assets from a given origin URL.
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

2. Set up the outputs on your client's TF files by adding this section:
```
output "output_openedx_cdn" {
  value = module.openedx_cdn.aws_cloudfront_distribution
}
```

3. Run terraform apply and add the following outputs of this module to the `vars.yml` ansible variable file:
- `EDXAPP_LMS_STATIC_URL_BASE`: retrieve the value `output_openedx_cdn.domain_name` from the output of this module.


## TODOS

- Add multiple origin support (to support multiple IDAs in a single configuration)
- Support custom cache policies
