data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "393-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDC3wTpZSQ1WxYgauhv4yc6AJ2YYOfOT+Swl+soApgqafMBgIQ3+O2bM2jmJV/nFAPvosFjjQwGDtivJFDUv1AwLRKkSl09aPn2MvtG89WZh43JGkvuoGusOo5ttFYvlKZ3R/ywUl/u6ZdC2saFiU4oWfdENB65G+bHqyyZuWOL0WPpnXMp0XdO3njhtzTkMzvD/8+MQTI8s6g5Jan91rmpxTLGHdEhvkXamlgYwk1gGtxcutRepcLlFswx1H4WoIXvZfHeVE+tAgZW/RSJ+3aeIIXu5TWm7b89EPapVrpkqDchBZeWfLjn2+p4HMzTehE17vitONt6+zNAk26aGoIJ"
}

resource "aws_instance" "web_app" {
  ami           = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "t3.micro"


  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  subnet_id = aws_subnet.public_1.id
  key_name = aws_key_pair.ec2_key

  tags = {
    Name = "WebApp"
  }

}
