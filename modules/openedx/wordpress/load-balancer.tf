resource "aws_lb_target_group" "wordpress" {
  name     = local.lb_target_group_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.aws_vpc_id
}

resource "aws_lb_listener" "wordpress" {
  load_balancer_arn = var.application_load_balancer_arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
