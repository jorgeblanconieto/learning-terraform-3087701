data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "blog" {
  ami           = data.aws_ami.app_ami.id
  instance_type = "t3.nano"

  vpc_security_groups_ids = [aws_security_group.sg_blog.id]

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_security_group" "sg_blog"{
  name        = "sg_blog"
  description = "Allow HTTP and HTTPS in. Allow everything"

  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "rl_blog_http_in" {
  type       = "ingress"
  from_port  = 80
  to_port    = 80
  protocol   = "tcp"
  cidr_block = ["0.0.0.0/0"]

  security_group_id = aws_security_group.sg_blog.id
}

resource "aws_security_group_rule" "rl_blog_everything_out" {
  type       = "egress"
  from_port  = 0
  to_port    = 0
  protocol   = "-1"
  cidr_block = ["0.0.0.0/0"]

  security_group_id = aws_security_group.sg_blog.id
}
