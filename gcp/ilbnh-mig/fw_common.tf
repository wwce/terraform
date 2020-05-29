#-----------------------------------------------------------------------------------------------
# Create bootstrap bucket for firewalls
module "bootstrap_common" {
  source        = "./modules/gcp_bootstrap/"
  bucket_name   = "fw-bootstrap-common"
  file_location = "bootstrap_files/"
  config        = ["init-cfg.txt", "bootstrap.xml"]
#  config        = ["init-cfg.txt"]
  license       = ["authcodes"]
}

#-----------------------------------------------------------------------------------------------
# Create  firewall template
#-----------------------------------------------------------------------------------------------
module "fw_common" {
  source    = "./modules/vmseries/"
  base_name = var.fw_base_name
  region    = var.region
  target_size = var.target_size
  zones = [
    data.google_compute_zones.available.names[0],
    data.google_compute_zones.available.names[1]
  ]
  networks = [
    module.vpc0.network_self_link,
    module.vpc1.network_self_link,
    module.vpc2.network_self_link,
    module.vpc3.network_self_link
  ]
  subnetworks = [
    module.vpc0.subnetwork_self_link,
    module.vpc1.subnetwork_self_link,
    module.vpc2.subnetwork_self_link,
    module.vpc3.subnetwork_self_link
  ]
  machine_type          = var.fw_machine_type
  bootstrap_bucket      = module.bootstrap_common.bucket_name
  mgmt_interface_swap   = "enable"
  ssh_key               = fileexists(var.public_key_path) ? "admin:${file(var.public_key_path)}" : ""
  image                 = "${var.fw_image}-${var.fw_panos}"
  nic0_public_ip        = false
  nic1_public_ip        = true
  nic2_public_ip        = false
  nic3_public_ip        = false
  create_instance_group = true

  dependencies = [
    module.bootstrap_common.completion,
  ]
}

resource "google_compute_health_check" "hc_ssh_22" {
  name      = "hc-ssh-22"

  tcp_health_check {
    port = var.health_check_port
  }
}

module "ilb1" {
  source            = "./modules/ilbnh/"
  name              = "ilb1"
  project_id        = var.project_id
  all_ports         = true
  ports             = []
  health_checks     = [google_compute_health_check.hc_ssh_22.self_link]
  region            = var.region
  network           = module.vpc0.vpc_id
  network_uri       = module.vpc0.network_self_link
  subnetwork        = module.vpc0.subnetwork_self_link
  ip_address        = var.ilb1_ip
  group             = module.fw_common.vmseries_rigm
}

module "ilb2" {
  source            = "./modules/ilbnh/"
  name              = "ilb2"
  project_id        = var.project_id
  all_ports         = true
  ports             = []
  health_checks     = [google_compute_health_check.hc_ssh_22.self_link]
  region            = var.region
  network           = module.vpc2.vpc_id
  network_uri       = module.vpc2.network_self_link
  subnetwork        = module.vpc2.subnetwork_self_link
  ip_address        = var.ilb2_ip
  group             = module.fw_common.vmseries_rigm
  }

#-----------------------------------------------------------------------------------------------
# Create routes route to internal LBs.
resource "google_compute_route" "ilb_nhop_dest_10_30_1" {
  name         = "ilb-nhop-dest-10-30-1"
  dest_range   = "10.30.1.0/24"
  network      = module.vpc2.network_self_link
  next_hop_ilb = module.ilb2.forwarding_rule
  priority     = 99
}

resource "google_compute_route" "ilb_nhop_dest_10_50_1" {
  name         = "ilb-nhop-dest-10-50-1"
  dest_range   = "10.50.1.0/24"
  network      = module.vpc0.network_self_link
  next_hop_ilb = module.ilb1.forwarding_rule
  priority     = 99
}