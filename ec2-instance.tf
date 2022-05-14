resource "aws_instance" "jump" {
  ami                    = "ami-055d15d9cfddf7bd3"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.tf-1c-public.id
  vpc_security_group_ids = [aws_security_group.jump.id]
  tags = merge(local.common_tags, {
    Name = "ec2-jump"
  })
  key_name             = aws_key_pair.master.key_name
  user_data            = filebase64("./script.sh")
  iam_instance_profile = aws_iam_instance_profile.ec2Domain.name
  root_block_device {
    tags        = local.common_tags
    volume_size = 10
    volume_type = "gp3"
  }
}

resource "aws_key_pair" "master" {
  key_name   = "master-pubkey"
  public_key = var.pubkey
}

