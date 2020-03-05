resource "oci_core_vnic_attachment" "firewall1_untrust" {
  instance_id  = "${oci_core_instance.firewall1.id}"
  display_name = "firewall1_untrust"

  create_vnic_details {
    subnet_id               = "${oci_core_subnet.untrust.id}"
    private_ip              = "${var.fw1_untrust_ip}"
    display_name            = "untrust"
    assign_public_ip        = false
    skip_source_dest_check  = true
    #nsg_ids                 = ["${oci_core_network_security_group.untrust.id}"]
  }
}
resource "oci_core_vnic_attachment" "firewall1_trust" {
  instance_id  = "${oci_core_instance.firewall1.id}"
  display_name = "firewall1_trust"

  create_vnic_details {
    subnet_id              = "${oci_core_subnet.trust.id}"
    private_ip              = "${var.fw1_trust_ip}"
    display_name           = "trust"
    assign_public_ip       = false
    skip_source_dest_check = true
    #nsg_ids                = ["${oci_core_network_security_group.trust.id}"]
  }
  depends_on = ["oci_core_vnic_attachment.firewall1_untrust"]
}
resource "oci_core_vnic_attachment" "firewall1_ha2" {
  instance_id  = "${oci_core_instance.firewall1.id}"
  display_name = "firewall1_ha2"

  create_vnic_details {
    subnet_id              = "${oci_core_subnet.ha2.id}"
    private_ip              = "${var.fw1_ha2_ip}"
    display_name           = "ha2"
    assign_public_ip       = false
    skip_source_dest_check = false
    #nsg_ids                = ["${oci_core_network_security_group.ha.id}"]
  }
  depends_on = ["oci_core_vnic_attachment.firewall1_trust"]
}
resource "oci_core_vnic_attachment" "firewall2_untrust" {
  instance_id  = "${oci_core_instance.firewall2.id}"
  display_name = "firewall2_untrust"

  create_vnic_details {
    subnet_id              = "${oci_core_subnet.untrust.id}"
    private_ip              = "${var.fw2_untrust_ip}"
    display_name           = "untrust"
    assign_public_ip       = false
    skip_source_dest_check = true
    #nsg_ids                = ["${oci_core_network_security_group.untrust.id}"]
  }
}
resource "oci_core_vnic_attachment" "firewall2_trust" {
  instance_id  = "${oci_core_instance.firewall2.id}"
  display_name = "firewall2_trust"

  create_vnic_details {
    subnet_id              = "${oci_core_subnet.trust.id}"
    private_ip              = "${var.fw2_trust_ip}"
    display_name           = "trust"
    assign_public_ip       = false
    skip_source_dest_check = true
    #nsg_ids                = ["${oci_core_network_security_group.trust.id}"]
  }
  depends_on = ["oci_core_vnic_attachment.firewall2_untrust"]
}
resource "oci_core_vnic_attachment" "firewall2_ha2" {
  instance_id  = "${oci_core_instance.firewall2.id}"
  display_name = "firewall2_ha2"

  create_vnic_details {
    subnet_id              = "${oci_core_subnet.ha2.id}"
    private_ip              = "${var.fw2_ha2_ip}"
    display_name           = "ha2"
    assign_public_ip       = false
    skip_source_dest_check = false
    #nsg_ids                = ["${oci_core_network_security_group.ha.id}"]
  }
  depends_on = ["oci_core_vnic_attachment.firewall2_trust"]
}