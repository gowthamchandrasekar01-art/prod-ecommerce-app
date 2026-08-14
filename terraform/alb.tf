resource "aws_lb" "prod_ecommerce" {
  name               = "prod-ecommerce-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
}

resource "aws_lb_target_group" "app" {
  name        = "prod-ecommerce-app-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.prod_ecommerce.id

  health_check {
    enabled             = true
    protocol            = "HTTP"
    port                = "traffic-port"
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
}
