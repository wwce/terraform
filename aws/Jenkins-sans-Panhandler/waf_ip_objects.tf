resource "aws_wafv2_ip_set" "ip_blacklist" {
  name               = "ip_blacklist"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = "${var.ip_blacklist}"

  tags = {
    Name = "blue_team_ip_blcklist"
  }
}