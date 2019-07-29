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
    "us-east-1"      = "ami-bffd3cc2"
    "us-east-2"      = "ami-9ef3c5fb"
    "us-west-1"      = "ami-854551e5"
    "us-west-2"      = "ami-9a29b8e2"
    "eu-west-1"      = "ami-1fb1ff66"
    "eu-west-2"      = "ami-c4688fa3"
    "ap-northeast-1" = "ami-75652e13"
    "ap-northeast-2" = "ami-a8bf13c6"
    "ap-southeast-1" = "ami-36bdec4a"
    "ap-southeast-2" = "ami-add013cf"
    "eu-central-1"   = "ami-1ebdd571"
    "sa-east-1"      = "ami-d80653b4"
    "ca-central-1"   = "ami-57048333"
    "ap-south-1"     = "ami-ee80d981"
  }
}

variable "kali" {
  type = "map"

  default = {
    "us-west-1"      = "ami-070b92a2ad613f657"
    "us-west-2"      = "ami-0f5eb23d395788b75"
    "us-east-1"      = "ami-076e36b130f0652ac"
    "us-east-2"      = "ami-0d535dd013b4e7e60"
    "ca-central-1"   = "ami-09ae60fb5234e5ed6"
    "eu-west-1"      = "ami-0cd4abf21ff96bfae"
    "eu-west-2"      = "ami-0629d16d9e818369f"
    "eu-central-1"   = "ami-046780598f58f083a"
    "ap-east-1"      = "ami-24d8a055"
    "ap-northeast-1" = "ami-043cc3771fa9d5104"
    "ap-southeast-1" = "ami-08187eda459bc178b"
    "ap-southeast-2" = "ami-08b35c633895f95e1"
    "ap-south-1"     = "ami-0665aee2a4f3a4baa"
    "sa-east-1"      = "ami-06043b07a9bd283b0"
  }
}

variable "UbuntuRegionMap" {
  type = "map"

  #Ubuntu Server 16.04 LTS (HVM)
  default = {
    "us-west-1"      = "ami-070b92a2ad613f657"
    "us-west-2"      = "ami-0f5eb23d395788b75"
    "us-east-1"      = "ami-076e36b130f0652ac"
    "us-east-2"      = "ami-0d535dd013b4e7e60"
    "ca-central-1"   = "ami-09ae60fb5234e5ed6"
    "eu-west-1"      = "ami-0cd4abf21ff96bfae"
    "eu-west-2"      = "ami-0629d16d9e818369f"
    "eu-central-1"   = "ami-046780598f58f083a"
    "ap-east-1"      = "ami-24d8a055"
    "ap-northeast-1" = "ami-043cc3771fa9d5104"
    "ap-southeast-1" = "ami-08187eda459bc178b"
    "ap-southeast-2" = "ami-08b35c633895f95e1"
    "ap-south-1"     = "ami-0665aee2a4f3a4baa"
    "sa-east-1"      = "ami-06043b07a9bd283b0"
  }
}
