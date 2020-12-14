data "aws_iam_policy_document" "edxapp_tracking_logs_s3_full_access" {
  version = "2012-10-17"
  statement {
    actions = [
      "s3:*",
    ]

    resources = [
      aws_s3_bucket.edxapp_tracking_logs.arn,
      "${aws_s3_bucket.edxapp_tracking_logs.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "edxapp_tracking_logs_s3_full_access" {
  name        = lower(join("-", [var.client_shortname, "edxapp", var.environment, "tracking-logs-s3-full-access"]))
  description = "Grants full access to s3 resources in the ${aws_s3_bucket.edxapp_tracking_logs.id} bucket"

  policy = data.aws_iam_policy_document.edxapp_tracking_logs_s3_full_access.json
}

resource "aws_iam_user" "edxapp_tracking_logs_s3" {
  name = lower(join("-", [var.client_shortname, "edxapp", var.environment, "tracking", "logs", "iam"]))
}

resource "aws_iam_user_policy_attachment" "edxapp_tracking_logs_s3_full_access" {
  user       = aws_iam_user.edxapp_tracking_logs_s3.name
  policy_arn = aws_iam_policy.edxapp_tracking_logs_s3_full_access.arn
}

resource "aws_iam_access_key" "edxapp_tracking_logs_s3_access_key" {
  user = aws_iam_user.edxapp_tracking_logs_s3.name
}
