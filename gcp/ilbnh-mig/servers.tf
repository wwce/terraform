#-----------------------------------------------------------------------------------------------
# Create N webservers in one subnet. N is determined by the number of hostnames in the list
module "server1" {
  source                = "./modules/vm/"
  names                 = var.server1_vms
  zones                 = [data.google_compute_zones.available.names[0]]
  subnetworks           = [module.vpc0.subnetwork_self_link]
  server_ips            = var.server1_ips
  server_public_ip      = var.server_public_ip
  machine_type          = var.server_size
  image                 = var.server_image
  ssh_key               = fileexists(var.public_key_path) ? "${var.server_user}:${file(var.public_key_path)}" : ""
  startup_script        = file("${path.module}/scripts/webserver-startup.sh")
}

#-----------------------------------------------------------------------------------------------
# Create X webservers in another subnet. X is determined by the number of hostnames in the list
module "server2" {
  source                = "./modules/vm/"
  names                 = var.server2_vms
  zones                 = [data.google_compute_zones.available.names[0]]
  subnetworks           = [module.vpc2.subnetwork_self_link]
  server_ips            = var.server2_ips
  server_public_ip      = var.server_public_ip
  machine_type          = var.server_size
  image                 = var.server_image
  ssh_key               = fileexists(var.public_key_path) ? "${var.server_user}:${file(var.public_key_path)}" : ""
  startup_script        = file("${path.module}/scripts/webserver-startup.sh")
}