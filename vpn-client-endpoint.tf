resource "aws_ec2_client_vpn_endpoint" "ep1" {
  description            = "clientvpn-endpoint1, auth by active directory"
  server_certificate_arn = aws_acm_certificate.cert.arn
  client_cidr_block      = "10.6.0.0/16"
  // all traffic will go to VPN
  split_tunnel       = false
  transport_protocol = "udp"
  vpc_id             = aws_vpc.tf-vpc.id
  vpn_port           = 443
  security_group_ids = [aws_security_group.vpnclient.id]
  dns_servers            = ["10.5.0.2"]
  tags = merge(local.common_tags, {
    Name = "clientvpn-endpoint1"
  })

  authentication_options {
    type                = "directory-service-authentication"
    active_directory_id = aws_directory_service_directory.vpn.id
  }

  connection_log_options {
    enabled               = true
    cloudwatch_log_group  = aws_cloudwatch_log_group.vpn.name
    cloudwatch_log_stream = aws_cloudwatch_log_stream.vpn.name
  }
}

//  Associate one or more target networks (subnets in your VPC) with a client VPN endpoint.
resource "aws_ec2_client_vpn_network_association" "ep1-1a" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.ep1.id
  subnet_id              = aws_subnet.tf-1a-private.id
}

resource "aws_ec2_client_vpn_network_association" "ep1-1b" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.ep1.id
  subnet_id              = aws_subnet.tf-1b-private.id
}

resource "aws_ec2_client_vpn_network_association" "ep1-1c" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.ep1.id
  subnet_id              = aws_subnet.tf-1c-private.id
}

// Auth rule for VPC traffic
resource "aws_ec2_client_vpn_authorization_rule" "allow" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.ep1.id
  target_network_cidr    = aws_vpc.tf-vpc.cidr_block
  authorize_all_groups   = true
}

// Auth rule for Internet traffic
resource "aws_ec2_client_vpn_authorization_rule" "allowInternet" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.ep1.id
  target_network_cidr    = "0.0.0.0/0"
  authorize_all_groups   = true
}

// Route internet traffic of client to private subnet
// then to NAT and to internet
resource "aws_ec2_client_vpn_route" "internet" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.ep1.id
  destination_cidr_block = "0.0.0.0/0"
  target_vpc_subnet_id   = aws_subnet.tf-1a-private.id
}


resource "aws_ec2_client_vpn_route" "local" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.ep1.id
  destination_cidr_block = "10.6.0.0/16"
  target_vpc_subnet_id   = "local"
}

