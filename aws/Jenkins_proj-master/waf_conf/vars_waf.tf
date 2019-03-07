variable "aws_region" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "waf_prefix" {}

variable "blacklisted_ips" {
  type = "list"
}

variable "admin_remote_ipset" {
  type = "list"
}

variable depends_on {
  default = []

  type = "list"
}

variable "alb_arn" {}
