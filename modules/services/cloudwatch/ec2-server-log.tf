data aws_iam_policy_document server-log-publishing-policy {
  statement {
    actions = [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:PutLogEventsBatch",
    ]

    resources = ["arn:aws:logs:*"]
  }
}

data "aws_iam_policy_document" server-log-role-policy {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource aws_iam_policy server-log-publishing-policy {
  name = "${var.customer_name}-${var.environment}-cloudwatch-log-policy"
  policy = data.aws_iam_policy_document.server-log-publishing-policy.json
}

resource aws_iam_role server-log-role {
  name = "${var.customer_name}-${var.environment}-log-role"
  assume_role_policy = data.aws_iam_policy_document.server-log-role-policy.json
}

resource aws_iam_role_policy_attachment server-log-role-policy-attachment {
  role = aws_iam_role.server-log-role.name
  policy_arn = aws_iam_policy.server-log-publishing-policy.arn
}

resource aws_iam_instance_profile server-log-profile {
  name = "${var.customer_name}-${var.environment}-log-profile"
  role = aws_iam_role.server-log-role.name
}

resource aws_cloudwatch_log_group server-log-group {
  name = "${var.customer_name}-${var.environment}-server-log-group"
}
