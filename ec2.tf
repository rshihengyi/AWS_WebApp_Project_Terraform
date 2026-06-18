data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_eip" "ec2" {
  instance = aws_instance.web_app.id
  domain   = "vpc"
}

resource "aws_instance" "web_app" {
  ami           = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  subnet_id              = aws_subnet.public_1.id
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  tags = {
    Name = "WebApp"
    App  = "Static-Portfolio"
    Env  = "dev"
  }

  user_data = <<EOF
#!/bin/bash
sudo dnf -y install docker
sudo systemctl restart docker
sudo groupadd docker
sudo usermod -aG docker ec2-user
newgrp docker
  EOF
}
