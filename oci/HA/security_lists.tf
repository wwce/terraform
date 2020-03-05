resource "oci_core_security_list" "management" {
  compartment_id = "${oci_identity_compartment.compartment.id}"
  vcn_id         = "${oci_core_vcn.vcn.id}"
  display_name   = "SL-mgmt"
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
    stateless = false
  }
  ingress_security_rules {
    protocol  = "6"
    source    = "${var.fw_mgmt_src_ip}"
    stateless = false
    tcp_options {
      min = 22
      max = 22
    }
  }
  ingress_security_rules {
    protocol  = "6"
    source    = "${var.fw_mgmt_src_ip}"
    stateless = false
    tcp_options {
      min = 443
      max = 443
    }
  }
  ingress_security_rules {
    protocol  = "all"
    source    = "${var.management_cidr}"
    stateless = false
  }
}
resource "oci_core_security_list" "untrust" {
  compartment_id = "${oci_identity_compartment.compartment.id}"
  vcn_id         = "${oci_core_vcn.vcn.id}"
  display_name   = "SL-untrust"
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
    stateless = false
  }
  ingress_security_rules {
    protocol  = "all"
    source    = "0.0.0.0/0"
    stateless = false
  }
}
resource "oci_core_security_list" "trust" {
  compartment_id = "${oci_identity_compartment.compartment.id}"
  vcn_id         = "${oci_core_vcn.vcn.id}"
  display_name   = "SL-trust"
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
    stateless = false
  }
  ingress_security_rules {
    protocol  = "all"
    source    = "0.0.0.0/0"
    stateless = false
  }
}
resource "oci_core_security_list" "web" {
  compartment_id = "${oci_identity_compartment.compartment.id}"
  vcn_id         = "${oci_core_vcn.vcn.id}"
  display_name   = "SL-web"
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
    stateless = false
  }
  ingress_security_rules {
    protocol  = "all"
    source    = "0.0.0.0/0"
    stateless = false
  }
}