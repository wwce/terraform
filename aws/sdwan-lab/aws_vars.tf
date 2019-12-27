variable "aws_region" {}
#variable "aws_access_key" {}
#variable "aws_secret_key" {}
variable "VPCCIDR" {}
variable "SD-WAN-MGT" {}
variable "SD-WAN-WAN1" {}
variable "SD-WAN-WAN2" {}
variable "SD-WAN-WAN3" {}
variable "SD-WAN-WAN4" {}
variable "SD-WAN-MPLS" {}
variable "SD-WAN-Branch25" {}
variable "SD-WAN-Branch50" {}
variable "SD-WAN-Hub" {}
variable "ServerKeyName" {}

#VMSeries 9.0.3-xfr BYOL 
variable "PANFWRegionMap" {
  type = "map"

  default = {
    "ap-northeast-1" = "ami-04bd06018d53fd939"

    "ap-northeast-2" = "ami-0566141c898e243fc"

    "ap-south-1" = "ami-0ef9ba2fb8c8b2f23"

    "ap-southeast-1" = "ami-023496caf9aedcbb5"

    "ap-southeast-2" = "ami-08399a38c19098edb"

    "ca-central-1" = "ami-0f4812911392bee42"

    "eu-central-1" = "ami-04102d137edd8a952"

    "eu-north-1" = "ami-d59d17ab"

    "eu-west-1" = "ami-09312982f28611e13"

    "eu-west-2" = "ami-0063940db47af7581"

    "eu-west-3" = "ami-07a4c669069e02995"

    "sa-east-1" = "ami-077e676dce3d06231"

    "us-east-1" = "ami-0ec2529b60a7fff22"

    "us-east-2" = "ami-06efcb94b48d8263c"

    "us-west-1" = "ami-03801628148e17514"

    "us-west-2" = "ami-05a457c9f5f6a45e0"
  }
}
variable "PanoramaRegionMap" {
  type = "map"
  #Panorama 9.0.5
  default = {
    "ap-northeast-1" = "ami-08e8bded936bbd795"

    "ap-northeast-2" = "ami-0569a43a1ab4864e0"

    "ap-south-1" = "ami-01e194040c88ec7f7"

    "ap-southeast-1" = "ami-05946a342e4f38c79"

    "ap-southeast-2" = "ami-060009b850df3908c"

    "ca-central-1" = "ami-042b6efd5f827ea88"

    "eu-central-1" = "ami-0d4a11e11365c9bae"

    "eu-north-1" = "ami-0d274936829f13359"

    "eu-west-1" = "ami-06a1715befd746fe4"

    "eu-west-2" = "ami-03a4a370ee5442bac"

    "eu-west-3" = "ami-0637f615e0f748d62"

    "sa-east-1" = "ami-091669d04559b7056"

    "us-east-1" = "ami-0fd6fc67d9f2e7750"

    "us-east-2" = "ami-013c503f1741aa646"

    "us-west-1" = "ami-02e821dd4b602e9ec"

    "us-west-2" = "ami-0403335c2e31d2a81"
  }
}
variable "UbuntuRegionMap" {
  type = "map"

  #Ubuntu Server 18.04 LTS (HVM)
  default = {
    "ap-northeast-1" = "ami-014cc8d7cb6d26dc8"
    "ap-northeast-2" = "ami-004b3430b806f3b1a"
    "ap-south-1" = "ami-0f59afa4a22fad2f0"
    "ap-southeast-1" = "ami-08b3278ea6e379084"
    "ap-southeast-2" = "ami-00d7116c396e73b04"
    "ca-central-1" = "ami-0086bcfbab4b22f60"
    "eu-central-1" = "ami-0062c497b55437b01"
    "eu-north-1" = "ami-0ca3b50bc99a41773"
    "eu-west-1" = "ami-0987ee37af7792903"
    "eu-west-2" = "ami-05945867d79b7d926"
    "eu-west-3" = "ami-00c60f4df93ff408e"
    "sa-east-1" = "ami-0fb487b6f6ab53ff"
    "us-east-1" = "ami-09f9d773751b9d606"
    "us-east-2" = "ami-0891395d749676c2e"
    "us-west-1" = "ami-0c0e5a396959508b0"
    "us-west-2" = "ami-0bbe9b07c5fe8e86e"
  }
}
