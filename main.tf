provider "aws" {
  region = "us-east-1"
}


resource "aws_alb" "lb_web" {
  name            = "web-alb"
  internal        = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb_sg.id]
  subnets         = aws_subnet.public_2.id

  tags = {
    Name = "WebALB"
  }
}

resource "aws_lb_target_group" "alb_to_ec2" {
  name     = "alb2ec2"
  port     = 8080                                               # Send to port 8080 of target
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "listen2https" {
  load_balancer_arn = aws_lb.listen2https.arn
  port              = "443"                                     # alb listens to https traffic 
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"                                # alb will send incoming request to targets
    target_group_arn = aws_lb_target_group.alb_to_ec2.arn
  }
}

resource "aws_lb_target_group_attachment" "alb_tg_attach" {     # "attaches" target group to ec2
  target_group_arn = aws_lb_target_group.alb_to_ec2.arn
  target_id        = aws_instance.web_app.id
  port             = 8080                                       # port alb "talks" to
}





