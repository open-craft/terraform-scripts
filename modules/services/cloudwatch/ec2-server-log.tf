
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
  count       = length(var.ec2_instances)
  name        = "${element(var.ec2_instances, count.index)}-${var.environment}-cloudwatch-log-policy"
  description = "cloudwatch-log policy"

  policy = data.aws_iam_policy_document.cloudwatch_log_policy.json
}

resource aws_iam_role cloudwatch_server_log_role {
  count              = length(var.ec2_instances)
  name               = "${element(var.ec2_instances, count.index)}-${var.environment}-log-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
    }
  ]
}
EOF
}

resource aws_iam_role_policy_attachment role_policy_attach {
  role       = aws_iam_role.cloudwatch_server_log_role.name
  policy_arn = aws_iam_policy.cloudwatch_server_log_policy.arn
}

resource aws_iam_instance_profile ec2_log_profile {
  name = "log-profile"
  role = aws_iam_role.role.name
}


resource aws_cloudwatch_log_group server_log_group
  tags              =  {
    Name = "Server log"
  }
}
resource aws_cloudwatch_log_resource_policy "openedx" {
  policy_name = "openedx-cloudwatch-log-resource-policy"

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
  count          = length(var.ec2_instances)
  name           = "${element(var.ec2_instances, count.index)}-${var.environment}-server-log-stream"
  log_group_name = aws_cloudwatch_log_group.server_log_group.name
}