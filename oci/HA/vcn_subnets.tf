resource "oci_core_vcn" "vcn" {
  cidr_block      = "${var.vcn_cidr}"
  compartment_id  = "${oci_identity_compartment.compartment.id}"
  display_name    = "VCN-PANW"
}
resource "oci_core_subnet" "management" {
  cidr_block          = "${var.management_cidr}"
  display_name        = "mgmt"
  compartment_id      = "${oci_identity_compartment.compartment.id}"
  vcn_id              = "${oci_core_vcn.vcn.id}"
  route_table_id      = "${oci_core_route_table.public.id}"
  security_list_ids   = ["${oci_core_security_list.management.id}"]
}
resource "oci_core_subnet" "untrust" {
  cidr_block          = "${var.untrust_cidr}"
  display_name        = "untrust"
  compartment_id      = "${oci_identity_compartment.compartment.id}"
  vcn_id              = "${oci_core_vcn.vcn.id}"
  route_table_id      = "${oci_core_route_table.public.id}"
  security_list_ids   = ["${oci_core_security_list.untrust.id}"]
}
resource "oci_core_subnet" "trust" {
  cidr_block          = "${var.trust_cidr}"
  display_name        = "trust"
  compartment_id      = "${oci_identity_compartment.compartment.id}"
  vcn_id              = "${oci_core_vcn.vcn.id}"
  security_list_ids   = ["${oci_core_security_list.trust.id}"]
  prohibit_public_ip_on_vnic   = true
}
resource "oci_core_subnet" "ha2" {
  cidr_block          = "${var.ha2_cidr}"
  display_name        = "HA2"
  compartment_id      = "${oci_identity_compartment.compartment.id}"
  vcn_id              = "${oci_core_vcn.vcn.id}"
  security_list_ids   = ["${oci_core_security_list.trust.id}"]
  prohibit_public_ip_on_vnic   = true
}
resource "oci_core_subnet" "web" {
  cidr_block          = "${var.web_cidr}"
  display_name        = "web"
  compartment_id      = "${oci_identity_compartment.compartment.id}"
  vcn_id              = "${oci_core_vcn.vcn.id}"
  route_table_id      = "${oci_core_route_table.web.id}"
  security_list_ids   = ["${oci_core_security_list.web.id}"]
  prohibit_public_ip_on_vnic   = true
}