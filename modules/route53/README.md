# AWS Route53 Setup

Very simple placeholder, to initialize Route53 to be used by other modules (email, services/openedx)

## Assumptions

- The customer has agreed to delegate the domain/subdomain complete control (we'll need to provide Route53 nameservers)
- The user will have to configure its DNS provider to point NS records to the provided nameservers

## Input

- `customer_domain`: (required) domain or subdomain provided by a customer that delegates to Route53
- `customer_domain_extra_records`: (optional) map objects specifying additional DNS records to add to the customer domain zone.
   Map key becomes the record `name`, and the record `value`, `type`, `ttl` are pulled from the object.
- `enable_acm_validation`: (optional, default true) Set to false if the DNS records won't validate (yet).

## Output

- `route53_DNS`: Nameservers (to be provided to the client)
- `route53_id`: TO be used by other modules 
