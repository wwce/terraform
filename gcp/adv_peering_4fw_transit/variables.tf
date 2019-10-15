provider "google" {
  project     = var.project_id
  region      = var.region
}

provider "google-beta" {
  project     = var.project_id
  region      = var.region
  version     = "> 2.13.0"
}

terraform {
  required_version = ">= 0.12"
}

variable "project_id" {
  description = "GCP Project ID"
}

variable "region" {
}

variable "zones" {
  type = list(string)
}

variable "ssh_user" {
  description = "SSH user for linux instances.  Default will use project keys."
  default = ""  # Add colon to the end of username (i.e. ubuntu:).  This will format the metadata correctly.
}

variable "ssh_key" {
  description = "SSH key for linux VMs.  Default will use project keys."
  default = ""
}

variable "fw_panos" {
  description = "VM-Series license and PAN-OS (ex: bundle1-819, bundle2-819, byol-819)"
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
