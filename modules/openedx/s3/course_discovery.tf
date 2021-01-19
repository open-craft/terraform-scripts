data aws_iam_policy_document edxapp_course_discovery_s3_full_access {
  count = var.enable_course_discovery ? 1 : 0
  version = "2012-10-17"
  statement {
    actions = [
      "s3:*",
    ]
    effect = "Allow"

    resources = [
      aws_s3_bucket.edxapp_course_discovery.arn,
      "${aws_s3_bucket.edxapp_course_discovery.arn}/*",
    ]
  }
}


resource aws_s3_bucket edxapp_course_discovery {
  count = var.enable_course_discovery ? 1 : 0
  bucket = "${var.customer_name}-${var.environment}-edxapp-course-discovery"
  acl = "private"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "GET"]
    allowed_origins = ["*"]
  }
}

resource "aws_iam_policy" "edxapp_course_discovery_s3_full_access" {
  count = var.enable_course_discovery ? 1 : 0
  name        = "${var.customer_name}-${var.environment}-edxapp-course-discovery-s3-full-access"
  description = "Grants full access to s3 resources in the ${aws_s3_bucket.edxapp_course_discovery.id} bucket"

  policy = data.aws_iam_policy_document.edxapp_course_discovery_s3_full_access.json
}

resource aws_iam_user edxapp_course_discovery_s3_user {
  count = var.enable_course_discovery ? 1 : 0
  name = "${var.customer_name}-${var.environment}-edxapp-course-discovery-s3"
}

resource aws_iam_user_policy_attachment edxapp_course_discovery_s3_full_access {
  count = var.enable_course_discovery ? 1 : 0
  policy_arn = aws_iam_policy.edxapp_course_discovery_s3_full_access.arn
  user = aws_iam_user.edxapp_course_discovery_s3_user.name
}

resource aws_iam_access_key edxapp_course_discovery_s3_access_key {
  count = var.enable_course_discovery ? 1 : 0
  user = aws_iam_user.edxapp_course_discovery_s3_user.name
}
