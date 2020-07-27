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
    "ap-northeast-2"  = "ami-0644fb0e02257e3e0"
    "ap-south-1"      = "ami-0f03c2e41c35f4155"
    "ap-southeast-1"  = "ami-0c18d932bcd6eb39f"
    "ap-southeast-2"  = "ami-0b6f63cee6e82b6b1"
    "ca-central-1"    = "ami-09ccdba2948398b45"
    "eu-central-1"    = "ami-0cf748c2bf505e674"
    "eu-north-1"      = "ami-0b5ba14c2b9ccb9b6"
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
    "us-west-1"      = "ami-0a3a5bb61a81e3135"
    "us-west-2"      = "ami-000de76905d16b042"
    "us-east-1"      = "ami-021d9d94f93a07a43"
    "us-east-2"      = "ami-04239d579c52de263"
    "ca-central-1"   = "ami-00ecb370195d6a225"
    "eu-west-1"      = "ami-09e0dc5839aa7eca9"
    "eu-west-2"      = "ami-0629d16d9e818369f"
    "eu-central-1"   = "ami-0d30b058bf84b0a0c"
    "ap-east-1"      = "ami-72661d03"
    "ap-northeast-1" = "ami-0910fb379f9c0dda9"
    "ap-southeast-1" = "ami-0dff5e99784353c4a"
    "ap-southeast-2" = "ami-042ed6b729919aa24"
    "ap-south-1"     = "ami-0f382fa26248923ea"
    "sa-east-1"      = "ami-027c2142d479531cb"
  }
}

variable "ip_blacklist" {
  type = "list"
}
