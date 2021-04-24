data "aws_availability_zones" "available" {
}

variable "aws_region" {
}

variable "aws_access_key" {
}

variable "aws_secret_key" {
}

variable "aws_key_pair" {
}

variable "blue_team_cidr" {
}

variable "blue_team_mgmt" {
}

variable "blue_team_untrust" {
}

variable "blue_team_trust" {
}

variable "blue_team_server1_ip" {
}

variable "blue_team_server2_ip" {
}

variable "blue_team_server3_ip" {
}

variable "server1_initscript_path" {
}

variable "server2_initscript_path" {
}

variable "server3_initscript_path" {
}

variable "fw_mgmt_ip" {
}

variable "fw_untrust_ip0" {
}

variable "fw_untrust_ip1" {
}

variable "fw_untrust_ip2" {
}

variable "fw_untrust_ip3" {
}

variable "fw_trust_ip" {
}

variable "content_bucket" {
}

#VMSeries Bundle 2 Paygo 
variable "PANFWRegionMap" {
  type = map(string)

  default = {
    "ap-northeast-1" = "ami-0ea2697ddc3fc9ef7"
    "ap-south-1" = "ami-08eab3fc528145c6d"
    "ap-southeast-1" = "ami-0cdd1c147cc17200b"
    "ap-southeast-2" = "ami-0838b250a810e4bc9"
    "ca-central-1" = "ami-09022c77705f3ebe9"
    "eu-central-1" = "ami-07a60c313ec7720ea"
    "eu-west-1" = "ami-0324f7b84cd6edd2f"
    "eu-west-2" = "ami-053e9b1bd196fd894"
    "sa-east-1" = "ami-0f145d074951e4acb"
    "us-east-1" = "ami-0de80c6f86a5bda74"
    "us-east-2" = "ami-045dd9c9673e2ad76"
    "us-west-1" = "ami-061672315554a20e0"
    "us-west-2" = "ami-0073e5cfb0d4d3b28"
  }
}

variable "UbuntuRegionMap" {
  type = map(string)

  #Ubuntu Server 16.04 LTS (HVM)
  default = {
    "ap-northeast-1" = "ami-0ad8925cfae263816"
    "ap-south-1"     = "ami-033405fef856aa050"
    "ap-southeast-1" = "ami-090c5f444ba17b5e6"
    "ap-southeast-2" = "ami-009dabce373407f47"
    "ca-central-1"   = "ami-0dba2e6f05a90be45"
    "eu-central-1"   = "ami-057320c356ed8a39a"
    "eu-west-1"      = "ami-00126411777531ca6"
    "eu-west-2"      = "ami-0d013c5896434b38a"
    "sa-east-1"      = "ami-0786f8c2dfa7e3230"
    "us-east-1"      = "ami-0857b0ef93a75300f"
    "us-east-2"      = "ami-0b6b93913be33d8f6"
    "us-west-1"      = "ami-0a1a02c21dbaf286d"
    "us-west-2"      = "ami-0db01fabda16f6445"
  }
}

