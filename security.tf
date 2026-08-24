# Security Group for Application Load Balancer (ALB)
resource "aws_security_group" "alb_sg" {
  name        = "alb_security_group"
  description = "Allow HTTPS inbound traffic to EC2 security group"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "alb_security_group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_inbound_https_ipv4" {
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"

  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "alb_inbound_https_ipv6" {
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"

  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv6         = "::/0"
}

resource "aws_vpc_security_group_egress_rule" "alb_outbound" {
  from_port   = 8080
  to_port     = 8080
  ip_protocol = "tcp"

  security_group_id            = aws_security_group.alb_sg.id
  referenced_security_group_id = aws_security_group.ec2_sg.id
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

# Rule to allow ALB to access EC2
resource "aws_vpc_security_group_ingress_rule" "ec2_inbound_from_alb" {
  from_port   = 8080
  to_port     = 8080
  ip_protocol = "tcp"

  security_group_id            = aws_security_group.ec2_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
}

# Rule to allow download things. "Recall egress: Who I can make connections to"
resource "aws_vpc_security_group_egress_rule" "ec2_outbound_from_internet" {
  from_port   = 0
  to_port     = 65535
  ip_protocol = "-1"

  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
}

## Rule for SSH access to EC2 Instances
# data "http" "my_ip" {
#   url = "https://checkip.amazonaws.com"
# }

# resource "aws_vpc_security_group_ingress_rule" "ec2_inbound_ssh" {
#   from_port   = 22
#   to_port     = 22
#   ip_protocol = "tcp"

#   security_group_id = aws_security_group.ec2_sg.id
#   cidr_ipv4         = "${chomp(data.http.my_ip.response_body)}/32"
# }

# output "my_ip_addr" {
#   value = "${chomp(data.http.my_ip.response_body)}/32"
# }