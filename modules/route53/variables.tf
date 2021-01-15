variable "customer_domain" {
  description = "domain or subdomain provided by a customer that delegates to Route53"
}

variable "customer_domain_extra_records" {
  description = "Map of subdomain records to append to the customer_domain zone"
  type = map(object({
    type = string
    value = string
    ttl = number
  }))
  default = {}
}

variable "enable_acm_validation" {
  description = "Wait for validation of AWS cetificate created for customer_domain"
  default = true
}
