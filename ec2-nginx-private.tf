// this instance is used for testing connection from
// vpn client, installed nginx and open port 80
resource "aws_instance" "nginx" {
  ami                    = "ami-055d15d9cfddf7bd3"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.tf-1c-private.id
  vpc_security_group_ids = [aws_security_group.ec2-nginx.id]
  tags = merge(local.common_tags, {
    Name = "ec2-nginx-1c-private"
  })
  key_name  = aws_key_pair.nginx.key_name
  user_data = filebase64("./script.sh")
  root_block_device {
    tags        = local.common_tags
    volume_size = 10
    volume_type = "gp3"
  }
}

resource "aws_key_pair" "nginx" {
  key_name   = "nginx-pubkey"
  public_key = var.pubkey
}

