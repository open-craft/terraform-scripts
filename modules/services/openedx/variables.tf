variable "customer_domain" {}

variable "customer_name" {}
variable "environment" {}

variable "director_security_group_id" {}

variable "route53_subdomains" {
  default = [
    "www",
    "preview",
    "studio",
    "ecommerce",
    "discovery",
  ]
}
