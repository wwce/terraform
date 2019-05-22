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
    "us-east-1"      = "ami-076e36b130f0652ac"
    "us-east-2"      = "ami-0a444079f17309e2a"
    "us-west-1"      = "ami-03e0ff3de0548396b"
    "us-west-2"      = "ami-07c2e617785343806"
    "eu-west-1"      = "ami-04bbe683cac096622"
    "eu-west-2"      = "ami-05f478183aa65246f"
    "ap-northeast-1" = "ami-0093e807f67a5f1e7"
    "ap-northeast-2" = "ami-06ffd66e21c3ceb62"
    "ap-southeast-1" = "ami-0e22510ff08cbb147"
    "ap-southeast-2" = "ami-0d4437b6104e6b9bd"
    "eu-central-1"   = "ami-08b17dda213f62471"
    "sa-east-1"      = "ami-05cfb15d232b8be2a"
    "ca-central-1"   = "ami-0e4c58a6a5ae9e417"
    "ap-south-1"     = "ami-0b13a1e1e3db28939"
  }
}

variable "UbuntuRegionMap" {
  type = "map"

  #Ubuntu Server 16.04 LTS (HVM)
  default = {
    "us-east-1"      = "ami-092d0d014b7b31a08"
    "us-east-2"      = "ami-0a444079f17309e2a"
    "us-west-1"      = "ami-03e0ff3de0548396b"
    "us-west-2"      = "ami-07c2e617785343806"
    "eu-west-1"      = "ami-04bbe683cac096622"
    "eu-west-2"      = "ami-05f478183aa65246f"
    "ap-northeast-1" = "ami-0093e807f67a5f1e7"
    "ap-northeast-2" = "ami-06ffd66e21c3ceb62"
    "ap-southeast-1" = "ami-0e22510ff08cbb147"
    "ap-southeast-2" = "ami-0d4437b6104e6b9bd"
    "eu-central-1"   = "ami-08b17dda213f62471"
    "sa-east-1"      = "ami-05cfb15d232b8be2a"
    "ca-central-1"   = "ami-0e4c58a6a5ae9e417"
    "ap-south-1"     = "ami-0b13a1e1e3db28939"
  }
}
