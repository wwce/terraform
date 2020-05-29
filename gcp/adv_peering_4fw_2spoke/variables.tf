variable "project_id" {
  description = "GCP Project ID"
}

# variable "auth_file" {
#   description = "GCP Project auth file"
# }

variable "region" {
}

variable "fw_panos" {
  description = "VM-Series license and PAN-OS (ie: bundle1-814, bundle2-814, or byol-814)"
}

variable "fw_image" {
  default = "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/vmseries"
}

variable "fw_names_inbound" {
  type = list(string)
}

variable "fw_names_outbound" {
  type = list(string)
}

variable "fw_machine_type" {
}

variable "glb_name" {
}

variable "ilb_name" {
}

variable "mgmt_vpc" {
}

variable "mgmt_subnet" {
  type = list(string)
}

variable "mgmt_cidr" {
  type = list(string)
}

variable "untrust_vpc" {
}

variable "untrust_subnet" {
  type = list(string)
}

variable "untrust_cidr" {
  type = list(string)
}

variable "trust_vpc" {
}

variable "trust_subnet" {
  type = list(string)
}

variable "trust_cidr" {
  type = list(string)
}

variable "mgmt_sources" {
  type = list(string)
}

variable "spoke1_vpc" {
}

variable "spoke1_subnets" {
  type = list(string)
}

variable "spoke1_cidrs" {
  type = list(string)
}

variable "spoke1_vms" {
  type = list(string)
}

variable "spoke1_ilb" {
}

variable "spoke1_ilb_ip" {
}

variable "spoke2_vpc" {
}

variable "spoke2_subnets" {
  type = list(string)
}

variable "spoke2_cidrs" {
  type = list(string)
}

variable "spoke2_vms" {
  type = list(string)
}

variable "spoke_user" {
  description = "SSH user for spoke Linux VM"
}

variable "public_key_path" {
  description = "Local path to public SSH key.  If you do not have a public key, run >> ssh-keygen -f ~/.ssh/demo-key -t rsa -C admin"
}
