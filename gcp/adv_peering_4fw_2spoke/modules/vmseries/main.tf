resource "null_resource" "dependency_getter" {
  provisioner "local-exec" {
    command = "echo ${length(var.dependencies)}"
  }
}

resource "google_compute_instance" "vmseries" {
  count                     = length(var.names)
  name                      = element(var.names, count.index)
  machine_type              = var.machine_type
  zone                      = element(var.zones, count.index)
  min_cpu_platform          = var.cpu_platform
  can_ip_forward            = true
  allow_stopping_for_update = true
  tags                      = var.tags

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
    network_ip = element(var.nic0_ip, count.index)
    subnetwork = var.subnetworks[0]
  }

  network_interface {
    dynamic "access_config" {
      for_each = var.nic1_public_ip ? [""] : []
      content {}
    }
    network_ip = element(var.nic1_ip, count.index)
    subnetwork = var.subnetworks[1]
  }

  network_interface {
    dynamic "access_config" {
      for_each = var.nic2_public_ip ? [""] : []
      content {}
    }
    network_ip = element(var.nic2_ip, count.index)
    subnetwork = var.subnetworks[2]
  }

  boot_disk {
    initialize_params {
      image = var.image
      type  = var.disk_type
    }
  }

  depends_on = [
    null_resource.dependency_getter
  ]
}

resource "google_compute_instance_group" "vmseries" {
  count     = var.create_instance_group ? length(var.names) : 0
  name      = "${element(var.names, count.index)}-${element(var.zones, count.index)}-ig"
  zone      = element(var.zones, count.index)
  instances = [google_compute_instance.vmseries[count.index].self_link]

  named_port {
    name = "http"
    port = "80"
  }

  lifecycle {
    create_before_destroy = true
  }
}

