resource "aws_security_group" "vpnclient" {
  name        = "vpn-client"
  description = "configure for vpn client"
  vpc_id      = aws_vpc.tf-vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.tf-vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.common_tags, {
    Name = "vpnclient"
  })
}

resource "aws_security_group" "ec2-nginx" {
  name        = "nginxsg"
  description = "configure in/out traffic to nginx on 1c-private"
  vpc_id      = aws_vpc.tf-vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.common_tags, {
    Name = "nginxsg"
  })
}
