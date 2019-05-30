provider "google" {
  credentials = "${var.spoke1_project_authfile}"
  project     = "${var.spoke1_project}"
  region      = "${var.region}"
  alias       = "spoke1"
}

#************************************************************************************
# CREATE SPOKE2 VPC & SPOKE1 VMs (w/ INTLB)
#************************************************************************************
module "vpc_spoke1" {
  source            = "./modules/create_vpc/"
  vpc_name          = "spoke1-vpc"
  subnetworks       = ["spoke1-subnet"]
  ip_cidrs          = ["10.10.1.0/24"]
  regions           = ["${var.region}"]
  ingress_allow_all = true
  ingress_sources   = ["0.0.0.0/0"]

  providers = {
    google = "google.spoke1"
  }
}

module "vm_spoke1" {
  source          = "./modules/create_vm/"
  vm_names        = ["spoke1-vm1", "spoke1-vm2"]
  vm_zones        = ["${var.region}-a", "${var.region}-a"]
  vm_machine_type = "f1-micro"
  vm_image        = "ubuntu-os-cloud/ubuntu-1604-lts"
  vm_subnetworks  = ["${module.vpc_spoke1.subnetwork_self_link[0]}", "${module.vpc_spoke1.subnetwork_self_link[0]}"]
  vm_ssh_key      = "ubuntu:${var.ubuntu_ssh_key}"
  startup_script  = "${file("${path.module}/scripts/webserver-startup.sh")}"                                         // default "" - runs no startup script

  internal_lb_create = true           // default false
  internal_lb_name   = "spoke1-intlb" // default "intlb"
  internal_lb_ports  = ["80", "443"]  // default ["80"]
  internal_lb_ip     = "10.10.1.100"  // default "" (assigns an any available IP in subnetwork )

  providers = {
    google = "google.spoke1"
  }
}

#************************************************************************************
# CREATE PEERING LINK SPOKE1-to-TRUST
#************************************************************************************
resource "google_compute_network_peering" "spoke1_to_trust" {
  name         = "spoke1-to-trust"
  network      = "${module.vpc_spoke1.vpc_self_link}"
  peer_network = "${module.vpc_trust.vpc_self_link}"

  provisioner "local-exec" {
    command = "sleep 45"
  }

  depends_on = [
    "google_compute_network_peering.trust_to_spoke2",
  ]
  provider = "google.spoke1"
}
