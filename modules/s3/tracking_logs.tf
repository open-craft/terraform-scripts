data aws_iam_policy_document edxapp_tracking_logs_s3_full_access {
  version = "2012-10-17"
  statement {
    actions = [
      "s3:*",
    ]
    effect = "Allow"

    resources = [
      aws_s3_bucket.edxapp_tracking_logs.arn,
      "${aws_s3_bucket.edxapp_tracking_logs.arn}/*",
    ]
  }
}


resource aws_s3_bucket edxapp_tracking_logs {
  bucket = "${var.customer_name}-${var.environment}-edxapp-tracking-logs"
  acl = "private"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "GET"]
    allowed_origins = ["*"]
  }
}

resource "aws_iam_policy" "edxapp_tracking_logs_s3_full_access" {
  name        = "${var.customer_name}-${var.environment}-edxapp-tracking-logs-s3-full-access"
  description = "Grants full access to s3 resources in the ${aws_s3_bucket.edxapp_tracking_logs.id} bucket"

  policy = data.aws_iam_policy_document.edxapp_tracking_logs_s3_full_access.json
}

resource aws_iam_user edxapp_tracking_logs_s3_user {
  name = "${var.customer_name}-${var.environment}-edxapp-tracking-logs-s3"
}

resource aws_iam_user_policy_attachment edxapp_tracking_logs_s3_full_access {
  policy_arn = aws_iam_policy.edxapp_tracking_logs_s3_full_access.arn
  user = aws_iam_user.edxapp_tracking_logs_s3_user.name
}

resource aws_iam_access_key edxapp_tracking_logs_s3_access_key {
  user = aws_iam_user.edxapp_tracking_logs_s3_user.name
}
