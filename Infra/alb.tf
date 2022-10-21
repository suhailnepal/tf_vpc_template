data "aws_acm_certificate" "this" {
  domain      = "99devops.com"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}


resource "aws_lb" "lb" {
  name               = "${var.env}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [module.vpc.public_subnets[0],module.vpc.private_subnets[1]]

  enable_deletion_protection = true

  tags = {
    Environment = "poc"
  }
}

## Listener

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.lb.arn

  port     = 80
  protocol = "HTTP"

  #ssl_policy = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = data.aws_acm_certificate.this.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

## Target Group

resource "aws_lb_target_group" "tg" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  load_balancing_algorithm_type = "least_outstanding_requests"

  health_check {
    healthy_threshold   = 2
    interval            = 30
    protocol            = "HTTP"
    unhealthy_threshold = 2
  }

  depends_on = [
    aws_lb.lb
  ]
/*
  lifecycle {
    create_before_destroy = true
  }
 */ 
}

## Target group attachment

resource "aws_lb_target_group_attachment" "tg_attachment" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.nginx_server.id
  port             = 80
}

## Load Balancer Security Group

resource "aws_security_group" "lb_sg" {
  name        = "${var.env}-lb-sg"
  description = "Security group for load balancer"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "ingress_443" {
  security_group_id = aws_security_group.lb_sg.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress_80" {
  security_group_id = aws_security_group.lb_sg.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb_sg.id
}