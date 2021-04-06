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

module "elasticsearch" {
  source = "../elasticsearch"
  customer_name = var.customer_name
  edxapp_security_group_id = aws_security_group.analytics.id
  environment = var.environment

  number_of_nodes = 1
  instance_count = 1
  dedicated_master_enabled = false
  zone_awareness_enabled = false
  create_iam_service_linked_role = false

  # TODO: verify this doesn't affect accessibility if we actually use multiple analytics instances
  # not a problem right now as we are not using multiple analytics instances
  specific_subnet_ids = [aws_instance.analytics[0].subnet_id]

  extra_security_group_ids = [
    # Analytics instance needs to be able to read from Elasticsearch
    aws_security_group.analytics.id,
    # EMR instances need to be able to write to Elasticsearch
    aws_security_group.emr-master.id,
    aws_security_group.emr-slave.id,
  ]
}

resource "aws_iam_policy" "elasticsearch-all" {
  name = "${var.analytics_identifier}-elasticsearch-all"
  description = "Grants full access to ES"
  policy = data.aws_iam_policy_document.elasticsearch-all.json
}
