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
  default = 3600
}
