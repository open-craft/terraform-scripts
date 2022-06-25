locals {
  last_instance = element(var.instances, length(var.instances) - 1)

  launch_template_tags = {
    Name    = "${local.last_instance.tags.Name}-as"
    Release = var.release
  }
}

resource aws_ami_from_instance images {
  for_each           = {for instance in var.instances : instance.id => instance}
  name               = each.value.tags.Name
  source_instance_id = each.value.id
}

resource aws_launch_template edxapp {
  name        = "edx-${var.client_shortname}-${var.environment}"
  description = "Managed by Terraform"

  instance_type                        = var.auto_scaling_instance_type
  update_default_version               = true
  image_id                             = aws_ami_from_instance.images[local.last_instance.id].id
  ebs_optimized                        = true
  instance_initiated_shutdown_behavior = "terminate"
  key_name                             = "appserver"

  vpc_security_group_ids = [var.security_group_id]

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags          = local.launch_template_tags
  }

  tag_specifications {
    resource_type = "volume"
    tags          = local.launch_template_tags
  }

  iam_instance_profile {
    name = var.auto_scaling_iam_instance_profile
  }
}

data aws_subnet_ids subnets {
  vpc_id = var.aws_vpc_id
}

resource aws_autoscaling_group edxapp {
  name = "edx-${var.client_shortname}-${var.environment}"

  target_group_arns    = [var.lb_target_group_arn]
  termination_policies = ["OldestLaunchTemplate"]
  vpc_zone_identifier  = data.aws_subnet_ids.subnets.ids

  desired_capacity = var.auto_scaling_desired_capacity
  min_size         = var.auto_scaling_min_instances
  max_size         = var.auto_scaling_max_instances

  health_check_grace_period = 100

  instance_refresh {
    strategy = "Rolling"
  }

  launch_template {
    id      = aws_launch_template.edxapp.id
    version = aws_launch_template.edxapp.latest_version
  }
}

resource aws_autoscaling_policy target_tracking {
  name                   = "Target Tracking Policy"
  autoscaling_group_name = aws_autoscaling_group.edxapp.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 40
  }
}
