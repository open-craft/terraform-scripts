variable "customer_domain" {
  description = "domain or subdomain provided by a customer that delegates to Route53"
}

variable "enable_acm_validation" {
  default = true
}
