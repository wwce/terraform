provider "panos" {
  hostname = "${var.FW_Mgmt_IP}"
  username = "${var.Admin_Username}"
  password = "${var.Admin_Password}"
}

resource "panos_management_profile" "imp_allow_ping" {
  name = "Allow ping"
  ping = true
}

resource "panos_ethernet_interface" "eth1_1" {
  name                      = "ethernet1/1"
  vsys                      = "vsys1"
  mode                      = "layer3"
  comment                   = "External interface"
  enable_dhcp               = true
  create_dhcp_default_route = true
  management_profile = "${panos_management_profile.imp_allow_ping.name}"
}

resource "panos_ethernet_interface" "eth1_2" {
  name        = "ethernet1/2"
  vsys        = "vsys1"
  mode        = "layer3"
  comment     = "Web interface"
  enable_dhcp = true
}

resource "panos_zone" "zone_untrust" {
  name       = "UNTRUST"
  mode       = "layer3"
  interfaces = ["${panos_ethernet_interface.eth1_1.name}"]
}

resource "panos_zone" "zone_trust" {
  name       = "TRUST"
  mode       = "layer3"
  interfaces = ["${panos_ethernet_interface.eth1_2.name}"]
}

resource "panos_service_object" "so_22" {
  name             = "service-tcp-22"
  protocol         = "tcp"
  destination_port = "22"
}

resource "panos_service_object" "so_221" {
  name             = "service-tcp-221"
  protocol         = "tcp"
  destination_port = "221"
}

resource "panos_service_object" "so_222" {
  name             = "service-tcp-222"
  protocol         = "tcp"
  destination_port = "222"
}

resource "panos_address_object" "intLB" {
  name        = "GCP-Int-LB"
  value       = "${var.WebLB_IP}"
  description = "GCP Int LB Address"
}

resource "panos_security_policies" "security_policies" {
  rule {
    name                  = "SSH inbound"
    source_zones          = ["${panos_zone.zone_untrust.name}"]
    source_addresses      = ["any"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = ["${panos_zone.zone_trust.name}"]
    destination_addresses = ["any"]
    applications          = ["ssh", "ping"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    name                  = "SSH 221-222 inbound"
    source_zones          = ["${panos_zone.zone_untrust.name}"]
    source_addresses      = ["any"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = ["${panos_zone.zone_trust.name}"]
    destination_addresses = ["any"]
    applications          = ["ssh", "ping"]
    services              = ["${panos_service_object.so_221.name}", "${panos_service_object.so_222.name}"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    name                  = "Allow all ping"
    source_zones          = ["any"]
    source_addresses      = ["any"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = ["any"]
    destination_addresses = ["any"]
    applications          = ["ping"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    name                  = "Permit Health Checks"
    source_zones          = ["${panos_zone.zone_untrust.name}"]
    source_addresses      = ["any"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = ["${panos_zone.zone_trust.name}"]
    destination_addresses = ["any"]
    applications          = ["google-health-check"]
    services              = ["service-http"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    name                  = "Web browsing"
    source_zones          = ["${panos_zone.zone_untrust.name}"]
    source_addresses      = ["any"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = ["${panos_zone.zone_trust.name}", "${panos_zone.zone_untrust.name}"]
    destination_addresses = ["any"]
    applications          = ["web-browsing", "jenkins"]
    services              = ["service-http"]
    categories            = ["any"]
    group                 = "Inbound"
    action                = "allow"
  }

  rule {
    name                  = "Allow all outbound"
    source_zones          = ["${panos_zone.zone_trust.name}"]
    source_addresses      = ["any"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = ["${panos_zone.zone_untrust.name}"]
    destination_addresses = ["any"]
    applications          = ["any"]
    services              = ["application-default"]
    categories            = ["any"]
    group                 = "Outbound"
    action                = "allow"
  }
}

resource "panos_nat_rule_group" "nat" {
  rule {
    name = "Web1 SSH"
    original_packet {
      source_zones          = ["${panos_zone.zone_untrust.name}"]
      destination_zone      = "${panos_zone.zone_untrust.name}"
      source_addresses      = ["any"]
      destination_addresses = ["${var.FW_Untrust_IP}"]
      service               = "${panos_service_object.so_221.name}"
    }
    translated_packet {
      source {
        dynamic_ip_and_port {
          interface_address {
            interface = "${panos_ethernet_interface.eth1_2.name}"
          }
        }
      }
      destination {
        static {
          address = "${var.Webserver_IP1}"
          port = 22
        }
      }
    }
  }
  rule {
    name = "Web2 SSH"
    original_packet {
      source_zones          = ["${panos_zone.zone_untrust.name}"]
      destination_zone      = "${panos_zone.zone_untrust.name}"
      source_addresses      = ["any"]
      destination_addresses = ["${var.FW_Untrust_IP}"]
      service               = "${panos_service_object.so_222.name}"
    }
    translated_packet {
      source {
        dynamic_ip_and_port {
          interface_address {
            interface = "${panos_ethernet_interface.eth1_2.name}"
          }
        }
      }
      destination {
        static {
          address = "${var.Webserver_IP2}"
          port = 22
        }
      }
    }
  }
  rule {
    name = "Webserver NAT"
    original_packet {
      source_zones          = ["${panos_zone.zone_untrust.name}"]
      destination_zone      = "${panos_zone.zone_untrust.name}"
      source_addresses      = ["any"]
      destination_addresses = ["${var.FW_Untrust_IP}"]
      service               = "service-http"
    }
    translated_packet {
      source {
        dynamic_ip_and_port {
          interface_address {
            interface = "${panos_ethernet_interface.eth1_2.name}"
          }
        }
      }
      destination {
        static {
          address = "GCP-Int-LB"
        }
      }
    }
  }
}
resource "panos_virtual_router" "vr1" {
  name       = "default"
  interfaces = ["${panos_ethernet_interface.eth1_1.name}", "${panos_ethernet_interface.eth1_2.name}"]
}