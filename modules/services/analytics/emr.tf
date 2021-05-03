data aws_iam_policy_document provision_emr_clusters {
  version = "2012-10-17"

  statement {
    actions = [
      "elasticmapreduce:*",
      "iam:PassRole",
      "route53:Get*",
      "route53:List*",
      "ec2:DescribeInstances",
      "rds:DescribeDBInstances",
      "s3:*",
    ]

    effect = "Allow"

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "provision_emr_clusters" {
  name = "${var.analytics_identifier}-provision-emr-clusters"
  description = "Grants full access to launch and terminate EMR clusters"

  policy = data.aws_iam_policy_document.provision_emr_clusters.json
}

data "aws_iam_policy_document" "ec2-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "provision-role" {
  name = "${var.analytics_identifier}-edx"
  description = var.provision_role_description
  assume_role_policy = data.aws_iam_policy_document.ec2-assume-role-policy.json
}

resource "aws_iam_role_policy_attachment" "provision-role-attachment" {
  role = aws_iam_role.provision-role.name
  policy_arn = aws_iam_policy.provision_emr_clusters.arn
}

resource "aws_iam_instance_profile" "provision-role-instance-profile" {
  name = aws_iam_role.provision-role.name
  role = aws_iam_role.provision-role.name
}

# Specific EMR roles

data "aws_iam_policy_document" "emr-default-role-policy" {
  version = "2008-10-17"
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["elasticmapreduce.amazonaws.com"]
      type = "Service"
    }
  }
}

resource "aws_iam_role" "emr_default_role" {
  name = "EMR_DefaultRole"
  assume_role_policy = data.aws_iam_policy_document.emr-default-role-policy.json
}

resource "aws_iam_role_policy_attachment" "emr-default-role-attachment" {
  role = aws_iam_role.emr_default_role.name
  policy_arn = var.emr_service_role_policy
}

