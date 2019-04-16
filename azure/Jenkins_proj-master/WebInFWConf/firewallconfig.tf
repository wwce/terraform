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

resource "panos_service_object" "so_81" {
  name             = "service-http-81"
  protocol         = "tcp"
  destination_port = "81"
}

resource "panos_address_object" "intLB" {
  name        = "Azure-Int-LB"
  value       = "${var.LB_IP}"
  description = "Azure Int LB Address"
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
    applications          = ["elb-healthchecker"]
    services              = ["application-default"]
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
    applications          = ["web-browsing", "jenkins", "windows-azure-base"]
    services              = ["service-http", "${panos_service_object.so_81.name}"]
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

resource "panos_nat_policy" "nat1" {
  name                  = "Web1 SSH"
  source_zones          = ["${panos_zone.zone_untrust.name}"]
  destination_zone      = "${panos_zone.zone_untrust.name}"
  service               = "${panos_service_object.so_221.name}"
  source_addresses      = ["any"]
  destination_addresses = ["${var.FW_Untrust_IP}"]
  sat_type              = "dynamic-ip-and-port"
  sat_address_type      = "interface-address"
  sat_interface         = "${panos_ethernet_interface.eth1_2.name}"
  dat_type              = "static"
  dat_address           = "${var.Web_IP}"
  dat_port              = "22"
}

resource "panos_nat_policy" "nat3" {
  name                  = "Webserver NAT"
  source_zones          = ["${panos_zone.zone_untrust.name}"]
  destination_zone      = "${panos_zone.zone_untrust.name}"
  service               = "service-http"
  source_addresses      = ["any"]
  destination_addresses = ["${var.FW_Untrust_IP}"]
  sat_type              = "dynamic-ip-and-port"
  sat_address_type      = "interface-address"
  sat_interface         = "${panos_ethernet_interface.eth1_2.name}"
  dat_type              = "dynamic"
  dat_address           = "Azure-Int-LB"
  dat_port              = "8080"
}

resource "panos_virtual_router" "vr1" {
  name       = "default"
  interfaces = ["${panos_ethernet_interface.eth1_1.name}", "${panos_ethernet_interface.eth1_2.name}"]
}

resource "panos_static_route_ipv4" "default" {
    name = "default"
    virtual_router = "${panos_virtual_router.vr1.name}"
    interface = "${panos_ethernet_interface.eth1_1.name}"
    destination = "0.0.0.0/0"
    next_hop = "${var.FW_Default_GW}"
}

resource "panos_static_route_ipv4" "internal" {
    name = "internal"
    virtual_router = "${panos_virtual_router.vr1.name}"
    interface = "${panos_ethernet_interface.eth1_2.name}"
    destination = "${var.Web_Subnet_CIDR}"
    next_hop = "${var.FW_Internal_GW}"
}
