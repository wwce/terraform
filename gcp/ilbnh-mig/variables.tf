variable project_id {
  description = "GCP Project ID"
}

variable auth_file {
  description = "GCP Project auth file"
  default     = ""
}

variable region {
}

variable fw_panos {
  description = "VM-Series license and PAN-OS (ie: bundle1-814, bundle2-814, or byol-814)"
}

variable fw_image {
  default = "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/vmseries"
}

variable fw_base_name {
}

variable target_size {
}

variable fw_machine_type {
}

variable mgmt_sources {
  type = list(string)
}

variable health_check_port {
  description = "Port the ILB will health check"
  default     = "22"
}

variable all_ports {
  description = "Enable all ports on the ILB"
  default     = true
}
variable vpc1 {
}

variable vpc1_subnet {
}

variable vpc1_cidr {
}

variable vpc0 {
}

variable vpc0_subnet {
}

variable vpc0_cidr {
}

variable vpc2 {
}

variable vpc2_subnet {
}

variable vpc2_cidr {
}

variable vpc3 {
}

variable vpc3_subnet {
}

variable vpc3_cidr {
}

variable server1_vms {
  type = list(string)
}

variable server1_ips {
  type = list(string)
}

variable server2_vms {
  type = list(string)
}

variable server_user {
  description = "SSH user for Linux VM"
}

variable server2_ips {
  type = list(string)
}

variable server_size {
  description = "Machine size for the server VMs"
}

variable server_image {
  description = "OS image for server installation"
}

variable server_public_ip {
  description = "Should we assign a public IP to the server"
  default     = false
}

variable public_key_path {
  description = "Local path to public SSH key.  If you do not have a public key, run >> ssh-keygen -f ~/.ssh/demo-key -t rsa -C admin"
}

variable ilb1_ip {
  description = "IP address for ILB1"
}

variable ilb2_ip {
  description = "IP address for ILB2"
}
