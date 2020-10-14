resource "aws_lb" "application" {
  name               = local.load_balancer_name
  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.subnets.ids
  security_groups = [
    aws_security_group.edxapp_appserver.id
  ]
}

resource "aws_lb_target_group" "edxapp" {
  name     = local.lb_target_group_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.aws_vpc_id
}

resource "aws_lb_listener" "edxapp" {
  load_balancer_arn = aws_lb.application.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.edxapp.arn
  }
}
