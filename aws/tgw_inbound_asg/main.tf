/*
                                              SUPPORT POLICY
The guide in this directory and accompanied files are released under an as-is, best effort, support policy. 
These scripts should be seen as community supported and Palo Alto Networks will contribute our expertise as 
and when possible. We do not provide technical support or help in using or troubleshooting the components of 
the project through our normal support options such as Palo Alto Networks support teams, or ASC (Authorized 
Support Centers) partners and backline support options. The underlying product used (the VM-Series firewall) 
by the scripts or templates are still supported, but the support is only for the product functionality and 
not for help in deploying or using the template or script itself. Unless explicitly tagged, all projects or 
work posted in our GitHub repository (at https://github.com/PaloAltoNetworks) or sites other than our official 
Downloads page on https://support.paloaltonetworks.com are provided under the best effort policy.
*/

#-----------------------------------------------------------------------------------------------------------------
# CREATE INBOUND SECURITY VPC
module "vpc_in" {
  source       = "./modules/vpc_in/"
  tag          = "${var.tag}"
  region       = "${var.region}"
  tgw_id       = "${var.tgw_id}"
  tgw_rtb_id   = "${var.tgw_rtb_id}"
  cidr_vpc     = "10.255.0.0/16"
  azs          = ["us-east-1a", "us-east-1b"]
  cidr_mgmt    = ["10.255.0.0/28", "10.255.0.16/28"]
  cidr_untrust = ["10.255.1.0/28", "10.255.1.16/28"]
  cidr_trust   = ["10.255.2.0/28", "10.255.2.16/28"]
  cidr_tgw     = ["10.255.3.0/28", "10.255.3.16/28"]
  cidr_natgw   = ["10.255.4.0/28", "10.255.4.16/28"]
  cidr_lambda  = ["10.255.5.0/28", "10.255.5.16/28"]
}

#-----------------------------------------------------------------------------------------------------------------
# CREATE S3 BUCKET FOR VM-SERIES BOOTSTRAP
module "s3_in" {
  source = "./modules/s3_bootstrap/"

  file_location      = "bootstrap_files/"
  bucket_name        = "fw-tgw-inbound-demo"
  bucket_name_random = true
  config             = ["bootstrap.xml", "init-cfg.txt"]
  license            = ["authcodes"]
  content            = []
  software           = []
  other              = ["panw-aws.zip", "pan_nlb_lambda.template", "nlb.zip"]
}

#-----------------------------------------------------------------------------------------------------------------
# DEPLOY VM-SERIES AUTOSCALE GROUP
module "fw_in" {
  source = "./modules/fw_in_asg/"

  tag              = "${var.tag}"
  region           = "${var.region}"
  vpc_id           = "${module.vpc_in.vpc_id}"
  vpc_sg_id        = "${module.vpc_in.default_security_group_id}"
  lambda_bucket    = "${module.s3_in.bucket_name}"
  lambda_subnet_id = "${module.vpc_in.lambda_id}"
  natgw_subnet_id  = "${module.vpc_in.natgw_id}"

  fw_key_name             = "${var.key_name}"
  fw_bucket               = "${module.s3_in.bucket_name}"
  fw_ami                  = "${var.fw_ami}"
  fw_vm_type              = "m4.xlarge"
  fw_sg_source            = "${var.fw_sg_source}"
  fw_subnet0_id           = "${module.vpc_in.mgmt_id}"
  fw_subnet1_id           = "${module.vpc_in.untrust_id}"
  fw_subnet2_id           = "${module.vpc_in.trust_id}"
  fw_min_instances        = "1"                           // FOR EACH AZ
  fw_max_instances        = "2"                           // FOR EACH AZ
  fw_scale_threshold_up   = "80"
  fw_scale_threshold_down = "20"
  fw_scale_parameter      = "DataPlaneCPUUtilizationPct"
  fw_scale_period         = "900"

  api_key_firewall  = "LUFRPT1Zd2pYUGpkMUNrVEZlb3hROEQyUm95dXNGRkU9N0d4RGpTN2VZaVZYMVVoS253U0p6dlk3MkM0SDFySEh2UUR4Y3hzK2g3ST0="
  api_key_panorama  = ""
  api_key_delicense = ""

  enable_debug = "No"

  dependencies = [
    "${module.s3_in.completion}",
  ]
}

#-----------------------------------------------------------------------------------------------------------------

