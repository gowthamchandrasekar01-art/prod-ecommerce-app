resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.prod_ecommerce.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn

    forward {
      target_group {
        arn    = aws_lb_target_group.app.arn
        weight = 1
      }

      stickiness {
        enabled  = false
        duration = 3600
      }
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.prod_ecommerce.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-Res-PQ-2025-09"
  certificate_arn   = "arn:aws:acm:ap-south-1:809311528378:certificate/cbfd4c68-3613-4273-9c73-5d5e2d73c562"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn

    forward {
      target_group {
        arn    = aws_lb_target_group.app.arn
        weight = 1
      }

      stickiness {
        enabled  = false
        duration = 3600
      }
    }
  }
}
