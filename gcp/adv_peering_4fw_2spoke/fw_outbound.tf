#-----------------------------------------------------------------------------------------------
# Create bootstrap bucket for outbound firewalls
module "bootstrap_outbound" {
  source        = "./modules/gcp_bootstrap/"
  bucket_name   = "fw-bootstrap-egress"
  file_location = "bootstrap_files/fw_outbound/"
  config        = ["init-cfg.txt", "bootstrap.xml"]
  license       = ["authcodes"]
}

#-----------------------------------------------------------------------------------------------
# Create outbound firewalls 
module "fw_outbound" {
  source = "./modules/vmseries/"
  names  = var.fw_names_outbound
  zones  = [
    data.google_compute_zones.available.names[0],
    data.google_compute_zones.available.names[1]
  ]
  subnetworks = [
    module.vpc_trust.subnetwork_self_link[0],
    module.vpc_mgmt.subnetwork_self_link[0],
    module.vpc_untrust.subnetwork_self_link[0]
  ]
  machine_type          = var.fw_machine_type
  bootstrap_bucket      = module.bootstrap_outbound.bucket_name
  mgmt_interface_swap   = "enable"
  ssh_key               = fileexists(var.public_key_path) ? "admin:${file(var.public_key_path)}" : ""
  image                 = "${var.fw_image}-${var.fw_panos}"
  nic0_public_ip        = false
  nic1_public_ip        = true
  nic2_public_ip        = true
  create_instance_group = true

  dependencies = [
    module.bootstrap_outbound.completion,
  ]
}

#-----------------------------------------------------------------------------------------------
# Create 2 internal load balancers. LB-1 is A/A for internet.  LB-2 is A/P for e-w.
module "ilb" {
  source            = "./modules/ilb/"
  name              = var.ilb_name
  subnetworks       = [module.vpc_trust.subnetwork_self_link[0]]
  all_ports         = true
  ports             = []
  health_check_port = "22"

  backends = {
    "0" = [
      {
        group    = module.fw_outbound.instance_group[0]
        failover = false
      },
      {
        group    = module.fw_outbound.instance_group[1]
        failover = false
      }
    ],
    "1" = [
      {
        group    = module.fw_outbound.instance_group[0]
        failover = false
      },
      {
        group    = module.fw_outbound.instance_group[1]
        failover = true
      }
    ]
  }
  providers = {
    google = google-beta
  }
}

#-----------------------------------------------------------------------------------------------
# Create default route to internal LB. Route will be exported to spokes via GCP peering.
resource "google_compute_route" "default" {
  name         = "${var.ilb_name}-default"
  provider     = google-beta
  dest_range   = "0.0.0.0/0"
  network      = module.vpc_trust.vpc_self_link
  next_hop_ilb = module.ilb.forwarding_rule[0]
  priority     = 99
}

resource "google_compute_route" "eastwest" {
  name         = "${var.ilb_name}-eastwest"
  provider     = google-beta
  dest_range   = "10.10.0.0/16"
  network      = module.vpc_trust.vpc_self_link
  next_hop_ilb = module.ilb.forwarding_rule[1]
  priority     = 99
}
