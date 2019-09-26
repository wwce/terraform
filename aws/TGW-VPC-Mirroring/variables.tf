//This section should be verified and modified accordingly.

variable aws_region {
  description = "AWS Region for deployment"
  default     = "us-east-2"
}

variable aws_key {
  description = "aws_key"
  default     = "AWS--Key"
}

//Do not create these.  The Terraform will do that.  Just need to make secure
//the s3 bucket names are unique.

variable bootstrap_s3bucket {
  description = "S3 Bucket Name used to Bootstrap the NGFWs"
  default     = "tgw-bucket-1"
}

variable bootstrap_s3bucket2 {
  description = "S3 Bucket Name used to Bootstrap the NGFWs"
  default     = "tgw-bucket-2"
}
variable bootstrap_s3bucket3 {
  description = "S3 Bucket Name used to Bootstrap the NGFWs"
  default     = "tgw-bucket-3"
}

variable bootstrap_s3bucket4 {
  description = "S3 Bucket Name used to Bootstrap the NGFWs"
  default     = "tgw-bucket-4"
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

variable vpc_security_subnet_public_1 {
  description = "CIDR Address for Security VPC"
  default     = "192.168.1.0/24"
}

variable vpc_security_subnet_private_1 {
  description = "CIDR Address for Security VPC"
  default     = "192.168.101.0/24"
}

variable fw_ip_subnet_private_1 {
  description = "CIDR Address for Security VPC"
  default     = "192.168.101.45"
}

variable fw_ip_subnet_public_1 {
  description = "CIDR Address for Security VPC"
  default     = "192.168.1.45"
}

variable vpc_security_subnet_tgw_1 {
  description = "CIDR Address for TGW Security VPC"
  default     = "192.168.11.0/24"
}
#################
# Mirror Subnets
#################
variable vpc_mirror_pub_1 {
  description = "CIDR Address for Security VPC"
  default     = "192.168.51.0/24"
}
variable vpc_mirror_priv_1 {
  description = "CIDR Address for Security VPC"
  default     = "192.168.52.0/24"
}
variable fw_ip_subnet_pub_1 {
  description = "CIDR Address for Security VPC"
  default     = "192.168.51.45"
}
variable fw_ip_subnet_priv_1 {
  description = "CIDR Address for Security VPC"
  default     = "192.168.52.45"
}
variable vpc_mirror_pub_2 {
  description = "CIDR Address for Security VPC"
  default     = "192.168.61.0/24"
}
variable vpc_mirror_priv_2 {
  description = "CIDR Address for Security VPC"
  default     = "192.168.62.0/24"
}
variable fw_ip_subnet_pub_2 {
  description = "CIDR Address for Security VPC"
  default     = "192.168.61.45"
}
variable fw_ip_subnet_priv_2 {
  description = "CIDR Address for Security VPC"
  default     = "192.168.62.45"
}
#############



variable vpc_security_subnet_public_2 {
  description = "CIDR Address for Security VPC"
  default     = "192.168.2.0/24"
}

variable vpc_security_subnet_private_2 {
  description = "CIDR Address for Security VPC"
  default     = "192.168.102.0/24"
}

variable vpc_security_subnet_tgw_2 {
  description = "CIDR Address for TGW Security VPC"
  default     = "192.168.21.0/24"
}

variable fw_ip_subnet_private_2 {
  description = "CIDR Address for Security VPC"
  default     = "192.168.102.45"
}

variable fw_ip_subnet_public_2 {
  description = "CIDR Address for Security VPC"
  default     = "192.168.2.45"
}

variable spoke1_cidr {
  description = "CIDR Address for Spoke1 VPC"
  default     = "10.1.0.0/16"
}

variable spoke1_subnet {
  description = "CIDR Address for Spoke1 Subnet"
  default     = "10.1.1.0/24"
}

variable spoke1_subnet2 {
  description = "CIDR Address for Spoke1 Subnet"
  default     = "10.1.2.0/24"
}

variable spoke1_server {
  description = "Server Address for Spoke1 Server"
  default     = "10.1.1.45"
}

variable spoke1_server2 {
  description = "Server Address for Spoke1 Server2"
  default     = "10.1.2.45"
}

variable spoke2_cidr {
  description = "CIDR Address for Spoke2 VPC"
  default     = "10.2.0.0/16"
}

variable spoke2_subnet {
  description = "CIDR Address for Spoke2 Subnet"
  default     = "10.2.1.0/24"
}

variable spoke2_subnet2 {
  description = "CIDR Address for Spoke2 Subnet"
  default     = "10.2.2.0/24"
}

variable spoke2_server {
  description = "Server Address for Spoke2 Server"
  default     = "10.2.1.45"
}

variable spoke2_server2 {
  description = "Server Address for Spoke2 Server2"
  default     = "10.2.2.45"
}
