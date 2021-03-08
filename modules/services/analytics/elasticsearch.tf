resource "aws_iam_user" "elasticsearch" {
  name = "${var.analytics_identifier}-elasticsearch"
}

resource "aws_iam_access_key" "elasticsearch-access-key" {
  user = aws_iam_user.elasticsearch.name
}

data "aws_iam_policy_document" "elasticsearch-all" {
  version = "2012-10-17"

  statement {
    actions = [
      "es:*"
    ]
    resources = [
      "*"
    ]
    effect = "Allow"
  }
}

resource "aws_iam_policy" "elasticsearch-all" {
  name = "${var.analytics_identifier}-elasticsearch-all"
  description = "Grants full access to ES"
  policy = data.aws_iam_policy_document.elasticsearch-all.json
}
