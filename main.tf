provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  owners = ["137112412989"] # Amazon
}

resource "aws_alb" "lb_web" {
  name            = "web-alb"
  internal        = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.sg_alb.id]
  subnets         = aws_subnet.public.*.id

  tags = {
    Name = "WebALB"
  }
  
}

resource "ec2_instance" "vm_web" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"

  tags = {
    Name = "WebServerInstance"
  }
  
}