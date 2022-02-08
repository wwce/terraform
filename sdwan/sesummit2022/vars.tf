data "aws_availability_zones" "available" {}

## These variables MUST be updated for your deployment

variable "AWS_SHARED_CREDS" {
    default = "~/.aws/credentials"
    description = "AWS credentials file (from aws-cli). Expects profile below to be defined (aws configure --profile xyz)"
}

variable "AWS_SHARED_CREDS_PROFILE" {
    default = "default"
    description = "AWS Credentials profile name"
}

variable "PUBLIC_KEY_PATH" {
  default = "~/.ssh/id_rsa.pub"
  description = "Public Key - will be used to create SSH creds in AWS for SSH to ION and TGEN systems."
}

variable "USERDATA_KEY" {
  default = "<insert key here>"
}

variable "USERDATA_SECRET" {
  default = "<insert secret key here>"
}

## These variables MAY be updated if desired or necessary

variable "AWS_REGION" {
    default = "us-east-2"
    description = "Region you want to deploy the AWS-SCALE env to"
}

variable "CUSTOMER_IDENTIFIER" {
  default = "sesummit"
  description = "SP name"
}

variable "ION_MODEL_MAP" {
    type = map(string)
    default = {
        "ion 3102v" = "m4.xlarge"
        "ion 3104v" = "m4.xlarge"
        "ion 3108v" = "m4.2xlarge"
        "ion 7108v" = "m4.2xlarge"
    }
    description = "MAP of ION MODEL to AWS instance required for that model"
}

## You probably should not muck with these unless you know what you are doing

variable "ION_AMI_MAP" {
    type = map(string)
    default = {
        ap-northeast-1 = "ami-09058909650306733"
        ap-northeast-2 = "ami-057856c9ac075a7e3"
        ap-northeast-3 = "ami-0f208fa012eb1474f"
        ap-south-1 = "ami-0055a9c276376cbbe"
        ap-southeast-1 = "ami-059f9e8f1b9f15b5d"
        ap-southeast-2 = "ami-0787dd0150f2b2cf0"
        ca-central-1 = "ami-01714bfbf3a34dd4e"
        eu-central-1 = "ami-0103b41d121c67cf0"
        eu-north-1 = "ami-0bb842cea9b4f37ab"
        eu-west-1 = "ami-0385b4d86b6d5f433"
        eu-west-2 = "ami-07e4b1e7864fb93ed"
        eu-west-3 = "ami-0c0c56352d676b74e"
        sa-east-1 = "ami-0a4e7b4b2d1833d6c"
        us-east-1 = "ami-0f682614de21cfcbb"
        us-east-2 = "ami-01cd5548ac11133a4"
        us-west-1 = "ami-0615356c6c271d772"
        us-west-2 = "ami-0dcb34b3683ac5366"
    }
    description = "MAP of REGION to AMI for ION image. Default is public marketplace IONs"
}

variable "TGEN_AMI_MAP" {
    type = map(string)
    default = {
        eu-north-1 = "ami-0da97cd644c463fcf"
        ap-south-1 = "ami-068a0d5a28e58a9f5"
        eu-west-3 = "ami-02e82d09e659611fd"
        eu-west-2 = "ami-028a88a4f56bf7320"
        eu-west-1 = "ami-02c3a036cb7aecf91"
        ap-northeast-2 = "ami-06385a1b564839222"
        ap-northeast-1 = "ami-038bfbec4828c3a2a"
        sa-east-1 = "ami-0e933b918ab30c67a"
        ca-central-1 = "ami-099e0993ed01901e4"
        ap-southeast-1 = "ami-045322e3c702e1cf6"
        ap-southeast-2 = "ami-0bb6f6fd425a05c82"
        eu-central-1 = "ami-0c89b41f7951dbcf5"
        us-east-1 = "ami-09cf448893f0c4073"
        us-east-2 = "ami-054e595f3e14074c3"
        us-west-1 = "ami-0250d76a446b0e6ca"
        us-west-2 = "ami-0b57c0d6b4786e363"
    }
    description = "MAP of REGION to AMI for Traffic Generator."
}

data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

variable "EC2_USER" {
  default = "vffsetup"
  description = "User used to ssh to system (unused in template currently.)"
}

variable "VPC_CIDR" {
  default = "10.240.0.0/16"
  description = "CIDR block for systems. Will be split into 2 /20s for public 1 & 2, then /28s for rest."
  // In theroy, we can do ~3584 branches per AZ with this split.
  // Public1 = 4096 addresses, /20 subnet #0 of this CIDR
  // per-branch private subnets, each /28 (16 ip), starting at #514
  //   there are ~3582 /28s remaining in /16 after taking out 2x /20s + 2x /28s
}

variable "DC_VPC_CIDR" {
  default = "10.250.0.0/16"
  description = "CIDR block for DC systems. Will be split into 1 /20s for public 1, then /28s for rest."
}

variable "ENV_COUNT" {
  default = 1
  description = "Number of Environments (Branches) to create."
}

variable "DC_ENV_COUNT" {
  default = 1
  description = "If using same CIDR as other branches, where to start the /28 block (and item naming)"
}

variable "ENV_START" {
  default = 0
  description = "If using same CIDR as other branches, where to start the /28 block (and item naming)"
  // by default, tag names are ENV_START + ENV_COUNT.
  // also, /28 selected uses ENV_START + ENV_COUNT.
}

variable "DC_ENV_START" {
  default = 0
  description = "If using same CIDR as other branches, where to start the /28 block (and item naming)"
  // by default, tag names are DC_ENV_START + ENV_COUNT.
  // also, /28 selected uses DC_ENV_START + ENV_COUNT.
}

variable "ION_MODEL" {
  default = "ion 3104v"
  description = "ION model to use, also determines AWS instance via MAP above."
}

variable "TGEN_INSTANCE_TYPE" {
  default = "t2.medium"
  description = "Instance to use for Traffic Generator"
}

variable "TGEN_INSTANCE_ADDITIONAL_IPS" {
  default = 5
  description = "Number of additional IPs (clients) to use per traffic generator instance. t2.medium supports 5."
}

variable "TGEN_DC_INSTANCE_TYPE" {
  default = "t2.medium"
  description = "Instance to use for Traffic Generator in DC"
}

variable "USERDATA_HOST1_NAME" {
  default = ""
}


variable "USERDATA_HOST1_IP" {
  default = ""
}


variable "USERDATA_HOST2_NAME" {
  default = ""
}


variable "USERDATA_HOST2_IP" {
  default = ""
}

variable "USERDATA_HOST3_NAME" {
  default = ""
}

variable "USERDATA_HOST3_IP" {
  default = ""
}

