resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = lower(join("-", [var.client_shortname, var.environment, var.service_name]))

  origin {
    domain_name         = var.origin_domain
    origin_id           = var.origin_domain

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
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.origin_domain

    default_ttl            = var.cache_expiration
    max_ttl                = var.cache_expiration
    compress               = true
    viewer_protocol_policy = "allow-all"

    forwarded_values {
      query_string = true

      headers = [
        "*",
      ]

      cookies {
        forward           = "none"
      }
    }
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
    cloudfront_default_certificate = true
  }
}
