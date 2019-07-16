#************************************************************************************
# HA script parameters
#************************************************************************************
variable apikey {
  description = "Firewall API Key"
  default     = "LUFRPT13YW8wYVhzQXNhMnFIM1J4cWNYMWROOVBMUGc9Y21mS2JKSlVVdC84ZVpJdE50V000VTgra2xURmxhNFRXNkJud0h3Nko4RT0="
}
variable preempt {
  description = "Firewall API Key"
  default     = "yes"
}
variable split_routes {
  description = "Solit routing across both firewalls"
  default     = "yes"
}
variable vpc_summary_route {
  description = "VPC summary route"
  default     = "10.0.0.0/8"
}

#************************************************************************************
# SET REGION AND SSH KEY FOR EC2 INSTANCES
#************************************************************************************
variable aws_region {
  description = "AWS Region for deployment"
  default     = "eu-west-1"
}
variable aws_key {
  description = "Enter your AWS EC2 key pair"
  # default     = "my_aws_ec2_key_pair"
}
variable management_cidr {
  description = "Source IP applied to management NSG"
  # default     = "0.0.0.0/0"
}

variable ngfw_license_type {
  description = "Select VM-Series license type (byol, payg1, payg2)"
  # default = "byol"
  # default = "payg1"
  # default = "payg2"
}

variable instance_type {
  description = "Select VM-Series Size"
  default = "m4.2xlarge"
}

#************************************************************************************
# S3 STORAGE BUCKETS FOR FW BOOTSTRAPPING (DO NOT CREATE BEFORE DEPLOYMENT)
#************************************************************************************
variable bootstrap_s3bucket1_create {
  description = "S3 Bucket Name used to Bootstrap the NGFWs"
  default     = "tgw-fw1-bootstrap" // 30-CHARATER RANDOM STRING IS ADDED TO THIS BUCKET NAME
}

variable bootstrap_s3bucket2_create {
  description = "S3 Bucket Name used to Bootstrap the NGFWs"
  default     = "tgw-fw2-bootstrap" // 30-CHARACTER RANDOM STRING IS ADDED TO THIS BUCKET NAME
}

#************************************************************************************
# SECURITY VPC CIDRS
#************************************************************************************
variable vpc_security_cidr {
  description = "Security VPC CIDR"
  default     = "192.168.0.0/16"
}

variable vpc_security_subnet_mgmt_1 {
  description = "Mgmt Subnet CIDR-AZ1"
  default     = "192.168.100.0/24"
}
variable vpc_security_subnet_mgmt_2 {
  description = "Mgmt Subnet CIDR-AZ2"
  default     = "192.168.101.0/24"
}
variable vpc_security_subnet_public_1 {
  description = "Public Subnet CIDR-AZ1"
  default     = "192.168.10.0/24"
}
variable vpc_security_subnet_public_2 {
  description = "Public Subnet CIDR-AZ2"
  default     = "192.168.11.0/24"
}
variable vpc_security_subnet_private_1 {
  description = "Trust Subnet CIDR-AZ1"
  default     = "192.168.20.0/24"
}
variable vpc_security_subnet_private_2 {
  description = "Trust Subnet CIDR-AZ2"
  default     = "192.168.21.0/24"
}
variable vpc_security_subnet_tgw_1 {
  description = "TGW Subnet CIDR-AZ1"
  default     = "192.168.30.0/24"
}
variable vpc_security_subnet_tgw_2 {
  description = "TGW Subnet CIDR-AZ2"
  default     = "192.168.31.0/24"
}
variable vpc_security_subnet_lambda_1 {
  description = "Lambda Subnet AZ1"
  default     = "192.168.110.0/24"
}
variable vpc_security_subnet_lambda_2 {
  description = "Lambda Subnet AZ2"
  default     = "192.168.112.0/24"
}

#************************************************************************************
# FW ENI IP ADDRESSES
#************************************************************************************
variable fw_ip_subnet_public_1 {
  description = "FW1 Public Subnet IP Address-AZ1"
  default     = "192.168.10.4"
}
variable fw_ip_subnet_public_2 {
  description = "FW2 Public Subnet IP Address-AZ2"
  default     = "192.168.11.4"
}
variable fw_ip_subnet_private_1 {
  description = "FW1 Private Subnet IP Address-AZ1"
  default     = "192.168.20.4"
}
variable fw_ip_subnet_private_2 {
  description = "FW2 Private Subnet IP Address-AZ2"
  default     = "192.168.21.4"
}


#************************************************************************************
# SPOKE-1 VPC CIDRS
#************************************************************************************
variable spoke1_cidr {
  description = "CIDR Address for Spoke1 VPC"
  default     = "10.1.0.0/16"
}

variable spoke1_subnet {
  description = "CIDR Address for Spoke1 Subnet"
  default     = "10.1.0.0/24"
}

variable spoke1_subnet2 {
  description = "CIDR Address for Spoke1 Subnet"
  default     = "10.1.1.0/24"
}


#************************************************************************************
# SPOKE-2 VPC CIDRS
#************************************************************************************
variable spoke2_cidr {
  description = "CIDR Address for Spoke2 VPC"
  default     = "10.2.0.0/16"
}

variable spoke2_subnet {
  description = "CIDR Address for Spoke2 Subnet"
  default     = "10.2.0.0/24"
}

variable spoke2_subnet2 {
  description = "CIDR Address for Spoke2 Subnet"
  default     = "10.2.1.0/24"
}


#************************************************************************************
# SPOKE-1 VM IP ADDRESSES
#************************************************************************************
variable spoke1_server {
  description = "Server Address for Spoke1 Server"
  default     = "10.1.0.4"
}
variable spoke1_server2 {
  description = "Server Address for Spoke1 Server2"
  default     = "10.1.1.4"
}

#************************************************************************************
# SPOKE-2 VM IP ADDRESSES
#************************************************************************************
variable spoke2_server {
  description = "Server Address for Spoke2 Server"
  default     = "10.2.0.4"
}
variable spoke2_server2 {
  description = "Server Address for Spoke2 Server2"
  default     = "10.2.1.4"
}
variable all_spoke_cidr {
  description = "CIDR to cover Spoke1 and Spoke2-Used in FROM-TGW AWS Route Table"
  default     = "10.0.0.0/8"
}

