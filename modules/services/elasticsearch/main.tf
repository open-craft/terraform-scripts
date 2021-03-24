data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource aws_elasticsearch_domain "openedx" {
  domain_name = "${var.customer_name}-${var.environment}-elasticsearch"
  elasticsearch_version = "1.5"

  cluster_config {
    instance_count = var.instance_count
    instance_type = var.elasticsearch_instance_type
    zone_awareness_enabled = var.zone_awareness_enabled

    dedicated_master_enabled = var.dedicated_master_enabled
    dedicated_master_type = var.elasticsearch_instance_type
    dedicated_master_count = var.number_of_nodes

    dynamic zone_awareness_config {
      for_each = var.zone_awareness_enabled == true ? [1] : []
      content {
        availability_zone_count = var.availability_zone_count
      }
    }
  }

  vpc_options {
    subnet_ids = length(var.specific_subnet_ids) == 0 ? tolist(data.aws_subnet_ids.default.ids) : var.specific_subnet_ids
    security_group_ids = concat([aws_security_group.elasticsearch.id], var.extra_security_group_ids)
  }

  ebs_options {
    ebs_enabled = true
    volume_type = "gp2"
    volume_size = 10
  }

  access_policies = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "es:*",
      "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.customer_name}-${var.environment}-elasticsearch/*"
    }
  ]
}
POLICY

  depends_on = [aws_iam_service_linked_role.elasticsearch]
}

resource aws_iam_service_linked_role "elasticsearch" {
  # there can only be one
  count = var.create_iam_service_linked_role ? 1 : 0
  aws_service_name = "es.amazonaws.com"
  description      = "Allows Amazon ES to manage AWS resources for a domain on your behalf."
}

resource aws_security_group "elasticsearch" {
  name = "${var.customer_name}-${var.environment}-edxapp-elasticsearch"
}

resource aws_security_group_rule "es-edxapp-inbound-rule" {
  security_group_id = aws_security_group.elasticsearch.id
  source_security_group_id = var.edxapp_security_group_id
  type = "ingress"

  from_port = 0
  to_port = 0
  protocol = "-1"
}

resource aws_security_group_rule "es-edxapp-inbound-own-rule" {
  security_group_id = aws_security_group.elasticsearch.id
  source_security_group_id = aws_security_group.elasticsearch.id
  type = "ingress"

  from_port = 0
  to_port = 0
  protocol = "-1"
}

resource aws_security_group_rule "es-edxapp-outbound-rule" {
  security_group_id = aws_security_group.elasticsearch.id
  type = "egress"

  from_port = 0
  to_port = 0
  protocol = "all"
  cidr_blocks = ["0.0.0.0/0"]
}
