resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "prod-ecommerce-alb-5xx"
  alarm_description   = "ALB is returning too many 5xx responses."
  namespace           = "AWS/ApplicationELB"
  metric_name         = "HTTPCode_ELB_5XX_Count"
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 5
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    LoadBalancer = "app/prod-ecommerce-alb/b74d5e50354a8cc7"
  }

  treat_missing_data = "notBreaching"

  alarm_actions = [
    "arn:aws:sns:ap-south-1:809311528378:my-sns-topic"
  ]

}

resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_targets" {
  alarm_name          = "prod-ecommerce-alb-no-healthy-targets"
  alarm_description   = "ALB target group has no healthy application targets."
  namespace           = "AWS/ApplicationELB"
  metric_name         = "HealthyHostCount"
  statistic           = "Minimum"
  period              = 60
  evaluation_periods  = 2
  threshold           = 1
  comparison_operator = "LessThanThreshold"

  dimensions = {
    LoadBalancer = "app/prod-ecommerce-alb/b74d5e50354a8cc7"
    TargetGroup  = "targetgroup/prod-ecommerce-app-tg/a3d412852fe5ff76"
  }

  treat_missing_data = "breaching"
  alarm_actions = [
    "arn:aws:sns:ap-south-1:809311528378:my-sns-topic"
  ]
}

resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  alarm_name          = "prod-ecommerce-rds-high-cpu"
  alarm_description   = "RDS CPU utilization is high."
  namespace           = "AWS/RDS"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 2
  threshold           = 80
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    DBInstanceIdentifier = "prod-ecommerce-db"
  }

  treat_missing_data = "notBreaching"
  alarm_actions = [
    "arn:aws:sns:ap-south-1:809311528378:my-sns-topic"
  ]
}

resource "aws_cloudwatch_metric_alarm" "rds_free_storage" {
  alarm_name          = "prod-ecommerce-rds-low-storage"
  alarm_description   = "RDS free storage is below 5 GB."
  namespace           = "AWS/RDS"
  metric_name         = "FreeStorageSpace"
  statistic           = "Minimum"
  period              = 300
  evaluation_periods  = 2
  threshold           = 5368709120
  comparison_operator = "LessThanThreshold"

  dimensions = {
    DBInstanceIdentifier = "prod-ecommerce-db"
  }

  treat_missing_data = "notBreaching"
  alarm_actions = [
    "arn:aws:sns:ap-south-1:809311528378:my-sns-topic"
  ]
}

resource "aws_cloudwatch_metric_alarm" "asg_inservice_instances" {
  alarm_name          = "prod-ecommerce-asg-low-capacity"
  alarm_description   = "The Auto Scaling group has fewer than 2 in-service instances."
  namespace           = "AWS/AutoScaling"
  metric_name         = "GroupInServiceInstances"
  statistic           = "Minimum"
  period              = 60
  evaluation_periods  = 2
  threshold           = 2
  comparison_operator = "LessThanThreshold"

  dimensions = {
    AutoScalingGroupName = "prod-ecommerce-asg"
  }

  treat_missing_data = "breaching"
  alarm_actions = [
    "arn:aws:sns:ap-south-1:809311528378:my-sns-topic"
  ]
}
