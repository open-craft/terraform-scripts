variable "customer_domain" {}

variable "customer_name" {}
variable "environment" {}

variable "director_security_group_id" {}

variable "specific_vpc_id" { default = "" }
variable "specific_subnet_ids" { default = [] }
variable "specific_lb_certificate_arn" { default = "" }

variable "route53_create_main_domain" { default = true }
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

variable "allow_consul" { default = 1 }
variable "allow_prometheus" { default = 1 }

variable "enable_lb_stickiness" {
  description = "Enabled load balancer stickiness."
  default = false
}

variable "lb_stickiness_cookie_duration" {
  description = "Time period, in seconds, during which requests from a client should be rooted to the same target."
  default = 600
}
