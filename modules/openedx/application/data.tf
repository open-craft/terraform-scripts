// Get all subnets in the VPC
data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [var.aws_vpc_id]
  }
}

data "aws_acm_certificate" "certificate" {
  domain      = var.aws_acm_certificate_domain
  statuses    = ["ISSUED", "PENDING_VALIDATION"]
  most_recent = true
}

