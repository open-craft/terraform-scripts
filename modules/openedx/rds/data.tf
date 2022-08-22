// Get all subnets in the VPC for the RDS instance
data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [var.aws_vpc_id]
  }
}
