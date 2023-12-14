variable "client_shortname" {
  description = "A short tag name for the client that will be used in naming resources"
  type = string
}

variable "environment" {
  description = "The environment name for this deployment (e.g. stage, prod)"
  type = string
}

variable "service_name" {
  description = "Name of the service this CDN is being set up for (e.g. `openedx`, `marketing_site`)."
  type = string
}

variable "origin_domain" {
  description = "The domain of the static file origins that the CDN should pull from."
  type = string
}

variable "cache_expiration" {
  description = "Time of cache expiration in seconds."
  type = number
  default = 31536000
}

variable "aliases" {
  description = "A list of aliases that will can be used instead of the CloudFront distribution's domain."
  type = list(string)
  default = null
}

variable "alias_zone_id" {
  description = "ID of the Route 53 zone, in which an alias subdomain should be created. Set this if you want the subdomain to be created automatically."
  type = string
  default = null
}

variable "alias_name" {
  description = "Prefix for the CDN subdomain."
  type = string
  default = "cdn"
}

variable "alias_certificate_arn" {
  description = "Set this if you have an existing ACM certificate in the `us-east-1` region. Otherwise, a new certificate will be created."
  type = string
  default = null
}

variable "aws_provider_profile" {
  description = "Set this if you haven't set `alias_certificate_arn`. It determines the source environment for the AWS credentials."
  type = string
  default = null
}

variable "custom_header" {
  description = "The custom header added to responses. Useful when a load balancer rule is gated with a secret header."
  type = object({
    name  = string
    value = string
  })
  default = null
}
