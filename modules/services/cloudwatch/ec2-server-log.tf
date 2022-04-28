data aws_iam_policy_document cloudwatch_log_policy {
  statement {
      actions = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
      ]
      resources = ["*"]
  }
}

resource aws_iam_policy cloudwatch_server_log_policy {
  name = "${var.customer_name}-${var.environment}-cloudwatch-log-policy"
  description = "cloudwatch-log policy"

  policy = data.aws_iam_policy_document.cloudwatch_log_policy.json
}

resource aws_iam_role cloudwatch_server_log_role {
  name = "${var.customer_name}-${var.environment}-log-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource aws_iam_role_policy_attachment role_policy_attach {
  role = aws_iam_role.cloudwatch_server_log_role.name
  policy_arn = aws_iam_policy.cloudwatch_server_log_policy.arn
}

resource aws_iam_instance_profile server_logs_profile {
  name = "${var.customer_name}-${var.environment}-log-profile"
  role = aws_iam_role.cloudwatch_server_log_role.name
}


resource aws_cloudwatch_log_group server_log_group {
  tags = {
    Name = "${var.customer_name}-${var.environment}-server-log-group"
  }
}

resource aws_cloudwatch_log_resource_policy openedx_cloudwatch_log_resource_policy {
  policy_name = "${var.customer_name}-${var.environment}-cloudwatch-log-resource-policy"
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = {
      Effect = "Allow"
      Principal = {
        Service = "es.amazonaws.com"
      },
      Action = [
        "logs:PutLogEvents",
        "logs:PutLogEventsBatch",
        "logs:CreateLogStream",
        "logs:CreateLogGroup",
        "logs:DescribeLogStreams"
      ],
      Resource = ["*"]
    }
  })
}

resource aws_cloudwatch_log_stream log_stream {
  name = "${var.customer_name}-${var.environment}-server-log-stream"
  log_group_name = aws_cloudwatch_log_group.server_log_group.name
}
