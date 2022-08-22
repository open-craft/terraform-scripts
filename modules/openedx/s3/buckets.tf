resource "aws_s3_bucket" "edxapp" {
  bucket = lower(join("-", [var.client_shortname, "edxapp", var.environment]))
}

resource "aws_s3_bucket_acl" "edxapp_acl" {
  bucket = aws_s3_bucket.edxapp.id
  acl    = "private"
}

resource "aws_s3_bucket_cors_configuration" "edxapp_cors" {
  bucket = aws_s3_bucket.edxapp.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "GET"]
    allowed_origins = ["*"]
  }
}

resource "aws_s3_bucket" "edxapp_tracking_logs" {
  bucket = lower(join("-", [var.client_shortname, "edxapp", var.environment, "tracking", "logs"]))
}

resource "aws_s3_bucket_acl" "edxapp_tracking_logs_acl" {
  bucket = aws_s3_bucket.edxapp_tracking_logs.id
  acl    = "private"
}

resource "aws_s3_bucket" "edxapp_course_discovery" {
  count  = var.enable_course_discovery ? 1 : 0
  bucket = lower(join("-", [var.client_shortname, "edxapp", var.environment, "course-discovery"]))
}

resource "aws_s3_bucket_acl" "edxapp_course_discovery_acl" {
  count  = length(aws_s3_bucket.edxapp_course_discovery)
  bucket = aws_s3_bucket.edxapp_course_discovery[0].id
  acl    = "private"
}

resource "aws_s3_bucket_cors_configuration" "edxapp_course_discovery_cors" {
  count  = length(aws_s3_bucket.edxapp_course_discovery)
  bucket = aws_s3_bucket.edxapp_course_discovery[0].id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "GET"]
    allowed_origins = ["*"]
  }
}
