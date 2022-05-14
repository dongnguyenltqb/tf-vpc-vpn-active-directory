resource "aws_acm_certificate" "cert" {
  domain_name       = "vpn.kitchko.com"
  validation_method = "DNS"
}
