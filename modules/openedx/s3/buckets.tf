resource "aws_s3_bucket" "edxapp" {
  bucket = lower(join("-", [var.client_shortname, "edxapp", var.environment]))
  acl    = "private"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "GET"]
    allowed_origins = ["*"]
  }

  provider = aws.s3
}

resource "aws_s3_bucket" "edxapp_tracking_logs" {
  bucket = lower(join("-", [var.client_shortname, "edxapp", var.environment, "tracking", "logs"]))
  acl    = "private"

  provider = aws.s3
}

resource "aws_s3_bucket" "edxapp_course_discovery" {
  count = var.enable_course_discovery ? 1 : 0
  bucket = lower(join("-", [var.client_shortname, "edxapp", var.environment, "course-discovery"]))
  acl = "private"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "GET"]
    allowed_origins = ["*"]
  }

  provider = aws.s3
}
