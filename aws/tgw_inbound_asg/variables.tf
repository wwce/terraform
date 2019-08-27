provider "aws" {
  version = ">= 1.0.0"
  region  = "${var.region}"
}

variable tag {
  default = "fw-in"
}

variable region {
  default = "us-east-1"
}

variable key_name {
  description = "Enter name of an existing EC2 key pair"
 // default     = "my-key-pair"
}

variable fw_ami {
  description = "FW AMI - https://docs.paloaltonetworks.com/compatibility-matrix/vm-series-firewalls/aws-cft-amazon-machine-images-ami-list/images-for-pan-os-8-1.html"
  // default     = "ami-a2fa3bdf"
}

variable fw_sg_source {
  description = "Source prefix to apply to mgmt ENI"
 // default     = "0.0.0.0/0"
}

variable tgw_id {
  description = "Enter the ID of an existing TGW"
 // default     = "tgw-0123456789"
}

variable tgw_rtb_id {
  description = "Enter the ID of an existing TGW route table to associate with VPC attachment"
 // default     = "tgw-rtb-0123456789"
}