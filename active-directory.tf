resource "aws_directory_service_directory" "vpn" {
  name     = var.ad_name
  password = var.ad_password
  edition  = "Standard"
  type     = "MicrosoftAD"

  vpc_settings {
    vpc_id     = aws_vpc.tf-vpc.id
    subnet_ids = [aws_subnet.tf-1a-private.id, aws_subnet.tf-1b-private.id]
  }

  tags = merge(local.common_tags, {
    Name = "ad_for_vpn_client_endpoint"
  })
}
