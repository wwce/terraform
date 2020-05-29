provider "google" {
  credentials = "${var.main_project_authfile}"
  project     = "${var.main_project}"
  region      = "${var.region}"
  alias       = "ilbnh"
}
#************************************************************************************
# CREATE GCP BUCKET FOR VMSERIES BOOTSTRAP - ILBNH
#************************************************************************************
module "bootstrap_ilbnh" {
  source                = "./modules/create_bootstrap_bucket_ilbnh/"
  bucket_name           = "vmseries-ilbnh"
  randomize_bucket_name = true
  file_location         = "bootstrap_files_ilbnh/"
  enable_ilbnh          = "${var.enable_ilbnh}"
  config                = ["init-cfg.txt", "bootstrap.xml"]                                                                          // default []
  license               = ["authcodes"]                                                                                              // default []
 # content               = ["panupv2-all-contents-8133-5346", "panup-all-antivirus-2917-3427", "panupv2-all-wildfire-331212-333889"] // default []
 # software              = ["PanOS_vm-9.0.0"]                                                                                        // default []
}

#************************************************************************************
# CREATE 2xVMSERIES FIREWALL W/ 3 NICS (MGMT VPC, UNTRUST VPC, TRUST VPC) - ILBNH
#************************************************************************************
module "vm_fw_ilbnh" {
  source          = "./modules/create_vmseries_ilbnh/"
  fw_names        = ["vmseries03", "vmseries04"]
  fw_machine_type = "n1-standard-4"
  fw_zones        = ["${var.region}-a", "${var.region}-b"]
  fw_subnetworks  = ["${module.vpc_trust.subnetwork_self_link[0]}", "${module.vpc_mgmt.subnetwork_self_link[0]}", "${module.vpc_untrust.subnetwork_self_link[0]}"]
  enable_ilbnh    = "${var.enable_ilbnh}"
  fw_nic0_ip = ["192.168.2.4", "192.168.2.5"] // default [""] - enables dynamically assigned IP
  fw_nic1_ip = ["192.168.0.4", "192.168.0.5"]
  fw_nic2_ip = ["192.168.1.4", "192.168.1.5"]

  fw_bootstrap_bucket = "${module.bootstrap_ilbnh.bucket_name}"
  fw_ssh_key          = "admin:${var.vmseries_ssh_key}"
  fw_image            = "${var.vmseries_image}"

  create_instance_group = true
  instance_group_names  = ["vmseries03-ig", "vmseries04-ig"] // default "vmseries-instance-group"

  dependencies = [
    "${module.bootstrap_ilbnh.completion}",
  ]
}

#************************************************************************************
# CREATE VMSERIES INTERNAL LOAD BALANCER - ILBNH
#************************************************************************************
module "vmseries_internal_lb_ilbnh" {
  source                  = "./modules/create_ilbnh/"
  internal_lb_name_ilbnh  = "ilbnh"
  internal_lb_ports_ilbnh = "22"
  subnetworks             = ["${module.vpc_trust.subnetwork_self_link[0]}"]
  internal_lbnh_ip        = "192.168.2.6"
  enable_ilbnh            = "${var.enable_ilbnh}"
  backends  = [
    {
      group = "${module.vm_fw_ilbnh.instance_group[0]}"
    },
    {
      group = "${module.vm_fw_ilbnh.instance_group[1]}"
    },
  ]
}
