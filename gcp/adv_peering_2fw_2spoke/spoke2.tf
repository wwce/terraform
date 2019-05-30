provider "google" {
  credentials = "${var.spoke2_project_authfile}"
  project     = "${var.spoke2_project}"
  region      = "${var.region}"
  alias       = "spoke2"
}

#************************************************************************************
# CREATE SPOKE2 VPC & SPOKE2 VM
#************************************************************************************
module "vpc_spoke2" {
  source            = "./modules/create_vpc/"
  vpc_name          = "spoke2-vpc"
  subnetworks       = ["spoke2-subnet"]
  ip_cidrs          = ["10.10.2.0/24"]
  regions           = ["${var.region}"]
  ingress_allow_all = true
  ingress_sources   = ["0.0.0.0/0"]

  providers = {
    google = "google.spoke2"
  }
}

module "vm_spoke2" {
  source          = "./modules/create_vm/"
  vm_names        = ["spoke2-vm1"]
  vm_zones        = ["${var.region}-a"]
  vm_machine_type = "f1-micro"
  vm_image        = "ubuntu-os-cloud/ubuntu-1604-lts"
  vm_subnetworks  = ["${module.vpc_spoke2.subnetwork_self_link[0]}"]
  vm_ssh_key      = "ubuntu:${var.ubuntu_ssh_key}"

  providers = {
    google = "google.spoke2"
  }
}

#************************************************************************************
# CREATE PEERING LINK SPOKE2-to-TRUST
#************************************************************************************
resource "google_compute_network_peering" "spoke2_to_trust" {
  name         = "spoke2-to-trust"
  network      = "${module.vpc_spoke2.vpc_self_link}"
  peer_network = "${module.vpc_trust.vpc_self_link}"

  provisioner "local-exec" {
    command = "sleep 45"
  }

  depends_on = [
    "google_compute_network_peering.spoke1_to_trust",
  ]
  provider = "google.spoke2"
}
