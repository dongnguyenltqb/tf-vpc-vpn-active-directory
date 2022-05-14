output "ad_name" {
  value = aws_directory_service_directory.vpn.name
}

output "ad_id" {
  value = aws_directory_service_directory.vpn.id
}


output "vpn_endpoint" {
  value = replace(aws_ec2_client_vpn_endpoint.ep1.dns_name, "*.", "endpoint.")
}

output "jump_server_ip" {
  value = aws_instance.jump.public_ip
}

output "jump_server_private_ip" {
  value = aws_instance.jump.private_ip
}
