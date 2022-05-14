resource "aws_cloudwatch_log_group" "vpn" {
  name = "vpn-endpoint1"
  tags = local.common_tags
}


resource "aws_cloudwatch_log_stream" "vpn" {
  name           = "streamvpn"
  log_group_name = aws_cloudwatch_log_group.vpn.name
}