data "aws_iam_policy_document" "ec2-assume-role-policy-2008" {
  version = "2008-10-17"

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "emr-ec2-default-role" {
  name = "EMR_EC2_DefaultRole"
  assume_role_policy = data.aws_iam_policy_document.ec2-assume-role-policy-2008.json
}

resource "aws_iam_role_policy_attachment" "emr-ec2-default-role-attachment" {
  role = aws_iam_role.emr-ec2-default-role.name
  policy_arn = var.emr_ec2_service_role_policy
}

resource "aws_iam_instance_profile" "emr-ec2-default-role-instance-profile" {
  name = aws_iam_role.emr-ec2-default-role.name
  role = aws_iam_role.emr-ec2-default-role.name
}

# Specific EMR security groups

resource "aws_security_group" "emr-master" {
  name = "ElasticMapReduce-master"
  description = var.emr_master_security_group_description
}

resource "aws_security_group_rule" "emr-master-tcp-same-inbound" {
  type = "ingress"
  security_group_id = aws_security_group.emr-master.id
  source_security_group_id = aws_security_group.emr-master.id

  from_port = local.any_port
  to_port = local.maximum_port

  protocol = local.tcp_protocol
}

resource "aws_security_group_rule" "emr-master-udp-same-inbound" {
  type = "ingress"
  security_group_id = aws_security_group.emr-master.id
  source_security_group_id = aws_security_group.emr-master.id

  from_port = local.any_port
  to_port = local.maximum_port

  protocol = local.udp_protocol
}

resource "aws_security_group_rule" "emr-master-tcp-slave-inbound" {
  type = "ingress"
  security_group_id = aws_security_group.emr-master.id
  source_security_group_id = aws_security_group.emr-slave.id

  from_port = local.any_port
  to_port = local.maximum_port

  protocol = local.tcp_protocol
}

resource "aws_security_group_rule" "emr-master-udp-slave-inbound" {
  type = "ingress"
  security_group_id = aws_security_group.emr-master.id
  source_security_group_id = aws_security_group.emr-slave.id

  from_port = local.any_port
  to_port = local.maximum_port

  protocol = local.udp_protocol
}

resource "aws_security_group_rule" "emr-master-icmp-same-inbound" {
  type = "ingress"
  security_group_id = aws_security_group.emr-master.id
  source_security_group_id = aws_security_group.emr-master.id

  from_port = local.all_ports
  to_port = local.all_ports

  protocol = local.icmp_protocol
}

resource "aws_security_group_rule" "emr-master-icmp-slave-inbound" {
  type = "ingress"
  security_group_id = aws_security_group.emr-master.id
  source_security_group_id = aws_security_group.emr-slave.id

  from_port = local.all_ports
  to_port = local.all_ports

  protocol = local.icmp_protocol
}

resource "aws_security_group_rule" "emr-master-outbound" {
  type = "egress"
  security_group_id = aws_security_group.emr-master.id

  from_port = local.any_port
  to_port = local.any_port
  protocol = local.any_protocol
  cidr_blocks = local.all_ips
}

## custom ssh access from analytics to the EMR

resource "aws_security_group_rule" "emr-master-analytics-inbound" {
  type = "ingress"
  security_group_id = aws_security_group.emr-master.id
  source_security_group_id = aws_security_group.analytics.id

  from_port = local.ssh_port
  to_port = local.ssh_port
  protocol = local.tcp_protocol
}


resource "aws_security_group" "emr-slave" {
  name = "ElasticMapReduce-slave"
  description = var.emr_slave_security_group_description
}

resource "aws_security_group_rule" "emr-slave-tcp-same-inbound" {
  type = "ingress"
  security_group_id = aws_security_group.emr-slave.id
  source_security_group_id = aws_security_group.emr-slave.id

  from_port = local.any_port
  to_port = local.maximum_port

  protocol = local.tcp_protocol
}

resource "aws_security_group_rule" "emr-slave-udp-same-inbound" {
  type = "ingress"
  security_group_id = aws_security_group.emr-slave.id
  source_security_group_id = aws_security_group.emr-slave.id

  from_port = local.any_port
  to_port = local.maximum_port

  protocol = local.udp_protocol
}

resource "aws_security_group_rule" "emr-slave-tcp-master-inbound" {
  type = "ingress"
  security_group_id = aws_security_group.emr-slave.id
  source_security_group_id = aws_security_group.emr-master.id

  from_port = local.any_port
  to_port = local.maximum_port

  protocol = local.tcp_protocol
}

resource "aws_security_group_rule" "emr-slave-udp-master-inbound" {
  type = "ingress"
  security_group_id = aws_security_group.emr-slave.id
  source_security_group_id = aws_security_group.emr-master.id

  from_port = local.any_port
  to_port = local.maximum_port

  protocol = local.udp_protocol
}

resource "aws_security_group_rule" "emr-slave-icmp-same-inbound" {
  type = "ingress"
  security_group_id = aws_security_group.emr-slave.id
  source_security_group_id = aws_security_group.emr-slave.id

  from_port = local.all_ports
  to_port = local.all_ports

  protocol = local.icmp_protocol
}

resource "aws_security_group_rule" "emr-slave-icmp-master-inbound" {
  type = "ingress"
  security_group_id = aws_security_group.emr-slave.id
  source_security_group_id = aws_security_group.emr-master.id

  from_port = local.all_ports
  to_port = local.all_ports

  protocol = local.icmp_protocol
}

resource "aws_security_group_rule" "emr-slave-outbound" {
  type = "egress"
  security_group_id = aws_security_group.emr-slave.id

  from_port = local.any_port
  to_port = local.any_port
  protocol = local.any_protocol
  cidr_blocks = local.all_ips
}

# Adding the elasticsearch-all policy to EMR_EC2_DefaultRole

resource "aws_iam_role_policy_attachment" "emr-ec2-role-elasticsearch-attachment" {
  role = aws_iam_role.emr-ec2-default-role.name
  policy_arn = aws_iam_policy.elasticsearch-all.arn
}
