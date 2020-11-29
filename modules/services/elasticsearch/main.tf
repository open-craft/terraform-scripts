data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource aws_elasticsearch_domain "openedx" {
  domain_name = "${var.customer_name}-${var.environment}-elasticsearch"
  elasticsearch_version = "1.5"

  cluster_config {
    instance_count = 2
    instance_type = "t2.small.elasticsearch"
    zone_awareness_enabled = true

    dedicated_master_enabled = true
    dedicated_master_type = "t2.small.elasticsearch"
    dedicated_master_count = 3

    zone_awareness_config {
      availability_zone_count = 2
    }
  }

  vpc_options {
    subnet_ids = [
      tolist(data.aws_subnet_ids.default.ids)[1],
      tolist(data.aws_subnet_ids.default.ids)[2],
    ]
    security_group_ids = [aws_security_group.elasticsearch.id]
  }

  ebs_options {
    ebs_enabled = true
    volume_type = "gp2"
    volume_size = 10
  }

  depends_on = [aws_iam_service_linked_role.elasticsearch]
}

resource aws_iam_service_linked_role "elasticsearch" {
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