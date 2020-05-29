resource "oci_core_instance" "web1" {
  availability_domain = "${var.server_availability_domain}"
  compartment_id      = "${oci_identity_compartment.compartment.id}"
  display_name        = "web1"
  shape               = "${var.server_shape_size}"

  create_vnic_details {
    subnet_id        = "${oci_core_subnet.web.id}"
    display_name     = "web1"
    private_ip        = "${var.web1_ip}"
    assign_public_ip = false
  }

  source_details {
    source_type = "image"
    source_id   = "${var.ubuntu_image_ocid[var.region]}"
    boot_volume_size_in_gbs = "60"
  }
  metadata = {
    ssh_authorized_keys = "${var.ssh_authorized_key}"
    #user_data           = "${base64encode(file("./userdata/bootstrap"))}"
  }
  timeouts {
    create = "60m"
  }
}