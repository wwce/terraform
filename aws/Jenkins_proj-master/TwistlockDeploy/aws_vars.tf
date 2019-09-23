data "aws_availability_zones" "available" {}
variable "aws_region" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}
//variable "ConsoleCIDR_UntrustBlock1" {}
//variable "ConsoleCIDR_UntrustBlock2" {}
variable "AZ1_console_ip" {}



variable "VPCName" {}
variable "CONSOLECIDR" {}
variable "ServerKeyName" {}
variable "StackName" {}

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
