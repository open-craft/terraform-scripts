data "aws_subnet_ids" "subnets" {
  vpc_id = var.aws_vpc_id
}

data "aws_acm_certificate" "certificate" {
  domain      = var.aws_acm_certificate_domain
  statuses    = ["ISSUED"]
  most_recent = true
}

