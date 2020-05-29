resource "oci_identity_dynamic_group" "ha" {
  compartment_id = "${var.tenancy_ocid}"
  name           = "HA"
  description    = "dynamic group created by terraform"
  matching_rule  = "any {ANY {instance.id = '${oci_core_instance.firewall1.id}',instance.id = '${oci_core_instance.firewall2.id}'}}"
}
resource "oci_identity_policy" "ha" {
  name           = "HA"
  description    = "dynamic policy created by terraform"
  compartment_id = "${oci_identity_compartment.compartment.id}"
  statements = ["Allow dynamic-group ${oci_identity_dynamic_group.ha.name} to use virtual-network-family in compartment ${oci_identity_compartment.compartment.name}",
    "Allow dynamic-group ${oci_identity_dynamic_group.ha.name} to use instance-family in compartment ${oci_identity_compartment.compartment.name}",
  ]
}