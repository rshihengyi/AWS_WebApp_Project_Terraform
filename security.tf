# Security Group for Application Load Balancer (ALB)
resource "aws_security_group" "alb_sg" {
  name        = "alb_security_group"
  description = "Allow HTTPS inbound traffic to EC2 security group"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "alb_security_group"
  }
}

resource "aws_security_group_rule" "alb_inbound_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  
  security_group_id = aws_security_group.alb_sg.id
  #cidr_blocks       = "0.0.0.0/0"
}

# Security Group for EC2 Instances
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_security_group"
  description = "Allow inbound traffic from ALB security group"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "ec2_security_group"
  }
}

resource "aws_security_group_rule" "ec2_inbound_from_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"

  security_group_id        = aws_security_group.ec2_sg.id
  source_security_group_id = aws_security_group.alb_sg.id
}



