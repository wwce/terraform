/*
*************************************************************************************************************
**                                                                                                         **
**  author:  mmclimans                                                                                     **
**  date:    4/1/19                                                                                        **
**  contact: mmclimans@paloaltonetworks.com                                                                **
**                                                                                                         **  
**                                              SUPPORT POLICY                                             **
**                                                                                                         **
**  This build is released under an as-is, best effort, support policy.                                    **
**  These scripts should be seen as community supported and Palo Alto Networks will contribute our         **
**  expertise as and when possible. We do not provide technical support or help in using or                **
**  troubleshooting the components of the project through our normal support options such as               **
**  Palo Alto Networks support teams, or ASC (Authorized Support Centers) partners and backline support    ** 
**  options. The underlying product used (the VM-Series firewall) by the scripts or templates are still    ** 
**  supported, but the support is only for the product functionality and not for help in deploying or      ** 
**  using the template or script itself. Unless explicitly tagged,  all projects or work posted in our     **
**  GitHub repository (at https://github.com/PaloAltoNetworks) or sites other than our official Downloads  **
**  page on https://support.paloaltonetworks.com are provided under the best effort policy.                **
**                                                                                                         **
*************************************************************************************************************
*/

# SET AUTHENTICATION TO GCE API
provider "google" {
  credentials = "${file(var.gcp_credentials_file)}"
  project     = "${var.my_gcp_project}"
  region      = "${var.region}"
}

############################################################################################
############################################################################################
# CREATE BUCKET & UPLOAD VMSERIES BOOTSTRAP FILES
resource "google_storage_bucket" "bootstrap" {
  name          = "${var.bootstrap_bucket}"
  force_destroy = true
}
resource "google_storage_bucket_object" "bootstrap_xml" {
  name   = "config/bootstrap.xml"
  source = "bootstrap/bootstrap.xml"
  bucket = "${google_storage_bucket.bootstrap.name}"
}
resource "google_storage_bucket_object" "init-cfg" {
  name   = "config/init-cfg.txt"
  source = "bootstrap/init-cfg.txt"
  bucket = "${google_storage_bucket.bootstrap.name}"
}
resource "google_storage_bucket_object" "content" {
  name   = "content/panupv2-all-contents-8138-5378"
  source = "bootstrap/panupv2-all-contents-8138-5378"
  bucket = "${google_storage_bucket.bootstrap.name}"
}
resource "google_storage_bucket_object" "software" {
  name   = "software/"
  source = "/dev/null"
  bucket = "${google_storage_bucket.bootstrap.name}"
}
resource "google_storage_bucket_object" "license" {
  name   = "license/"
  source = "/dev/null"
  bucket = "${google_storage_bucket.bootstrap.name}"
}


############################################################################################
############################################################################################
# CREATE VPCS AND SUBNETS
resource "google_compute_network" "mgmt" {
  name                    = "${var.mgmt_vpc}"
  auto_create_subnetworks = "false"
}
resource "google_compute_subnetwork" "mgmt_subnet" {
  name          = "${var.mgmt_vpc_subnet}"
  ip_cidr_range = "${var.mgmt_vpc_subnet_cidr}"
  network       = "${google_compute_network.mgmt.name}"
  region        = "${var.region}"
}
resource "google_compute_network" "untrust" {
  name                    = "${var.untrust_vpc}"
  auto_create_subnetworks = "false"
}
resource "google_compute_subnetwork" "untrust_subnet" {
  name          = "${var.untrust_vpc_subnet}"
  ip_cidr_range = "${var.untrust_vpc_subnet_cidr}"
  network       = "${google_compute_network.untrust.name}"
  region        = "${var.region}"
}
resource "google_compute_network" "web" {
  name                    = "${var.web_vpc}"
  auto_create_subnetworks = "false"
}
resource "google_compute_subnetwork" "web_subnet" {
  name          = "${var.web_vpc_subnet}"
  ip_cidr_range = "${var.web_vpc_subnet_cidr}"
  network       = "${google_compute_network.web.name}"
  region        = "${var.region}"
}
resource "google_compute_network" "db" {
  name                    = "${var.db_vpc}"
  auto_create_subnetworks = "false"
}
resource "google_compute_subnetwork" "db_subnet" {
  name          = "${var.db_vpc_subnet}"
  ip_cidr_range = "${var.db_vpc_subnet_cidr}"
  network       = "${google_compute_network.db.name}"
  region        = "${var.region}"
}


############################################################################################
############################################################################################
# CREATE GCP VPC ROUTES
resource "google_compute_route" "web_vpc_route" {
  name        = "web-vpc-route"
  dest_range  = "0.0.0.0/0"
  network     = "${google_compute_network.web.name}"
  next_hop_ip = "${var.fw_nic2_ip}"
  priority    = 100
  depends_on = [
    "google_compute_instance.firewall",
    "google_compute_subnetwork.mgmt_subnet",
    "google_compute_subnetwork.untrust_subnet",
    "google_compute_subnetwork.web_subnet",
    "google_compute_subnetwork.db_subnet",
  ]
}
resource "google_compute_route" "db_vpc_route" {
  name        = "db-vpc-route"
  dest_range  = "0.0.0.0/0"
  network     = "${google_compute_network.db.name}"
  next_hop_ip = "${var.fw_nic3_ip}"
  priority    = 100
  depends_on = [
    "google_compute_instance.firewall",
    "google_compute_subnetwork.mgmt_subnet",
    "google_compute_subnetwork.untrust_subnet",
    "google_compute_subnetwork.web_subnet",
    "google_compute_subnetwork.db_subnet",
  ]
}


