resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = "${oci_identity_compartment.compartment.id}"
  vcn_id = "${oci_core_vcn.vcn.id}"
  display_name = "IG-PANW"
  enabled = true
}