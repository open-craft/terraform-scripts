# Custom aliases require setting a custom ACM certificate, which needs to be in the `us-east-1` region.
provider "aws" {
  alias   = "acm"
  region  = "us-east-1"
  profile = var.aws_provider_profile
}

resource "aws_cloudfront_cache_policy" "cache_policy" {
  name        = lower(join("-", [var.client_shortname, var.environment, var.service_name, "cdn-cache-policy"]))
  comment     = lower(join("-", [var.client_shortname, var.environment, var.service_name]))
  min_ttl     = 1
  default_ttl = var.cache_expiration
  max_ttl     = var.cache_expiration

  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_gzip = true

    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = "whitelist"
      headers {
        items = ["Origin", ]
      }
    }

    query_strings_config {
      query_string_behavior = "all"
    }
  }
}

resource "aws_cloudfront_origin_request_policy" "origin_request_policy" {
  name    = lower(join("-", [var.client_shortname, var.environment, var.service_name, "cdn-origin-request-policy"]))
  comment = lower(join("-", [var.client_shortname, var.environment, var.service_name]))

  cookies_config {
    cookie_behavior = "none"
  }

  headers_config {
    header_behavior = "whitelist"
    headers {
      items = ["Origin", ]
    }
  }
  query_strings_config {
    query_string_behavior = "all"
  }
}

resource "aws_cloudfront_response_headers_policy" "response_headers_policy" {
  name    = lower(join("-", [var.client_shortname, var.environment, var.service_name, "cdn-response-headers-policy"]))
  comment = lower(join("-", [var.client_shortname, var.environment, var.service_name]))

  cors_config {
    access_control_allow_credentials = false
    access_control_max_age_sec       = var.cache_expiration
    origin_override                  = true

    access_control_allow_headers {
      items = [
        "*",
      ]
    }

    access_control_allow_methods {
      items = [
        "ALL",
      ]
    }

    access_control_allow_origins {
      items = [
        "*",
      ]
    }
  }
}

resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  enabled         = true
  is_ipv6_enabled = true
  comment         = lower(join("-", [var.client_shortname, var.environment, var.service_name]))
  aliases         = var.aliases

  origin {
    domain_name = var.origin_domain
    origin_id   = var.origin_domain

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "match-viewer"
      origin_read_timeout      = 30
      origin_ssl_protocols     = [
        "TLSv1",
        "TLSv1.1",
        "TLSv1.2",
      ]
    }

    dynamic "custom_header" {
      for_each = var.custom_header[*]
      content {
        name  = var.custom_header.name
        value = var.custom_header.value
      }
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.origin_domain

    compress = true

    viewer_protocol_policy     = "redirect-to-https"
    cache_policy_id            = aws_cloudfront_cache_policy.cache_policy.id
    origin_request_policy_id   = aws_cloudfront_origin_request_policy.origin_request_policy.id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.response_headers_policy.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = var.environment
  }

  viewer_certificate {
    # This part is very ugly because there are 3 typical use cases:
    #   1. Using the default certificate domain.
    #      In this case, no additional resources are needed because the CloudFront default certificate is sufficient.
    #   2. Use the existing ACM certificate from the `us-east-1` region.
    #      In this case, only the domain record is created.
    #   3. Generate a new ACM certificate in the `us-east-1` region.
    #      Applicable when the main certificate already exists in another region.
    cloudfront_default_certificate = var.aliases == null ? true : false

    acm_certificate_arn = (
                            var.aliases == null
                              ? null
                              : var.alias_certificate_arn != null
                                ? var.alias_certificate_arn
                                : aws_acm_certificate.alias_certificate[0].arn
                          )
    # Needs to be set along with the non-default certificate.
    ssl_support_method = var.aliases == null ? null : "sni-only"
  }
}


# Custom CDN subdomain.
resource "aws_route53_record" alias {
  count = var.alias_zone_id == null ? 0 : 1

  zone_id = var.alias_zone_id
  name    = var.alias_name
  type    = "A"

  alias {
    name    = aws_cloudfront_distribution.cloudfront_distribution.domain_name
    zone_id = aws_cloudfront_distribution.cloudfront_distribution.hosted_zone_id

    evaluate_target_health = false
  }
}

# Custom ACM certificate.
resource "aws_acm_certificate" alias_certificate {
  count    = var.alias_zone_id != null && var.alias_certificate_arn == null ? 1 : 0
  provider = aws.acm

  domain_name       = "${var.alias_name}.${var.origin_domain}"
  validation_method = "DNS"
}

locals {
  domain_validation_options = (length(aws_acm_certificate.alias_certificate) > 0
                                 ? aws_acm_certificate.alias_certificate[0].domain_validation_options
                                 : []
                              )
}

resource aws_route53_record alias_validation_records {
  for_each = {
    for dvo in local.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true

  zone_id = var.alias_zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [
    each.value.record
  ]
}

resource "aws_acm_certificate_validation" alias_domain_validation {
  provider = aws.acm
  count    = length(aws_acm_certificate.alias_certificate)

  certificate_arn         = aws_acm_certificate.alias_certificate[0].arn
  validation_record_fqdns = [for record in aws_route53_record.alias_validation_records : record.fqdn]
}
