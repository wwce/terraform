provider "panos" {
  hostname = "${var.mgt-ipaddress-fw1}"
  username = "${var.username}"
  password = "${var.password}"
}

resource "panos_general_settings" "fw1" {
  hostname    = "WebFW1"
  dns_primary = "10.0.0.2"
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

resource "panos_service_object" "so_81" {
  name             = "service-http-81"
  protocol         = "tcp"
  destination_port = "81"
}

resource "panos_address_object" "intNLB" {
  name        = "AWS-Int-NLB"
  type        = "fqdn"
  value       = "${var.nlb-dns}"
  description = "AWS Int NLB Address"
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
    applications          = ["web-browsing", "jenkins"]
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

resource "panos_nat_rule" "nat1" {
  name                  = "Web1 SSH"
  source_zones          = ["${panos_zone.zone_untrust.name}"]
  destination_zone      = "${panos_zone.zone_untrust.name}"
  service               = "${panos_service_object.so_221.name}"
  source_addresses      = ["any"]
  destination_addresses = ["${var.untrust-ipaddress-fw1}"]
  sat_type              = "dynamic-ip-and-port"
  sat_address_type      = "interface-address"
  sat_interface         = "${panos_ethernet_interface.eth1_2.name}"
  dat_type              = "static"
  dat_address           = "${var.WebSrv1_IP}"
  dat_port              = "22"
}

resource "panos_nat_rule" "nat3" {
  name                  = "Webserver NAT"
  source_zones          = ["${panos_zone.zone_untrust.name}"]
  destination_zone      = "${panos_zone.zone_untrust.name}"
  service               = "service-http"
  source_addresses      = ["any"]
  destination_addresses = ["${var.untrust-ipaddress-fw1}"]
  sat_type              = "dynamic-ip-and-port"
  sat_address_type      = "interface-address"
  sat_interface         = "${panos_ethernet_interface.eth1_2.name}"
  dat_type              = "dynamic"
  dat_address           = "AWS-Int-NLB"
  dat_port              = "8080"
}

resource "panos_virtual_router" "vr1" {
  name       = "default"
  interfaces = ["${panos_ethernet_interface.eth1_1.name}", "${panos_ethernet_interface.eth1_2.name}"]
}
