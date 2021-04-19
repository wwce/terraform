data "aws_availability_zones" "available" {}
variable "aws_region" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_key_pair" {}

variable "blue_team_cidr" {}
variable "blue_team_az1_mgmt" {}
variable "blue_team_az2_mgmt" {}
variable "blue_team_az1_untrust" {}
variable "blue_team_az2_untrust" {}
variable "blue_team_az1_trust" {}
variable "blue_team_az2_trust" {}

variable "blue_team_server_ip" {}
variable "server_initscript_path" {}
variable "fw1_mgmt_ip" {}
variable "fw1_untrust_ip" {}
variable "fw1_trust_ip" {}
variable "content_bucket" {}

variable "red_team_cidr" {}
variable "red_team_ip" {}
variable "attacker_initscript_path" {}

#VMSeries 8.1 Bundle 2 Paygo 
variable "PANFWRegionMap" {
  type = "map"

  default = {
    "ap-northeast-1"  = "ami-0c2df2ad98fa740f2"
    "ap-south-1"      = "ami-0f03c2e41c35f4155"
    "ap-southeast-1"  = "ami-0c18d932bcd6eb39f"
    "ap-southeast-2"  = "ami-0b6f63cee6e82b6b1"
    "ca-central-1"    = "ami-09ccdba2948398b45"
    "eu-central-1"    = "ami-0cf748c2bf505e674"
    "eu-west-1"       = "ami-02eec133b97eaa1e1"
    "eu-west-2"       = "ami-0c06868bcef1d35ba"
    "sa-east-1"       = "ami-08a812daea4ede4a2"
    "us-east-1"       = "ami-07c7f3e5ce94b86cd"
    "us-east-2"       = "ami-05025aa19e768421d"
    "us-west-1"       = "ami-0ba71b23bb2d76fa1"
    "us-west-2"       = "ami-074c89c1e945ede8a"
  }
}

variable "UbuntuRegionMap" {
  type = "map"

  #Ubuntu Server 16.04 LTS (HVM)
  default = {
    "ap-northeast-1" = "ami-0ad8925cfae263816"
    "ap-south-1" = "ami-033405fef856aa050"
    "ap-southeast-1" = "ami-090c5f444ba17b5e6"
    "ap-southeast-2" = "ami-009dabce373407f47"
    "ca-central-1" = "ami-0dba2e6f05a90be45"
    "eu-central-1" = "ami-057320c356ed8a39a"
    "eu-west-1" = "ami-00126411777531ca6"
    "eu-west-2" = "ami-0d013c5896434b38a"
    "sa-east-1" = "ami-0786f8c2dfa7e3230"
    "us-east-1" = "ami-0857b0ef93a75300f"
    "us-east-2" = "ami-0b6b93913be33d8f6"
    "us-west-1" = "ami-0a1a02c21dbaf286d"
    "us-west-2" = "ami-0db01fabda16f6445"
  }
}

variable "ip_blacklist" {
  type = "list"
}
