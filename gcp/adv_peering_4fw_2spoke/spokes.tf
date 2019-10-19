#-----------------------------------------------------------------------------------------------
# Create spoke2 vpc with 2 web VMs (with internal LB). Create peer link with trust VPC.
module "vpc_spoke1" {
  source               = "./modules/vpc/"
  vpc                  = var.spoke1_vpc
  subnets              = var.spoke1_subnets
  cidrs                = var.spoke1_cidrs
  regions              = [var.region]
  allowed_sources      = ["0.0.0.0/0"]
  delete_default_route = true
}

module "vm_spoke1" {
  source = "./modules/vm/"
  names  = var.spoke1_vms
  zones = [
    data.google_compute_zones.available.names[0],
    data.google_compute_zones.available.names[1]
  ]
  subnetworks           = [module.vpc_spoke1.subnetwork_self_link[0]]
  machine_type          = "f1-micro"
  image                 = "ubuntu-os-cloud/ubuntu-1604-lts"
  create_instance_group = true
  ssh_key               = fileexists(var.public_key_path) ? "${var.spoke_user}:${file(var.public_key_path)}" : ""
  startup_script        = file("${path.module}/scripts/webserver-startup.sh")
}

module "ilb_web" {
  source            = "./modules/ilb/"
  name              = var.spoke1_ilb
  subnetworks       = [module.vpc_spoke1.subnetwork_self_link[0]]
  all_ports         = false
  ports             = ["80"]
  health_check_port = "80"
  ip_address        = var.spoke1_ilb_ip
  backends = {
    "0" = [
      {
        group    = module.vm_spoke1.instance_group[0]
        failover = false
      },
      {
        group    = module.vm_spoke1.instance_group[1]
        failover = false
      }
    ]
  }
  providers = {
    google = google-beta
  }
}

resource "google_compute_network_peering" "trust_to_spoke1" {
  name                 = "${var.trust_vpc}-to-${var.spoke1_vpc}"
  provider             = google-beta
  network              = module.vpc_trust.vpc_self_link
  peer_network         = module.vpc_spoke1.vpc_self_link
  export_custom_routes = true
}

resource "google_compute_network_peering" "spoke1_to_trust" {
  name                 = "${var.spoke1_vpc}-to-${var.trust_vpc}"
  provider             = google-beta
  network              = module.vpc_spoke1.vpc_self_link
  peer_network         = module.vpc_trust.vpc_self_link
  import_custom_routes = true

  depends_on = [google_compute_network_peering.trust_to_spoke1]
}

#-----------------------------------------------------------------------------------------------
# Create spoke2 vpc with VM.  Create peer link with trust VPC.
module "vpc_spoke2" {
  source               = "./modules/vpc/"
  vpc                  = var.spoke2_vpc
  subnets              = var.spoke2_subnets
  cidrs                = var.spoke2_cidrs
  regions              = [var.region]
  allowed_sources      = ["0.0.0.0/0"]
  delete_default_route = true
}

module "vm_spoke2" {
  source       = "./modules/vm/"
  names        = var.spoke2_vms
  zones        = [data.google_compute_zones.available.names[0]]
  machine_type = "f1-micro"
  image        = "ubuntu-os-cloud/ubuntu-1604-lts"
  subnetworks  = [module.vpc_spoke2.subnetwork_self_link[0]]
  ssh_key      = fileexists(var.public_key_path) ? "${var.spoke_user}:${file(var.public_key_path)}" : ""
}

resource "google_compute_network_peering" "trust_to_spoke2" {
  name                 = "${var.trust_vpc}-to-${var.spoke2_vpc}"
  provider             = google-beta
  network              = module.vpc_trust.vpc_self_link
  peer_network         = module.vpc_spoke2.vpc_self_link
  export_custom_routes = true

  depends_on = [google_compute_network_peering.spoke1_to_trust]
}

resource "google_compute_network_peering" "spoke2_to_trust" {
  name                 = "${var.spoke2_vpc}-to-${var.trust_vpc}"
  provider             = google-beta
  network              = module.vpc_spoke2.vpc_self_link
  peer_network         = module.vpc_trust.vpc_self_link
  import_custom_routes = true

  depends_on = [google_compute_network_peering.trust_to_spoke2]
}

