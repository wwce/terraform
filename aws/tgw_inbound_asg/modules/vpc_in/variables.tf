variable tgw_id {}
variable tgw_rtb_id {}
variable region {}
variable cidr_vpc {}

variable azs {
  type = "list"
}

variable cidr_mgmt {
  type = "list"
}

variable cidr_untrust {
  type = "list"
}

variable cidr_trust {
  type = "list"
}

variable cidr_lambda {
  type = "list"
}

variable cidr_tgw {
  type = "list"
}

variable cidr_natgw {
  type = "list"
}

variable tag {
  default = "vmseries"
}
