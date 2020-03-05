// The secondary IP addresses are initially attached to firewall1 but will float between the firewalls in the event of a failover.
resource "oci_core_private_ip" "firewall_untrust_secondary_private" {
    vnic_id = "${oci_core_vnic_attachment.firewall1_untrust.vnic_id}"
    display_name = "firewall_untrust_secondary_private"
    ip_address = "${var.untrust_floating_ip}"
}
resource "oci_core_private_ip" "firewall_trust_secondary_private" {
    vnic_id = "${oci_core_vnic_attachment.firewall1_trust.vnic_id}"
    display_name = "firewall_trust_secondary_private"
    ip_address = "${var.trust_floating_ip}"
}
resource "oci_core_public_ip" "firewall_untrust_secondary_public" {
    compartment_id  = "${oci_identity_compartment.compartment.id}"
    lifetime        = "RESERVED"
    display_name    = "firewall_untrust_secondary_public"
    private_ip_id   = "${oci_core_private_ip.firewall_untrust_secondary_private.id}"
}