resource "aws_autoscaling_group" "app" {
  name                      = "prod-ecommerce-asg"
  min_size                  = 2
  max_size                  = 2
  desired_capacity          = 2
  health_check_type         = "ELB"
  health_check_grace_period = 300
  default_instance_warmup   = 300

  lifecycle {
    ignore_changes = [
      force_delete,
      force_delete_warm_pool,
      ignore_failed_scaling_activities,
      wait_for_capacity_timeout,
    ]
  }

  vpc_zone_identifier = [
    aws_subnet.app_a.id,
    aws_subnet.app_b.id
  ]

  target_group_arns = [
    aws_lb_target_group.app.arn
  ]

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Default"
  }

  instance_maintenance_policy {
    min_healthy_percentage = 100
    max_healthy_percentage = 110
  }

  enabled_metrics = [
    "GroupAndWarmPoolDesiredCapacity",
    "GroupMinSize",
    "WarmPoolMinSize",
    "WarmPoolTerminatingCapacity",
    "GroupTerminatingCapacity",
    "GroupPendingCapacity",
    "GroupStandbyCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "WarmPoolDesiredCapacity",
    "GroupTerminatingInstances",
    "GroupTerminatingRetainedInstances",
    "GroupTerminatingRetainedCapacity",
    "WarmPoolTerminatingRetainedCapacity",
    "WarmPoolTotalCapacity",
    "GroupAndWarmPoolTotalCapacity",
    "GroupMaxSize",
    "GroupStandbyInstances",
    "GroupTotalCapacity",
    "WarmPoolPendingCapacity",
    "GroupDesiredCapacity",
    "GroupInServiceCapacity",
    "GroupTotalInstances",
    "WarmPoolPendingRetainedCapacity",
    "WarmPoolWarmedCapacity"
  ]

  metrics_granularity = "1Minute"
}
