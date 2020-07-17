data "aws_availability_zones" "available" {}
variable "aws_region" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "WebCIDR_TrustBlock1" {}
variable "WebCIDR_TrustBlock2" {}
variable "WebCIDR_UntrustBlock1" {}
variable "WebCIDR_UntrustBlock2" {}
variable "WebCIDR_MGMT1" {}
variable "WebCIDR_MGMT2" {}
variable "WebSRV1_AZ1_Trust" {}

variable "FW1_Untrust_IP" {}

variable "FW1_Trust_IP" {}
variable "FW1_mgmt_IP" {}
variable "VPCName" {}
variable "VPCCIDR" {}
variable "ServerKeyName" {}
variable "StackName" {}
variable "attackcidr1" {}
variable "KALICIDR" {}

variable "kali_AZ1_attack" {}

#VMSeries 8.1 Bundle 2 Paygo 
variable "PANFWRegionMap" {
  type = "map"

  default = {
    "us-east-1"      = "ami-0c21b9d4f6c321d91"
    "us-east-2"      = "ami-0b4118f66d7fd498a"
    "us-west-1"      = "ami-0ced18b853bbdb1af"
    "us-west-2"      = "ami-0ced18b853bbdb1af"
    "eu-west-1"      = "ami-0a87d6cfb1c824cf3"
    "eu-west-2"      = "ami-0af0ac47477365eb4"
    "ap-northeast-1" = "ami-0f6a57f775518a126"
    "ap-northeast-2" = "ami-00024db5e2d44505b"
    "ap-southeast-1" = "ami-073fb55a53ffd2349"
    "ap-southeast-2" = "ami-0dba20ade080c37a5"
    "eu-central-1"   = "ami-02412a8d1d7b17aca"
    "sa-east-1"      = "ami-0650b573565b1283d"
    "ca-central-1"   = "ami-0f3a34c56770ea7d5"
    "ap-south-1"     = "ami-06024425a7931a975"
  }
}

variable "kali" {
  type = "map"

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
