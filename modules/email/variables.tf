variable "customer_domain" {
  description = "domain or subdomain provided by a customer that delegates to Route53"
}

variable "route53_id" {
  description = "route53 ID of the configured domain"
}

variable "internal_emails" {
  description = "internal emails"
  default = [
    "no-reply"
  ]
}

variable "custom_emails_to_verify" {
  description = "external emails to verify and test initial email configuration, set at least your personal"
  type = list(string)
}

variable "customer_name" {}
variable "environment" {}