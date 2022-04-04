locals {
  ingress = [{
    port        = 443
    description = "Allow HTTPS"
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
    },
    {
      port        = 80
      description = "Allow HTTP"
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      port        = 22
      description = "Allow SSH"
      protocol    = "tcp"
      cidr_blocks = var.allow_ip
  }]
}

data "template_file" "user_data" {
  template = file("${abspath(path.module)}/userdata.yaml")
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "aws_vpc" "main" {
  id = var.vpc_id #"vpc-7130d30c"
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.main.id

  dynamic "ingress" {
    for_each = local.ingress
    content {
      description      = ingress.value.description
      from_port        = ingress.value.port
      to_port          = ingress.value.port
      protocol         = ingress.value.protocol
      cidr_blocks      = [ingress.value.cidr_blocks]#[data.aws_vpc.main.cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  }

  egress {
    description      = "outgoing for everyone"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_key_pair" "deployer" {
  key_name = "deployer-key"
  public_key = var.public_key
}

resource "aws_instance" "app_server" {
  ami           = "${data.aws_ami.amazon-linux-2.id}" #"ami-033b95fb8079dc481"
  instance_type = var.instance_type
  key_name = "${aws_key_pair.deployer.key_name}"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  user_data = data.template_file.user_data.rendered
  tags = {
    Name = var.server_name
  }
}