############################################################################################
############################################################################################
# CREATE GCP VPC FIREWALL RULES
resource "google_compute_firewall" "mgmt_vpc_ingress" {
  name          = "mgmt-ingress"
  network       = "${google_compute_network.mgmt.name}"
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["443", "22", "3897"]
  }
}
resource "google_compute_firewall" "mgmt_vpc_egress" {
  name               = "mgmt-vpc-egress"
  network            = "${google_compute_network.mgmt.name}"
  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "all"
  }
}
resource "google_compute_firewall" "untrust_vpc_ingress" {
  name          = "untrust-vpc-ingress"
  network       = "${google_compute_network.untrust.name}"
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "all"
  }
}
resource "google_compute_firewall" "untrust_vpc_egress" {
  name               = "untrust-vpc-egress"
  network            = "${google_compute_network.untrust.name}"
  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "all"
  }
}
resource "google_compute_firewall" "web_vpc_ingress" {
  name          = "web-vpc-ingress"
  network       = "${google_compute_network.web.name}"
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "all"
  }
}
resource "google_compute_firewall" "web_vpc_egress" {
  name               = "web-vpc-egress"
  network            = "${google_compute_network.web.name}"
  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "all"
  }
}
resource "google_compute_firewall" "db_vpc_ingress" {
  name          = "db-vpc-ingress"
  network       = "${google_compute_network.db.name}"
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "all"
  }
}
resource "google_compute_firewall" "db_vpc_egress" {
  name               = "db-vpc-egress"
  network            = "${google_compute_network.db.name}"
  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "all"
  }
}


############################################################################################
############################################################################################
# CREATE VM-SERIES
resource "google_compute_instance" "firewall" {
  name                      = "${var.fw_vm_name}"
  machine_type              = "${var.fw_machine_type}"
  zone                      = "${var.zone}"
  min_cpu_platform          = "${var.fw_machine_cpu}"
  can_ip_forward            = true
  allow_stopping_for_update = true
  count                     = 1

  metadata {
    vmseries-bootstrap-gce-storagebucket = "${var.bootstrap_bucket}"
    serial-port-enable                   = true
  }
  service_account {
    scopes = "${var.fw_scopes}"
  }
  network_interface {
    subnetwork    = "${google_compute_subnetwork.mgmt_subnet.name}"
    network_ip    = "${var.fw_nic0_ip}"
    access_config = {}
  }
  network_interface {
    subnetwork    = "${google_compute_subnetwork.untrust_subnet.name}"
    network_ip    = "${var.fw_nic1_ip}"
    access_config = {}
  }
  network_interface {
    subnetwork = "${google_compute_subnetwork.web_subnet.name}"
    network_ip    = "${var.fw_nic2_ip}"
  }
  network_interface {
    subnetwork = "${google_compute_subnetwork.db_subnet.name}"
    network_ip    = "${var.fw_nic3_ip}"
  }
  boot_disk {
    initialize_params {
      image = "${var.fw_image}"
    }
  }
    depends_on = [
    "google_storage_bucket.bootstrap",
    "google_storage_bucket_object.bootstrap_xml",
    "google_storage_bucket_object.init-cfg",
    "google_storage_bucket_object.content",
    "google_storage_bucket_object.license",
    "google_storage_bucket_object.software",
  ]
}


############################################################################################
############################################################################################
# CREATE DB SERVER
resource "google_compute_instance" "dbserver" {
  name                      = "${var.db_vm_name}"
  machine_type              = "${var.db_machine_type}"
  zone                      = "${var.zone}"
  can_ip_forward            = true
  allow_stopping_for_update = true
  count                     = 1
  metadata_startup_script   = "${file("${path.module}/scripts/dbserver-startup.sh")}"
  metadata {
    serial-port-enable = true
    sshKeys            = "${var.gcp_ssh_user}:${file(var.gcp_key_file)}"
  }
  network_interface {
    subnetwork = "${google_compute_subnetwork.db_subnet.name}"
    network_ip = "${var.db_nic0_ip}"
  }
  service_account {
    scopes     = "${var.vm_scopes}"
  }
  boot_disk {
    initialize_params {
      image = "${var.vm_image}"
    }
  }
  depends_on = [
    "google_compute_instance.firewall",
    "google_compute_subnetwork.mgmt_subnet",
    "google_compute_subnetwork.untrust_subnet",
    "google_compute_subnetwork.web_subnet",
    "google_compute_subnetwork.db_subnet",
  ]
}


############################################################################################
############################################################################################
# CREATE WEB SERVER
resource "google_compute_instance" "webserver" {
  name                      = "${var.web_vm_name}"
  machine_type              = "${var.web_machine_type}"
  zone                      = "${var.zone}"
  can_ip_forward            = true
  allow_stopping_for_update = true
  count                     = 1
  metadata_startup_script   = "${file("${path.module}/scripts/webserver-startup.sh")}"
  metadata {
    serial-port-enable = true
    sshKeys            = "${var.gcp_ssh_user}:${file(var.gcp_key_file)}"
  }
  network_interface {
    subnetwork = "${google_compute_subnetwork.web_subnet.name}"
    network_ip = "${var.web_nic0_ip}"
  }
  boot_disk {
    initialize_params {
      image = "${var.vm_image}"
    }
  }
  service_account {
    scopes = "${var.vm_scopes}"
  }
  depends_on = [
    "google_compute_instance.firewall",
    "google_compute_subnetwork.mgmt_subnet",
    "google_compute_subnetwork.untrust_subnet",
    "google_compute_subnetwork.web_subnet",
    "google_compute_subnetwork.db_subnet",
  ]
}


############################################################################################
############################################################################################
output "DEPLOYMENT STATUS" {
    value = "COMPLETE"
}