data aws_iam_policy_document edxapp_discovery_s3_full_access {
  version = "2012-10-17"
  statement {
    actions = [
      "s3:*",
    ]
    effect = "Allow"

    resources = [
      aws_s3_bucket.edxapp_discovery.arn,
      "${aws_s3_bucket.edxapp_discovery.arn}/*",
    ]
  }
}


resource aws_s3_bucket edxapp_discovery {
  bucket = "${var.customer_name}-${var.environment}-edxapp-discovery"
  acl = "private"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "GET"]
    allowed_origins = ["*"]
  }
}

resource "aws_iam_policy" "edxapp_discovery_s3_full_access" {
  name        = "${var.customer_name}-${var.environment}-edxapp-discovery-s3-full-access"
  description = "Grants full access to s3 resources in the ${aws_s3_bucket.edxapp_discovery.id} bucket"

  policy = data.aws_iam_policy_document.edxapp_discovery_s3_full_access.json
}

resource aws_iam_user edxapp_discovery_s3_user {
  name = "${var.customer_name}-${var.environment}-edxapp-discovery-s3"
}

resource aws_iam_user_policy_attachment edxapp_discovery_s3_full_access {
  policy_arn = aws_iam_policy.edxapp_discovery_s3_full_access.arn
  user = aws_iam_user.edxapp_discovery_s3_user.name
}

resource aws_iam_access_key edxapp_discovery_s3_access_key {
  user = aws_iam_user.edxapp_discovery_s3_user.name
}