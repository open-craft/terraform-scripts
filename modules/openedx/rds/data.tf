// Get all subnets in the VPC for the RDS instance
data "aws_subnet_ids" "subnets" {
  vpc_id = var.aws_vpc_id
}
