provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

/*
This is only necessary for a deprecation, see
`deprecated_alternate_s3_bucket_region` in variables.tf
*/

provider "aws" {
  region     = local.aws_s3_bucket_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

  alias = "s3"
}
