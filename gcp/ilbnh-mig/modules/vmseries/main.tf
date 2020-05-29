resource "google_compute_instance_template" "vmseries" {
  name                      = "vmseries-template"
  description               = "This template is used to create firewall instances."
  instance_description      = "VM-Series for ILBNH"
  region                    = var.region
  machine_type              = var.machine_type
  min_cpu_platform          = var.cpu_platform
  can_ip_forward            = true
  tags                      = var.tags
  
  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  metadata = {
    mgmt-interface-swap                  = var.mgmt_interface_swap
    vmseries-bootstrap-gce-storagebucket = var.bootstrap_bucket
    serial-port-enable                   = true
    ssh-keys                             = var.ssh_key
  }

  service_account {
    scopes = var.scopes
  }

  network_interface {

    dynamic "access_config" {
      for_each = var.nic0_public_ip ? [""] : []
      content {}
    }
    subnetwork = var.subnetworks[0]
  }

  network_interface {
    dynamic "access_config" {
      for_each = var.nic1_public_ip ? [""] : []
      content {}
    }
    subnetwork = var.subnetworks[1]
  }

  network_interface {
    dynamic "access_config" {
      for_each = var.nic2_public_ip ? [""] : []
      content {}
    }
    subnetwork = var.subnetworks[2]
  }

  network_interface {
    dynamic "access_config" {
      for_each = var.nic3_public_ip ? [""] : []
      content {}
    }
    subnetwork = var.subnetworks[3]
  }

  disk {
      source_image = var.image
      type         = var.disk_type
  }

  lifecycle {
    create_before_destroy = "true"
  }
}

resource "google_compute_region_instance_group_manager" "vmseries_rigm" {
  name               = "vmseries-rigm"
  base_instance_name = var.base_name
  region             = var.region
  target_size        = var.target_size

  version {
    instance_template  = google_compute_instance_template.vmseries.self_link
  }

  named_port {
    name = "http"
    port = "80"
  }
}