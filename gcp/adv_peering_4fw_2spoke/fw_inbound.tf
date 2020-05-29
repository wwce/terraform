#-----------------------------------------------------------------------------------------------
# Create bootstrap bucket for inbound firewalls
module "bootstrap_inbound" {
  source        = "./modules/gcp_bootstrap/"
  bucket_name   = "fw-bootstrap-inbound"
  file_location = "bootstrap_files/fw_inbound/"
  config        = ["init-cfg.txt", "bootstrap.xml"]
  license       = ["authcodes"]
}

#-----------------------------------------------------------------------------------------------
# Create inbound firewalls
module "fw_inbound" {
  source = "./modules/vmseries/"
  names  = var.fw_names_inbound
  zones  = [
    data.google_compute_zones.available.names[0],
    data.google_compute_zones.available.names[1]
  ]
  subnetworks = [
    module.vpc_untrust.subnetwork_self_link[0],
    module.vpc_mgmt.subnetwork_self_link[0],
    module.vpc_trust.subnetwork_self_link[0]
  ]
  machine_type          = var.fw_machine_type
  bootstrap_bucket      = module.bootstrap_inbound.bucket_name
  mgmt_interface_swap   = "enable"
  ssh_key               = fileexists(var.public_key_path) ? "admin:${file(var.public_key_path)}" : ""
  image                 = "${var.fw_image}-${var.fw_panos}"
  nic0_public_ip        = true
  nic1_public_ip        = true
  nic2_public_ip        = false
  create_instance_group = true

  dependencies = [
    module.bootstrap_inbound.completion,
  ]
}

#-----------------------------------------------------------------------------------------------
# Create public load balancer
module "glb" {
  source = "./modules/glb/"
  name   = var.glb_name
  backends = {
    "0" = [
      {
        group                        = module.fw_inbound.instance_group[0]
        balancing_mode               = null
        capacity_scaler              = null
        description                  = null
        max_connections              = null
        max_connections_per_instance = null
        max_rate                     = null
        max_rate_per_instance        = null
        max_utilization              = null
      },
      {
        group                        = module.fw_inbound.instance_group[1]
        balancing_mode               = null
        capacity_scaler              = null
        description                  = null
        max_connections              = null
        max_connections_per_instance = null
        max_rate                     = null
        max_rate_per_instance        = null
        max_utilization              = null
      }
    ]
  }
  backend_params = [
    // health check path, port name, port number, timeout seconds.
    "/,http,80,10"
  ]
}

