# ✅ modules/alb/backend/main.tf

resource "aws_lb" "backend_alb" {
  name               = "backend-alb"
  internal           = true  # 내부 전용 ALB
  load_balancer_type = "application"
  security_groups    = var.lb_sg_ids # ALB 보안그룹 
  subnets            = var.public_subnet_ids  # 필요에 따라 private_subnet_ids도 가능

  tags = {
    Name = "backend-alb"
  }
}

resource "aws_lb_target_group" "backend_tg" {
  name        = "backend-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/api/hello"
    protocol            = "HTTP"
    matcher             = "200-299"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "backend_listener" {
  load_balancer_arn = aws_lb.backend_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }
}