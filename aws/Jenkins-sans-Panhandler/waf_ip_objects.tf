resource "aws_wafv2_ip_set" "admin_remote_ipset" {
  name               = "admin_remote_ipset"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = "${var.admin_remote_ipset}"

  tags = {
    Name = "blue_team_admin_remote_ipset"
  }
}

resource "aws_wafv2_ip_set" "ip_blacklist" {
  name               = "ip_blacklist"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = "${var.ip_blacklist}"

  tags = {
    Name = "blue_team_ip_blcklist"
  }
}