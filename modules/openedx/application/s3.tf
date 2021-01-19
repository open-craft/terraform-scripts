module "s3" {
  source = "../s3"

  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  aws_region     = var.aws_region

  client_shortname = var.client_shortname
  environment      = var.environment
  enable_course_discovery = var.enable_course_discovery

  // Deprecated - do not use these anymore
  deprecated_alternate_s3_bucket_region = var.deprecated_alternate_s3_bucket_region
}
