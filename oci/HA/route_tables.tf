resource "oci_core_route_table" "public" {
  compartment_id = "${oci_identity_compartment.compartment.id}"
  vcn_id         = "${oci_core_vcn.vcn.id}"
  display_name   = "RT-Public"

  route_rules {
    description       = "default"
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = "${oci_core_internet_gateway.internet_gateway.id}"
  }
}
resource "oci_core_route_table" "web" {
  compartment_id = "${oci_identity_compartment.compartment.id}"
  vcn_id         = "${oci_core_vcn.vcn.id}"
  display_name   = "RT-Web"

  route_rules {
    description       = "default"
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = "${oci_core_private_ip.firewall_trust_secondary_private.id}"
  }
}