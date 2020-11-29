# AWS Route53 Setup

Very simple placeholder, to initialize Route53 to be used by other modules (email, services/openedx)

## Assumptions

- The customer has agreed to delegate the domain/subdomain complete control (we'll need to provide Route53 nameservers)
- The user will have to configure its DNS provider to point NS records to the provided nameservers

## Input
It only needs one variable:

- `customer_domain`: domain or subdomain provided by a customer that delegates to Route53

## Output

- `route53_DNS`: Nameservers (to be provided to the client)
- `route53_id`: TO be used by other modules 
