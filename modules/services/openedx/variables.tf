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

variable "lb_idle_timeout" {
  default = 60
}

variable enable_https {
  description = "Cannot enable HTTPS until there is a valid customer_domain certificate"
  default = true
}

variable "lb_ssl_security_policy" {
  description = "The AWS ssl security policy to be used by load balancer"
  default = "ELBSecurityPolicy-2016-08"
}
