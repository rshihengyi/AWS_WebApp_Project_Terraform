provider "aws" {
  region = "us-east-1"
}


# resource "aws_alb" "lb_web" {
#   name            = "web-alb"
#   internal        = false
#   load_balancer_type = "application"
#   security_groups = [aws_security_group.sg_alb.id]
#   subnets         = aws_subnet.public.*.id

#   tags = {
#     Name = "WebALB"
#   }
  
# }