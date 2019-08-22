provider "google" {
  credentials = "${var.main_project_authfile}"
  project     = "${var.main_project}"
  region      = "${var.region}"
}

#************************************************************************************
# CREATE VPCS - MGMT, UNTRUST, TRUST
#************************************************************************************
module "vpc_mgmt" {
  source            = "./modules/create_vpc/"
  vpc_name          = "mgmt-vpc"
  subnetworks       = ["mgmt-subnet"]
  ip_cidrs          = ["192.168.0.0/24"]
  regions           = ["${var.region}"]
  ingress_allow_all = true
  ingress_sources   = ["0.0.0.0/0"]
}

module "vpc_untrust" {
  source            = "./modules/create_vpc/"
  vpc_name          = "untrust-vpc"
  subnetworks       = ["untrust-subnet"]
  ip_cidrs          = ["192.168.1.0/24"]
  regions           = ["${var.region}"]
  ingress_allow_all = true
  ingress_sources   = ["0.0.0.0/0"]
}

module "vpc_trust" {
  source            = "./modules/create_vpc/"
  vpc_name          = "trust-vpc"
  subnetworks       = ["trust-subnet"]
  ip_cidrs          = ["192.168.2.0/24"]
  regions           = ["${var.region}"]
  ingress_allow_all = true
  ingress_sources   = ["0.0.0.0/0"]
}

#************************************************************************************
# CREATE GCP BUCKET FOR VMSERIES BOOTSTRAP
#************************************************************************************
module "bootstrap" {
  source                = "./modules/create_bootstrap_bucket/"
  bucket_name           = "vmseries-adv-peering"
  randomize_bucket_name = true
  file_location         = "bootstrap_files/"
  
  config                = ["init-cfg.txt", "bootstrap.xml"]                                                                          // default []
  license               = ["authcodes"]                                                                                              // default []
 # content               = ["panupv2-all-contents-8133-5346", "panup-all-antivirus-2917-3427", "panupv2-all-wildfire-331212-333889"] // default []
 # software              = ["PanOS_vm-9.0.0"]                                                                                        // default []
}
#************************************************************************************
# CREATE 2xVMSERIES FIREWALL W/ 3 NICS (MGMT VPC, UNTRUST VPC, TRUST VPC)
#************************************************************************************
module "vm_fw" {
  source          = "./modules/create_vmseries/"
  fw_names        = ["vmseries01", "vmseries02"]
  fw_machine_type = "n1-standard-4"
  fw_zones        = ["${var.region}-a", "${var.region}-b"]
  fw_subnetworks  = ["${module.vpc_untrust.subnetwork_self_link[0]}", "${module.vpc_mgmt.subnetwork_self_link[0]}", "${module.vpc_trust.subnetwork_self_link[0]}"]

  fw_nic0_ip = ["192.168.1.2", "192.168.1.3"] // default [""] - enables dynamically assigned IP
  fw_nic1_ip = ["192.168.0.2", "192.168.0.3"]
  fw_nic2_ip = ["192.168.2.2", "192.168.2.3"]

  fw_bootstrap_bucket = "${module.bootstrap.bucket_name}"
  fw_ssh_key          = "admin:${var.vmseries_ssh_key}"
  fw_image            = "${var.vmseries_image}"

  create_instance_group = true
  instance_group_names  = ["vmseries01-ig", "vmseries02-ig"] // default "vmseries-instance-group"

  dependencies = [
    "${module.bootstrap.completion}",
  ]
}

#************************************************************************************
# CREATE VMSERIES PUBLIC HTTP LOAD BALANCER
#************************************************************************************
module "vmseries_public_lb" {
  source = "./modules/create_public_lb/"
  name   = "vmseries-lb"

  backends = {
    "0" = [
      {
        group = "${module.vm_fw.instance_group[0]}"
      },
      {
        group = "${module.vm_fw.instance_group[1]}"
      },
    ]
  }

  backend_params = [
    "/,http,80,10", // health check path, port name, port number, timeout seconds.
  ]
}

#************************************************************************************
# CREATE DEFAULT ROUTE TO WITHIN TRUST VPC TO FW1 & FW2
#************************************************************************************
resource "google_compute_route" "default" {
  count             = "${length(module.vm_fw.fw_names)}"
  name              = "default-to-${module.vm_fw.fw_names[count.index]}"
  dest_range        = "0.0.0.0/0"
  network           = "${module.vpc_trust.vpc_self_link}"
  next_hop_instance = "${module.vm_fw.fw_self_link[count.index]}"
  priority          = 100
}

#************************************************************************************
# CREATE PEERING LINKS TRUST-to-SPOKE1 / TRUST-to-SPOKE2
#************************************************************************************
resource "google_compute_network_peering" "trust_to_spoke1" {
  name         = "trust-to-spoke1"
  network      = "${module.vpc_trust.vpc_self_link}"
  peer_network = "${module.vpc_spoke1.vpc_self_link}"
}

resource "google_compute_network_peering" "trust_to_spoke2" {
  name         = "trust-to-spoke2"
  network      = "${module.vpc_trust.vpc_self_link}"
  peer_network = "${module.vpc_spoke2.vpc_self_link}"

  provisioner "local-exec" {
    command = "sleep 45"
  }

  depends_on = [
    "google_compute_network_peering.trust_to_spoke1",
  ]
}
