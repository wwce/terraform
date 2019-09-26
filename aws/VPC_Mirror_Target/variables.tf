//This section should be verified and modified accordingly.

variable aws_region {
  description = "AWS Region for deployment"
  default     = "us-east-2"
}

variable aws_key {
  description = "aws_key"
  default     = "AWS-Ohio-Key"
}

//Do not create these.  The Terraform will do that.  Just need to make secure
//the s3 bucket names are unique.


variable bootstrap_s3bucket3 {
  description = "S3 Bucket Name used to Bootstrap the NGFWs"
  default     = "djs-tgw-bucket-blah-3"
}

variable bootstrap_s3bucket4 {
  description = "S3 Bucket Name used to Bootstrap the NGFWs"
  default     = "djs-tgw-bucket-blah-4"
}
//End of the section that MUST be modified to work
variable management_cidr {
  description = "CIDR Address for Management Access"
  default     = "0.0.0.0/0"
}

variable vpc_security_cidr {
  description = "CIDR Address for Security VPC"
  default     = "192.168.0.0/16"
}


#################
# Mirror Subnets
#################
variable vpc_mirror_pub_1 {
  description = "CIDR Address for Security VPC"
  default     = "192.168.51.0/24"
}

variable fw_ip_subnet_pub_1 {
  description = "CIDR Address for Security VPC"
  default     = "192.168.51.45"
}
variable fw_ip_subnet_mgmt_1 {
  description = "CIDR Address for Security VPC"
  default     = "192.168.51.44"
}

variable vpc_mirror_pub_2 {
  description = "CIDR Address for Security VPC"
  default     = "192.168.61.0/24"
}

variable fw_ip_subnet_mgmt_2 {
  description = "CIDR Address for Security VPC"
  default     = "192.168.61.44"
}
variable fw_ip_subnet_pub_2 {
  description = "CIDR Address for Security VPC"
  default     = "192.168.61.45"
}

#############



