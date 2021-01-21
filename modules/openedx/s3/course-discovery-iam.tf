data "aws_iam_policy_document" "edxapp_course_discovery_s3_full_access" {
  count = var.enable_course_discovery ? 1 : 0
  version = "2012-10-17"
  statement {
    actions = [
      "s3:*",
    ]
    effect = "Allow"

    resources = [
      aws_s3_bucket.edxapp_course_discovery[0].arn,
      "${aws_s3_bucket.edxapp_course_discovery[0].arn}/*",
    ]
  }
}

resource "aws_iam_policy" "edxapp_course_discovery_s3_full_access" {
  count = var.enable_course_discovery ? 1 : 0
  name        = lower(join("-", [var.client_shortname, "edxapp", var.environment, "course-discovery-s3-full-access"]))
  description = "Grants full access to s3 resources in the ${aws_s3_bucket.edxapp_course_discovery[0].id} bucket"

  policy = data.aws_iam_policy_document.edxapp_course_discovery_s3_full_access[0].json
}

resource "aws_iam_user" "edxapp_course_discovery_s3_user" {
  count = var.enable_course_discovery ? 1 : 0
  name = lower(join("-", [var.client_shortname, "edxapp", var.environment, "course-discovery", "iam"]))
}

resource "aws_iam_user_policy_attachment" "edxapp_course_discovery_s3_full_access" {
  count = var.enable_course_discovery ? 1 : 0
  policy_arn = aws_iam_policy.edxapp_course_discovery_s3_full_access[0].arn
  user = aws_iam_user.edxapp_course_discovery_s3_user[0].name
}

resource "aws_iam_access_key" "edxapp_course_discovery_s3_access_key" {
  count = var.enable_course_discovery ? 1 : 0
  user = aws_iam_user.edxapp_course_discovery_s3_user[0].name
}
